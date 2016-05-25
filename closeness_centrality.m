%% Dissertation: April 2016
% Author: Jack Shipway - jack.shipway.12@ucl.ac.uk

function rtn = closeness_centrality(temporal_graph, num_ticks, num_nodes)
%    Compute the normalised closeness centrality score of 
%    each node in a temporal network
%
%    Parameters
%    __________
%    temporal_graph: a cell containing static graphs in each slot
%    num_ticks: number of timesteps over which the network is defined
%    num_nodes: number of nodes in the network
%
%    Output
%    ______
%    normalised_closeness_scores: normalised closeness scores of each node

% Initialise scores of zero for each node and tick
closeness = zeros(num_nodes, num_nodes-1);
closeness_scores = zeros(1, num_nodes);

% Approximately how many loops make up 1% of function completion
total_calls = floor((num_ticks - 1) * num_nodes * (num_nodes - 1) / 100);
% Initialise a percentage completion indicator and number of function calls
percent_complete = 0;
calls = 0;

fprintf('Computing Temporal Closeness Centrality 1/2...\nPercentage Complete: %d%%\n', percent_complete);
for i = 1 : num_ticks - 1
    % Number of source nodes
    source_nodes = num_nodes * num_ticks;
    % Initialise all nodes to point to themselves at each tick
    s = setdiff((1 : source_nodes), (1 : (i-1) * num_nodes));
    t = s + num_nodes;
    % Add the randomly generated edges
    for j = i : num_ticks
        if ~isempty(temporal_graph{j})
            num_per_timestep = numel(temporal_graph{j}(:,1));
        else
            num_per_timestep = 0;
        end
        for k = 1 : num_per_timestep
            s = [s, temporal_graph{j}(k, 1) + ((j-1) * num_nodes)];
            t = [t, (temporal_graph{j}(k, 2) + ((j-1) * num_nodes)) + num_nodes];
        end
    end
    
    % Recentralise the graphs
    s = s - ((i-1) * num_nodes);
    t = t - ((i-1) * num_nodes);
    % Construct temporal digraph from s & t
    G = digraph(s, t);
    % Initialise shortest temporal path matrix
    STP = zeros(num_nodes);

    %% Breadth-first search of digraph from all nodes over all ticks
    node_traversal = cell(1, num_nodes);
    actual_nodes = cell(1, num_nodes);
    for j = 1 : num_nodes
        node_traversal{j} = bfsearch(G, j);
        actual_nodes{j} = mod(node_traversal{j} - 1, num_nodes);
    end

    % Compute all distinct pairs of nodes
    [m, n] = meshgrid(1 : num_nodes, 1 : num_nodes);
    all_pairs = [m(:), n(:)];
    % Number of pairs of nodes
    num_pairs = numel(all_pairs) / 2;

    % Obtain indices of self-pointing edges 
    rep_index = zeros(1, num_nodes);
    index_self = 1;
    for j = 1 : num_pairs
        if (isequal(all_pairs(j, 1), all_pairs(j, 2)))
            rep_index(index_self) = j;
            index_self = index_self + 1;
        end
    end

    % Remove unwanted edges
    all_pairs(rep_index, :) = [];
    % Number of pairs of nodes
    [num_pairs, ~] = size(all_pairs);

    % Initialise a cell to store
    indices = cell(1, num_pairs);
    % Set of all nodes
    all_nodes = 1 : num_nodes;

    % Compute STP matrix
    count = 1;
    close = zeros(num_nodes, num_nodes - 1);
    for j = 1 : num_nodes
        target_nodes = setdiff(all_nodes, all_nodes(j));
        for k = 1 : num_nodes - 1
            calls = calls + 1;
            if calls == total_calls
                percent_complete = percent_complete + 1;
                clc
                fprintf('Computing Temporal Closeness Centrality 1/2...\nPercentage Complete: %d%%\n', percent_complete);
                calls = 0;
            end

            indices{count} = find(actual_nodes{all_pairs(count, 1)} == target_nodes(k) - 1);
            if ~isempty(indices{count})
                STP(j, target_nodes(k)) = floor((min(node_traversal{j}(indices{count}))-1) / num_nodes) + 1;
            else
                STP(j, target_nodes(k)) = inf;
            end
            close(j, k) = (1/STP(j, target_nodes(k)));
            count = count + 1;
        end
    end 
    closeness = closeness + close;
end

for i = 1 : num_nodes
    closeness_scores(i) = sum(closeness(i, :));
end

% Normalised Results
normalised_closeness_scores = closeness_scores / ((num_nodes - 1) * num_ticks);
fprintf('Computing Temporal Closeness Centrality 2/2...\nPercentage Complete: 100%%\n')
% Return a normalised closeness score for each node
rtn = normalised_closeness_scores;
fprintf('Finished Computing Temporal Closeness Centrality\n');
end