%% Methodology: Lerman Clustering of a data set
clear; clc;

NUM_NODES = 4;

s = [1,2,3,4,1];
t = [2,3,4,1,3];
% Construct temporal digraph from s & t
G = graph(s, t);
plot(G);

%% Define Laplacian - 4 different flavours 
% Normalised Laplacian: W = A, T = I
% Adjacency matrix A_1
A_1 = full(adjacency(G));
% Degree of each node
node_degree = zeros(1, NUM_NODES);
for i = 1 : NUM_NODES
    node_degree(i) = sum(A_1(i, :));
end
% Diagonal matrix D
D = diag(node_degree);

% Compute the Normalised Laplacian
L1 = eye(NUM_NODES) - (D^(-0.5) * A_1 * D^(-0.5));
% Compute eigenvalues and eigenvectors
[a, b] = eig(L1);
% Find eigenvector ~ 2nd smallest eigenvalue
[~, index] = min(node_degree);
eig_second = a(:, 2);

% Vector g = ..
g = zeros(1, 3);
for i = 1 : NUM_NODES
    g(i) = eig_second(i) * (node_degree(i))^0.5;
end
[~, ordered_nodes] = sort(g, 'descend');

for i = 1 : NUM_NODES - 1
    subset_i = ordered_nodes(1:i);
    subset_j = ordered_nodes(i+1:NUM_NODES);
    cut_ij = 0;
    for j = 1 : numel(subset_i)
        cut_ij = cut_ij + sum(A_1(subset_i(j), :));
    end
    
    
    adj_i = A_1(subset_i, :);
    adj_i = adj_i(:, subset_i);
    volume_i = sum(adj_i(:));
    
    
    adj_j = A_1(subset_j, :);
    adj_j = adj_j(:, subset_j);
    volume_j = sum(adj_j(:)); 
    
    cut_ij
    volume_i
    volume_j
    conductance = cut_ij / min(volume_i, volume_j)
end







% % % Scaled Laplacian: W = A, T = I
% % L2 = eye(num_nodes) - 
% % 
% % % Replicator Laplacian: W = A, T = I
% % L3 = eye(num_nodes) - 
% % 
% % % Unbiased Adjacency Laplacian: W = A, T = I
% % L4 = eye(num_nodes) - 
% % 
% 
% % %% Perform Spectral Dynamics Clustering
% % [S1,T1] = spectral_clustering(G, L1);
% % [S2,T2] = spectral_clustering(G, L1);
% % [S3,T3] = spectral_clustering(G, L1);
% % [S4,T4] = spectral_clustering(G, L1);
% % 
% % 
% 




