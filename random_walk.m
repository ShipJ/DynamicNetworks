%% Work In Progress %%

function rtn = random_walk(temporal_graph, num_ticks, num_nodes, repeat)
% Perform a random walk rather than a BFS from each
% source node 

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

occurrences = 0;
for k = 1 : repeat
    paths = zeros(num_nodes, num_ticks + 1);
    for i = 1 : num_nodes
        node = i;
        path = node;
        for j = 1 : num_ticks
            next = successors(G, node);
            rand_walk = next(randi(numel(next)));
            path = [path, rand_walk];
            node = rand_walk;     
        end
        paths(i, :) = path;
    end

    total_reached = num_nodes * (num_ticks + 1);

    occurrence = zeros(1, num_nodes);
    for i = 1 : num_nodes
        actual_nodes = mod(paths - 1, num_nodes);
        node_i = numel(find(actual_nodes == (i - 1)));
        node_i_prob = node_i / total_reached;
        occurrence(i) = node_i_prob;
    end
    occurrences = occurrences + occurrence;
end
occur_probability = occurrences / repeat;

rtn = occur_probability;
end