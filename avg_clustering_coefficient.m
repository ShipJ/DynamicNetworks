function rtn = avg_clustering_coefficient(temporal_graph, num_ticks)
% Compute the average clustering coefficient of each node in the dynamic
% network at each tick.
%
%   Parameters
%   __________
%   temporal_graph: 
%   num_ticks: 
%   
%   Outputs
%   _______
%   avg_clustering coefficient

index = zeros(1, num_ticks);
for i = 1 : num_ticks 
    s = temporal_graph{i}(:, 1);
    t = temporal_graph{i}(:, 2);
    G = digraph(s, t);
    a = adjacency(G);
    static_adj = full(a);
    index(i) = cluster_coeffs(static_adj);
end

% Return the average node clustering coefficient, at each tick
rtn = index;
end

