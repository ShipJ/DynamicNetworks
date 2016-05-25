%% Dissertation: April 2016
% Author: Jack Shipway - jack.shipway.12@ucl.ac.uk

function static_adj = aggregate(temporal_graph, num_ticks)
%   Take a temporal graph and aggregate it into static one
%
%   Parameters
%   __________
%   temporal_graph: data set containing time-labelled edges
%   num_ticks: number of ticks over which the data are defined
%
%   Output
%   ______
%   static_adj: adjacency matrix of the final static graph

static_edges = [];

% Combine all edges into a single timestep, ensuring they are unique
for i = 1 : num_ticks
    try
        static_edges = unique([static_edges; temporal_graph{i}(:, 1:2)], 'rows'); 
        s = static_edges(:, 1);
        t = static_edges(:, 2);
        G = digraph(s, t);
    catch
    end
    
end

% Return the resultant adjacency matrix representation of the static graph
a = adjacency(G);
static_adj = full(a);
end

