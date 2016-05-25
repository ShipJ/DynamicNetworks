%% Dissertation: April 2016
% Author: Jack Shipway - jack.shipway.12@ucl.ac.uk
%   Script for performing centrality measures
%   on randomly generated data
clear; clc;

% Re-generate same random data set (given parameters)
s = rng;
% User set parameters
NUM_EDGES = 10; 
NUM_NODES = 10; 
NUM_TICKS = 100; 
MAX_AMOUNT = 4;

%% Construct Random Temporal Data Set
temporal_data = random_data(NUM_EDGES, NUM_NODES, NUM_TICKS, MAX_AMOUNT);

%% Temporal digraph
temporal_graph = temporal_graph(temporal_data, NUM_TICKS);

%% Centrality Measures
% Degree centrality
[in_degree_scores, out_degree_scores] = degree_centrality(temporal_data, NUM_TICKS, NUM_NODES);
% Closeness centrality
closeness_scores = closeness_centrality(temporal_graph, NUM_TICKS, NUM_NODES);
% Static betweenness centrality
static_scores = static_centrality(temporal_graph, NUM_TICKS, NUM_NODES);
% Temporal betweenness centrality 
temporal_betweenness_scores = betweenness_centrality(temporal_graph, NUM_TICKS, NUM_NODES);
% Delay betweenness centrality 
delay_betweenness_scores = delay_centrality(temporal_graph, NUM_TICKS, NUM_NODES);

%% Plots of results (sorted)
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

% Plots of results (unsorted)
figure
% Degree centrality 
subplot(2, 3, 1); bar([in_degree_scores; out_degree_scores]); str = {'Node'; 'Node'}; set(gca, 'XTickLabel', str, 'XTick',1 : numel(str), 'FontSize', 14); xlabel('In-degree          Out-degree');ylabel('Degree Centrality', 'FontSize', 14);
    title('Temporal In and Out-Degree Centrality', 'fontsize', 14);
% Closeness centrality
subplot(2, 3, 2); bar(closeness_scores); xlabel('Node', 'FontSize', 14); ylabel('Closeness Centrality', 'FontSize', 14); 
     title('Temporal Closeness Centrality', 'fontsize', 14);
% Temporal betweenness centrality
subplot(2, 3, 3); bar(temporal_betweenness_scores); xlabel('Node', 'FontSize', 14); ylabel('Betweenness Centrality', 'FontSize', 14);
    title('Temporal Betweenness Centrality', 'fontsize', 14);
% Delay betweenness centrality
subplot(2, 3, 4); bar(delay_betweenness_scores); xlabel('Node', 'FontSize', 14); ylabel('Delay Centrality', 'FontSize', 14);
    title('Temporal Delay Centrality', 'fontsize', 14);
% Static centrality 
subplot(2, 3, 5); bar(static_scores); xlabel('Node', 'FontSize', 14); ylabel('Static Centrality', 'FontSize', 14);
    title('Static Betweenness Centrality', 'fontsize', 14);
% Comparison
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