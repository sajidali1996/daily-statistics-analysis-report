function [total_uptime, total_downtime] = meas_duration(data)
    % Initialize variables
    uptime = []; % Durations for value 1
    downtime = []; % Durations for value 0
    
    current_value = data(1); % Start with the first value
    count = 1; % Counter for consecutive values
    
    for i = 2:length(data)
        if data(i) == current_value
            count = count + 1; % Increment counter if the value is the same
        else
            % Store the duration for the current value
            if current_value == 1
                uptime = [uptime, count];
            else
                downtime = [downtime, count];
            end
            % Reset for the next value block
            current_value = data(i);
            count = 1;
        end
    end
    
    % Capture the final block
    if current_value == 1
        uptime = [uptime, count];
    else
        downtime = [downtime, count];
    end
    
    % Calculate total uptime and downtime
    total_uptime = sum(uptime);
    total_downtime = sum(downtime);
    
%     % Display results
%     disp('Durations for value 1 (seconds):');
%     disp(uptime);
%     
%     disp('Durations for value 0 (seconds):');
%     disp(downtime);
    
%     % Display totals
%     disp(['Total Uptime (seconds): ', num2str(total_uptime)]);
%     disp(['Total Downtime (seconds): ', num2str(total_downtime)]);
end
