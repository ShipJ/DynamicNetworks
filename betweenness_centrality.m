%% Dissertation: April 2016
% Author: Jack Shipway - jack.shipway.12@ucl.ac.uk

function rtn = betweenness_centrality(temporal_graph, num_ticks, num_nodes)
%   Returns the normalised temporal betweenness centrality score of 
%   each node in a temporal network
%
%   Parameters
%   __________
%   temporal_graph -- temporal graph representing network snapshots
%   num_ticks -- number of timesteps over which the network is defined
%   num_nodes -- number of nodes in the network
%   
%   Output
%   ______
%   normalised_betweenness_scores: normalised betweenness score of all nodes

% Set of all nodes
all_nodes = 1 : num_nodes;

%% Transformation from static to temporal digraph
% Number of source nodes (all nodes bar the nodes in the final tick)
source_nodes = num_nodes * num_ticks;
% Initialise sources with self-loops at each timestep (a_0 -> a_1 etc)
s = 1 : source_nodes;
% Initialise all target nodes (all bar the nodes in the first tick)
t = s + num_nodes;

%% Add randomly generated edges
% Over each tick
for i = 1 : num_ticks
    % Retrieve number of edges per tick
    if ~isempty(temporal_graph{i})
        num_per_timestep = numel(temporal_graph{i}(:, 1));
    % If empty, number of edges = 0
    else
        num_per_timestep = 0;
    end
    % For each edge occurring within each tick
    for j = 1 : num_per_timestep
        % Add the source node to s, the target node to t
        s = [s, temporal_graph{i}(j,1) + ((i-1) * num_nodes)];
        t = [t, (temporal_graph{i}(j,2) + ((i-1) * num_nodes)) + num_nodes];
    end
end

%% Construct temporal digraph from s & t
% Using Matlab's built in digraph function
G = digraph(s, t);

