function rtn = delay_centrality(temporal_graph, num_ticks, num_nodes)
%   Compute the temporal delay centrality of each node in a temporal network
%
%   Parameters
%   __________
%   temporal_graph -- temporal graph representing network snapshots
%   num_ticks -- number of time steps over which the network is defined
%   num_nodes -- number of nodes defined on the network
%
%   Output
%   ______
%   The normalised delay centrality score for each node

% Set of all nodes
all_nodes = 1 : num_nodes;

%% Transformation from static to temporal digraph
% Number of source nodes
source_nodes = num_nodes * num_ticks;
% Initialise all nodes with self-loops at each timestep (a_0 -> a_1 etc)
s = 1 : source_nodes;
t = s + num_nodes;

% Add randomly generated edges
for i = 1 : num_ticks
    if ~isempty(temporal_graph{i})
        num_per_timestep = numel(temporal_graph{i}(:,1));
    else
        num_per_timestep = 0;
    end
    for j = 1 : num_per_timestep
        s = [s, temporal_graph{i}(j,1) + ((i-1) * num_nodes)];
        t = [t, (temporal_graph{i}(j,2) + ((i-1) * num_nodes)) + num_nodes];
    end
end

% Construct temporal digraph from s & t
G = digraph(s, t);

% Distinct pairs of nodes
[source, sink] = meshgrid(1 : num_nodes, 1 : num_nodes);
all_pairs = [source(:), sink(:)];
% Number of pairs of nodes
[num_pairs, ~] = size(all_pairs);

% Indices of self-pointing edges 
rep_index = zeros(1, num_nodes);
index_self = 1;
for j = 1 : num_pairs
    if (isequal(all_pairs(j, 1), all_pairs(j, 2)))
        rep_index(index_self) = j;
        index_self = index_self + 1;
    end
end

% Remove self-pointing edges
all_pairs(rep_index, :) = [];
% New number of pairs of nodes
[num_pairs, ~] = size(all_pairs);

% Initialise shortest temporal path matrices
[num_STP_time, STP_time] = deal(cell(1, num_ticks));


count2 = 0;
total_calls = floor(num_ticks * num_nodes * (num_nodes - 1)) / 100;
percent_complete = 0;
fprintf('Computing Delay Betweenness Centrality 1/2...\nPercentage Complete: %d%%\n', percent_complete);

for i = 1 : num_ticks
    % Breadth-first search of digraph from all nodes in [t_i, t_n]
    [node_discovered, node_traversal, actual_nodes] = deal(cell(1, num_nodes));
    for j = 1 : num_nodes
        node_traversal{j} = bfsearch(G, (j + ((i - 1) * (num_nodes))));
        node_discovered{j} = bfsearch(G, (j + ((i - 1) * (num_nodes))), 'edgetodiscovered');
        actual_nodes{j} = mod(node_traversal{j} - 1, num_nodes);
    end
    
    indices = cell(1, num_pairs);
    
    % Initialise STP and num_STP matrices
    [STP, num_STP] = deal(zeros(num_nodes));

    count = 1;
    for j = 1 : num_nodes
        target_nodes = setdiff(all_nodes, all_pairs(count, 1));
        for k = 1 : (num_nodes - 1)
            count2 = count2 + 1;
            if count2 == total_calls
                percent_complete = percent_complete + 1;
                clc
                fprintf('Computing Delay Betweenness Centrality 1/2...\nPercentage Complete: %d%%\n', percent_complete);
                count2 = 0;
            end

            indices{count} = find(actual_nodes{all_pairs(count, 1)} == (target_nodes(k) - 1));
            if ~isempty(indices{count})
                temporal_path = floor((min(node_traversal{j}(indices{count})) - 1) / num_nodes) - i + 1;
                STP(j, target_nodes(k)) = temporal_path;
                num_STP(j, target_nodes(k)) = 1;
            else
                STP(j, target_nodes(k)) = inf;
                num_STP(j, target_nodes(k)) = 1;
            end
            count = count + 1;
        end
    end
    % Update matrices for each time interval
    STP_time{i} = STP;
    num_STP_time{i} = num_STP;
end

% Initialise betweenness centrality 
delay_centrality = zeros(1, num_nodes);
count = 1;
count3 = 0;
percent_complete2 = 0;
total_calls2 = (num_nodes * (num_nodes - 1)) / 100;
clc
fprintf('Computing Delay Betweenness Centrality 2/2...\nPercentage Complete: %d%%\n', percent_complete2);

for i = 1 : num_nodes
    % Compute the betweenness centrality of a node
    for j = 1 : (num_nodes - 1)
        count3 = count3 + 1;
        if count3 == total_calls2
            percent_complete2 = percent_complete2 + 1;
            clc
            fprintf('Computing Delay Betweenness Centrality 2/2...\nPercentage Complete: %d%%\n', percent_complete2);
            count3 = 0;
        end

        node = i;
        rows_to_remove = any(all_pairs == i, 2);
        pairs = all_pairs;
        pairs(rows_to_remove, :) = [];
        % Brandes Algorithm
        source_to_sink = STP_time{1}(pairs(j, 1), pairs(j, 2));
        source_to_node = STP_time{1}(pairs(j, 1), node);
        if source_to_sink == inf
            source_to_node = 0;
            node_to_sink = 0;
            num_paths = inf;
            delay = 0;
        else
            if source_to_node < num_ticks 
                node_to_sink = STP_time{source_to_node + 1}(node, pairs(j, 2));
            else
                source_to_node = 0;
                node_to_sink = 0;
                num_paths = inf;
                delay = 0;
            end
            if ~(source_to_sink > (source_to_node + node_to_sink)) && (node_to_sink < inf)
                num_paths = num_STP_time{1}(pairs(j, 1), node) * num_STP_time{source_to_node + 1}(node, pairs(j, 2));
                delay = node_to_sink - 1; 
            else
                source_to_node = 0;
                node_to_sink = 0;
                num_paths = inf;
                delay = 0;
            end
        end
        % Compute the proportion of total STPs with node as an intermediary
        if num_paths == 0
            delay_dependency = 0;
        else
            delay_dependency = delay / num_paths;
        end
        % Sum betweenness over pair-dependencies
        delay_centrality(node) = delay_centrality(node) + delay_dependency;
        count = count + 1;
    end
end

% Return numerical betweenness values for each node
rtn = delay_centrality / ((num_nodes - 1) * (num_nodes - 2));

clc
fprintf('Computing Delay Betweenness Centrality 2/2...\nPercentage Complete: 100%%\n')
fprintf('Finished computing Delay Betweenness Centrality\n');
end