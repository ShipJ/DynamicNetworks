%% Dissertation: April 2016
% Author: Jack Shipway - jack.shipway.12@ucl.ac.uk

function rtn = temporal_graph(G, num_ticks)
% Returns a temporal graph from a given temporal data set. A temporal 
% graph is a time-ordered digraph - a serialised set of static graphs.
% 
%     Parameters
%     ----------
%     G : Temporal data set
%     num_ticks : Number of time-steps over which the data set is defined
% 
%     Outputs
%     ----------
%     A temporal digraph data structure as a cell storing edges occurring 
%     during each tick, in a separate section of a cell. 

% Get number of edges 
[num_edges, ~] = size(G);
% Initialise empty data structure
temporal_graph = cell(1, num_ticks);
% Index tick and interaction count
tick = 1; count = 1;
% For each time-ordered edge, store in corresponding static graph 
for i = 1 : num_edges
    % Add interactions until no more in that time-period
    if isequal(G(i, 3), tick)
        temporal_graph{tick}(count, :) = G(i, :);
    % Switch to new time period
    else
        
        temporal_graph{tick} = unique(temporal_graph{tick}, 'rows');
        % Reset edge count for a particular tick
        count = 1; 
        % Increase tick count by 1
        tick = tick + 1;
        temporal_graph{tick}(count, :) = G(i, :);
    end
    % Increase edge count by 1 each time a distinct edge is seen
    count = count + 1;
end

% Ensure that the interactions per time step are unique
temporal_graph{tick} = unique(temporal_graph{tick}, 'rows');
% Return a temporal digraph object
rtn = temporal_graph;
end