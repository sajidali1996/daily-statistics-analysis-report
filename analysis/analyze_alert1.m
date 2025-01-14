function alert1_table = analyze_alert1(T, time)
    % Initialize previous alert code to an invalid value (e.g., 0)
    previous_alert_code = 0;

    % Initialize the output table
    alert1_table = table([], [], [], [], 'VariableNames', {'Time', 'AlertCode', 'AlertName', 'AlertDescription'});

    % Check if there are any alerts
    if any(T.Alerts_1 > 0)
        % Find the indices where alerts occur
        Alert_1 = find(T.Alerts_1 > 0);

        % Loop through the alerts and analyze them
        for i = 1:length(Alert_1)
            current_alert_code = T.Alerts_1(Alert_1(i));

            % Only process the alert if it's different from the previous one
            if current_alert_code ~= previous_alert_code
                % Decode the alert code
                alerts = decode_alerts_1(current_alert_code);

                % Append each decoded alert to the table
                for j = 1:length(alerts)
                    % Handle time format
                    if iscell(time)
                        current_time = time{Alert_1(i)};
                    else
                        current_time = time(Alert_1(i));
                    end
                    
                    % Create a new row
                    new_row = {current_time, alerts(j).AlertCode, alerts(j).AlertName, alerts(j).AlertDescription};
                    
                    % Append the row to the table
                    alert1_table = [alert1_table; new_row];
                end
            end

            % Update the previous alert code
            previous_alert_code = current_alert_code;
        end
    else
        fprintf("There were no alerts in Alert1.\n");
    end
end
