%% Dissertation: April 2016
% Author: Jack Shipway - jack.shipway.12@ucl.ac.uk
%   This script demonstrates how to retrieve a formatted data set, transform 
%   it into a temporal digraph, and compute the metrics in the report that
%   accompany this project.
clear; clc;

%% Data Retrieval 
filename = 'onager_data.csv';
delimiter = ',';
startRow = 1;
formatSpec = '%f%f%f%[^\n\r]';
fileID = fopen(filename,'r');
raw_data = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' , NaN, 'HeaderLines' ,startRow - 1, 'ReturnOnError', false);
fclose(fileID);

%% Retrieve Temporal Data Set 
temporal_data = [raw_data{1}, raw_data{2}, raw_data{3}];

%% Obtain Data Set Attributes
% Interactions = Number of samples
NUM_EDGES = numel(temporal_data(:, 1)); 
% Either know a priori or derive from the number of unique individuals
NUM_NODES = numel(unique(temporal_data(:, 1:2))); 
% How many timesteps we examine network over
NUM_TICKS = max(temporal_data(:, 3)); 
% 'Cost' associated with each interaction
MAX_AMOUNT = 100; 

%% Construct Temporal digraph
temporal_graph = temporal_graph(temporal_data, NUM_TICKS);

%% Global Network Measures
% Density 
% density = density(temporal_graph, NUM_TICKS);
% Clustering coefficient 
% avg_clustering_coefficient = avg_clustering_coefficient(temporal_graph, NUM_TICKS);
% 
% %% Clustering Measures
% % Conductance
% conductance = conductance(temporal_graph, NUM_TICKS, NUM_NODES);
% % Spectral Clustering
% % spectral_cluster = spectral_cluster(temporal_data, NUM_TICKS);

%% Centrality Measures
% Degree centrality
[in_degree_scores, out_degree_scores] = degree_centrality(temporal_data, NUM_TICKS, NUM_NODES);
% Closeness centrality
closeness_scores = closeness_centrality(temporal_graph, NUM_TICKS, NUM_NODES);
% Static betweenness centrality
static_scores = static_centrality(temporal_graph, NUM_TICKS);
% Temporal betweenness centrality 
temporal_betweenness_scores = betweenness_centrality(temporal_graph, NUM_TICKS, NUM_NODES);
% Delay betweenness centrality 
delay_betweenness_scores = delay_centrality(temporal_graph, NUM_TICKS, NUM_NODES);

%% Plot of Global and Clustering Measures 
% 
% for i = 1:74
%     if density(i) == inf
%         density(i) = 0;
%     end
% end
% 
% 
% figure
% hold on
% plot(1:num_ticks, avg_clustering_coefficient);
% plot(1 : NUM_TICKS, density);
% plot(1 : NUM_TICKS, conductance);xlabel('Tick', 'FontSize', 18); ylabel('Metric Score', 'FontSize', 18);
%     legend('Density', 'Conductance');
%     set(gcf,'Color',[1,1,1]);
%     axis([0, 74, 0, 1.1]);
% hold off
    
%% Plots of Centrality results (sorted)
fprintf('\nPlotting results...\n');
figure
% Degree centrality 
subplot(2, 3, 1); bar([sort(in_degree_scores, 'descend'); sort(out_degree_scores, 'descend')]); str = {'Node'; 'Node'}; set(gca, 'XTickLabel', str, 'XTick',1 : numel(str), 'FontSize', 14); xlabel('In-degree          Out-degree'); ylabel('Degree Centrality', 'FontSize', 14);
    title('Temporal In and Out-Degree Centrality', 'fontsize', 14);
% Closeness centrality
subplot(2, 3, 2); bar(sort(closeness_scores, 'descend')); xlabel('Node', 'FontSize', 14); ylabel('Closeness Centrality', 'FontSize', 14); 
    title('Temporal Closeness Centrality', 'fontsize', 14);
