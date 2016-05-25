%% Dissertation: April 2016
% Author: Jack Shipway - jack.shipway.12@ucl.ac.uk

function [in, out] = degree_centrality(data_set, num_ticks, num_nodes)
% Compute and normalise the in-degree and out-degree centrality  of each 
% node in a temporal graph
%
%   Parameters
%   __________
%   data_set: the interaction data defining the dynamic network
%   num_ticks: number of ticks over which the network is defined
%   num_nodes: the number of nodes in the network
%
%   Outputs
%   _______
%   in_degree: the in-degree centrality score for each node
%   out_degree: the out-degree centrality score for each node

disp('Started Computing Temporal Degree Centrality');

% Retrieve data set dimensions
[interactions, ~] = size(data_set);

% Initialise in/out degree values for each node
in_degree = zeros(1, num_nodes);
out_degree = zeros(1, num_nodes);

% Each path where node_i is the source/target, add 1 to corresponding entry
for i = 1 : interactions
    try
        % Incident edges
        in = data_set(i, 2);
        % Outgoing edges
        out = data_set(i, 1);
        in_degree(in) = in_degree(in) + 1;
        out_degree(out) = out_degree(out) + 1;
    catch 
        error('out of bounds exception')
    end
end

% Return the normalised in and out-degree scores
in = in_degree / ((num_nodes - 1) * num_ticks);
out = out_degree / ((num_nodes - 1) * num_ticks);

disp('Finished Computing Temporal Degree Centrality');
end