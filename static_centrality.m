%% Dissertation: April 2016
% Author: Jack Shipway - jack.shipway.12@ucl.ac.uk

function static_scores = static_centrality(temporal_graph, num_ticks, num_nodes)
% Compute the static centrality of each node in a temporal network, 
% having aggregated the data into a static network
%
%   Parameters
%   __________
%   temporal_graph: Series of graphs containing time-labelled edges
%   num_ticks: number of timesteps over which the graph is defined 
%
%   Output
%   ______
%   static_scores: The static centrality scores of each node

disp('Started Computing Static Betweenness Centrality');

% Aggregate the data into a single timestep
aggregated_adjacency = aggregate(temporal_graph, num_ticks);

% Return normalised static betweenness centrality for each node
static_scores = bc_static(aggregated_adjacency) / (num_ticks);
static_scores(10) = 0;

disp('Finished Computing Static Betweenness Centrality');
end