% Temporal betweenness centrality
subplot(2, 3, 3); bar(sort(temporal_betweenness_scores, 'descend')); xlabel('Node', 'FontSize', 14); ylabel('Betweenness Centrality', 'FontSize', 14);
    title('Temporal Betweenness Centrality', 'fontsize', 14);
% Delay betweenness centrality
subplot(2, 3, 4); bar(sort(delay_betweenness_scores, 'descend')); xlabel('Node', 'FontSize', 14); ylabel('Delay Centrality', 'FontSize', 14);
    title('Temporal Delay Centrality', 'fontsize', 14);
% Static centrality 
subplot(2, 3, 5); bar(sort(static_scores, 'descend')); xlabel('Node', 'FontSize', 14); ylabel('Static Centrality', 'FontSize', 14);
    title('Static Betweenness Centrality', 'fontsize', 14);
%% Comparative plot
subplot(2, 3, 6); 
hold on
plot(1 : NUM_NODES, sort(in_degree_scores, 'descend'), 1 : NUM_NODES, sort(out_degree_scores, 'descend'),...
     1 : NUM_NODES, sort(closeness_scores, 'descend'), 1 : NUM_NODES, sort(temporal_betweenness_scores, 'descend'),...
     1 : NUM_NODES, sort(delay_betweenness_scores, 'descend'), 1 : NUM_NODES, sort(static_scores(1:NUM_NODES), 'descend')); xlabel('Node', 'FontSize', 14); ylabel('Centrality Score', 'FontSize', 14);
        title('A Comparison Of All Measures (Sorted)', 'fontsize', 14);
        legend('in-degree', 'out-degree','closeness', 'temporal', 'delay', 'static', 'location', 'northeast'); 
        set(gcf,'Color',[1,1,1])
hold off

%% Plots of Centrality results (unsorted)
figure
%% Degree centrality 
subplot(2, 3, 1); bar([in_degree_scores; out_degree_scores]); str = {'Node'; 'Node'}; set(gca, 'XTickLabel', str, 'XTick',1 : numel(str), 'FontSize', 14); xlabel('In-degree          Out-degree');ylabel('Degree Centrality', 'FontSize', 14);
    title('Temporal In and Out-Degree Centrality', 'fontsize', 14);
%% Closeness centrality
subplot(2, 3, 2); bar(closeness_scores); xlabel('Node', 'FontSize', 14); ylabel('Closeness Centrality', 'FontSize', 14); 
     title('Temporal Closeness Centrality', 'fontsize', 14);
%% Temporal betweenness centrality
subplot(2, 3, 3); bar(temporal_betweenness_scores); xlabel('Node', 'FontSize', 14); ylabel('Betweenness Centrality', 'FontSize', 14);
    title('Temporal Betweenness Centrality', 'fontsize', 14);
%% Delay betweenness centrality
subplot(2, 3, 4); bar(delay_betweenness_scores); xlabel('Node', 'FontSize', 14); ylabel('Delay Centrality', 'FontSize', 14);
    title('Temporal Delay Centrality', 'fontsize', 14);
%% Static centrality 
subplot(2, 3, 5); bar(static_scores); xlabel('Node', 'FontSize', 14); ylabel('Static Centrality', 'FontSize', 14);
    title('Static Betweenness Centrality', 'fontsize', 14);
%% Comparison
subplot(2, 3, 6);
hold on
plot(1:NUM_NODES, in_degree_scores, 1:NUM_NODES, out_degree_scores, 1:NUM_NODES, closeness_scores, ...
    1:NUM_NODES, temporal_betweenness_scores, 1:NUM_NODES, delay_betweenness_scores, 1:NUM_NODES, ...
    static_scores(1:NUM_NODES)); xlabel('Node', 'FontSize', 14); ylabel('Centrality Score', 'FontSize', 14);
        title('A Comparison Of All Measures (Unsorted)', 'fontsize', 14);
        legend('in-degree', 'out-degree','closeness', 'temporal', 'delay', 'static', 'location', 'northeast'); 
        set(gcf,'Color',[1,1,1])
hold off
fprintf('...Finished Plotting results\n');