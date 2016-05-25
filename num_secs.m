%% WORK IN PROGRESS %%

function rtn = num_secs(interaction_time, granularity)
% Take 2 datevecs and take their difference in seconds
% allowing user to specify their own tick granularity
%   Parameters
%   __________
%   interaction_time -- Raw temporal data of each interaction
%   granularity -- Number of total splits of the data
%
%   Outputs
%   _______
%   Tick_list -- 

secs_elapsed = etime(datevec(interaction_time(end)), datevec(interaction_time(1)));
tick_split = secs_elapsed / granularity;

tick = 1;
Tick_list = zeros(numel(interaction_time), 1);
[i, j] = deal(1);
while i < numel(interaction_time)
    if etime(datevec(interaction_time(i+1)), datevec(interaction_time(j))) > tick_split
        j = i;
        i = i + 1;
        tick = tick + 1;
        Tick_list(i) = tick;
    else
        Tick_list(i) = tick;
        i = i + 1;
    end
    %% What does tick list = ? 
    % Tick_list =
end

rtn = Tick_list;
end