% List of distinct pairs of nodes (there should be n!/(k!(n-k!))
[source, target] = meshgrid(1 : num_nodes, 1 : num_nodes);
all_pairs = [source(:), target(:)];
% Number of pairs of nodes
[num_pairs, ~] = size(all_pairs);

% Retrieve the indices of self-pointing edges and remove them
rep_index = zeros(1, num_nodes);
index_self = 1;
for j = 1 : num_pairs
    if (isequal(all_pairs(j, 1), all_pairs(j, 2)))
        rep_index(index_self) = j;
        index_self = index_self + 1;
    end
end
% Want distinct pairs only (remove A->A etc)
all_pairs(rep_index, :) = [];
% New number of pairs of nodes
[num_pairs, ~] = size(all_pairs);

% Initialise a cell to store each STP and NSTP matrix, for each tick
[num_STP_time, STP_time] = deal(cell(1, num_ticks));

% Number of function calls to estimate completion percentage
total_calls = (num_ticks * num_nodes * (num_nodes - 1)) / 100;
percentage_complete = 0;

clc
% Display for user purposes
fprintf('Computing Temporal Betweenness Centrality 1/2...\nPercentage Complete: %d%%\n', percentage_complete);
percent_count = 0;

%% Compute the length and number of STPs between node-pairs
for i = 1 : num_ticks
    % Breadth-first search of digraph from each source node, for each tick
    [node_discovered, node_traversal, actual_nodes] = deal(cell(1, num_nodes));
    for j = 1 : num_nodes
        % Store the sequence of nodes obtained by a BFS
        node_traversal{j} = bfsearch(G, (j + ((i - 1) * (num_nodes))));
        % Flag when discovered a node from an alternative route
        node_discovered{j} = bfsearch(G, (j + ((i - 1) * (num_nodes))), 'edgetodiscovered');
        % Modulus of all nodes obtains original nodes, (as explained in thesis)
        actual_nodes{j} = mod(node_traversal{j} - 1, num_nodes);
    end
    
    % Initialise a cell to store temporal path target nodes
    indices = cell(1, num_pairs);
    % Initialise STP and num_STP matrices (for a single tick)
    [STP, num_STP] = deal(zeros(num_nodes));

    % Initialise count to compute metric for each pair of nodes
    count = 1;
    % For each node
    for j = 1 : num_nodes
        % Obtain set of distinct target nodes
        target_nodes = setdiff(all_nodes, all_pairs(count, 1));
        % For each target node
        for k = 1 : (num_nodes - 1)
            % Get the index of where a temporal path
            indices{count} = find(actual_nodes{all_pairs(count, 1)} == (target_nodes(k) - 1));
            if ~isempty(indices{count})
                alternative_route = 1;
                temporal_path = floor((min(node_traversal{j}(indices{count})) - 1) / num_nodes) - i + 1;
                STP(j, target_nodes(k)) = temporal_path;
                alternative_routes = numel(find(node_discovered{j}(:, 1) < (num_nodes * (temporal_path - 1))));
                num_STP(j, target_nodes(k)) = alternative_route;
            else
                % If there is no path, its length is defined to be infinite
                STP(j, target_nodes(k)) = inf;
                % The number of paths is thus 0
                num_STP(j, target_nodes(k)) = 0;
            end
            count = count + 1;
            % Increment function completion estimation
            percent_count = percent_count + 1;
            if percent_count == total_calls
                percentage_complete = percentage_complete + 1;
                % Display to the user the percentage complete
                clc
                fprintf('Computing Temporal Betweenness Centrality 1/2...\nPercentage Complete: %d%%\n', percentage_complete);
                % Reset count for part 2
                percent_count = 0;
            end
        end
    end
    % Update matrices for each tick
    STP_time{i} = STP;
    num_STP_time{i} = num_STP;  
end

% 
total_calls2 = num_nodes * (num_nodes - 1) / 100;
percentage_complete_2 = 0;
fprintf('Computing Temporal Betweenness Centrality 2/2...\nPercentage Complete: %d%%\n', percentage_complete_2);
percent_count = 0;

% Initialise betweenness centrality scores
betweenness_centrality = zeros(1, num_nodes);
count = 1;
% For each node
for i = 1 : num_nodes
    % For each other node, compute betweenness centrality score
    for j = 1 : (num_nodes - 1)
        % Set 'intermediate' node
        node = i;
        % Remove non-distinct pairs of nodes
        rows_to_remove = any(all_pairs == i, 2);
        pairs = all_pairs;
        pairs(rows_to_remove, :) = [];
        %% Employ Brandes Algorithm - explained in thesis
        a = STP_time{1}(pairs(j, 1), pairs(j, 2));
        b = STP_time{1}(pairs(j, 1), node);
        if a == inf
            b = 0; c = 0; num_paths = inf;
        else
            if b < num_ticks 
                c = STP_time{b+1}(node, pairs(j, 2));
            else
                b = 0; c = 0; num_paths = inf;
            end
            
            if ~(a > (b + c)) && (c < inf)
                num_paths = num_STP_time{1}(pairs(j, 1), node) * num_STP_time{b}(node, pairs(j, 2));
            else
                b = 0; c = 0; num_paths = inf;
            end
        end
        % Compute the proportion of STPs with node as an intermediary
        if num_paths == 0
            proportion = 0;
        else
            proportion = (b + c) / num_paths;
        end
        % Sum betweenness over pair-dependencies
        betweenness_centrality(node) = betweenness_centrality(node) + proportion;
        count = count + 1;       
        percent_count = percent_count + 1;
        if percent_count == total_calls2
            percentage_complete_2 = percentage_complete_2 + 1;
            clc
            fprintf('Computing Temporal Betweenness Centrality 2/2...\nPercentage Complete: %d%%\n', percentage_complete_2);
            percent_count = 0;
        end
    end
end

% Normalise Results
normalised_betweenness_centrality = betweenness_centrality / ((num_nodes - 1) * (num_nodes - 2));
% Return numerical betweenness values for each node
rtn = normalised_betweenness_centrality;

fprintf('Computing Temporal Betweenness Centrality 2/2...\nPercentage Complete: 100%%\n')  
fprintf('Finished Computing Temporal Betweenness Centrality\n');
end