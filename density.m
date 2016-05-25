%% Dissertation: April 2016
% Author: Jack Shipway - jack.shipway.12@ucl.ac.uk

function rtn = density(temporal_graph, num_ticks)
% Compute density of each snapshot in a temporal graph
%   Parameters
%   __________
%   temporal_graph -- snapshots of each static graph per time period
%   num_ticks -- number of time periods
%
%   Outputs
%   _______
%   density -- the density computed of the temporal graph at each tick

% Initialise as zero density
density = zeros(1, num_ticks);
for i = 1 : num_ticks
    % Compute the density using the number of nodes and edges in each tick
    try
        nodes = numel(unique(temporal_graph{i}(:, 1:2)));
        edges = numel(temporal_graph{i}(:, 1));
        % Density formula (in thesis)
        density(i) = edges / (nodes * (nodes - 1));
    catch
        density(i) = 0;
    end
end
% Return the density of the network at each tick
rtn = density;
end

