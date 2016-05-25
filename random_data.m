%% Dissertation: April 2016
% Author: Jack Shipway - jack.shipway.12@ucl.ac.uk

function rtn = random_data(edges, nodes, ticks, amount)
% Returns a random graph with specified number of edges, nodes and ticks
%
%   Parameters
%   __________
%   ticks: max number of timesteps
%   edges: number of edges in the graph
%   nodes: number of nodes in the graph
%   amount: maximum 'amount' of a transaction (weight eg. £100)
%
%   Outputs
%   _______
%   edge_stream: a stream of temporal edges 

disp('Initialising data...');

% (Un)comment to (un)repeat the same random generation
rng(1);

% Number of data set attributes 
num_components = 4;
% Empty matrix to store random source/target nodes
data_matrix = zeros(edges, num_components);
% Random nodes to connect
rand_nodes = randi([1, nodes], 1, (num_components-1) * edges);
% Random ticks
rand_ticks = randi([1, ticks], 1, edges);
% Random amount of money (weight)
rand_amount = randi([1, amount], 1, edges);

% Compute matrix of source -> target edges
for i = 1 : edges
    data_matrix(i, 1:3) = [rand_nodes(i), rand_nodes(edges + i), rand_ticks(i)];
    while isequal(data_matrix(i, 1), data_matrix(i, 2))
        data_matrix(i, 2) = randi([1, nodes], 1, 1);
    end
end

% Ensure all interactions are unique and time-ordered
edge_stream = sortrows(unique(data_matrix, 'Rows'), 3);
num_edges = numel(edge_stream(:,1));

% Add a random quantitative amount for each interaction
for i = 1 : num_edges
    edge_stream(i, 4) = rand_amount(i);
end
% Return edge stream representation
rtn = edge_stream;
disp('...Data initialised');
end