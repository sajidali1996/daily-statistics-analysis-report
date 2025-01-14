function alert2_table = analyze_alert2(T, time)
    % Initialize previous alert code to an invalid value (e.g., 0)
    previous_alert_code = 0;

    % Initialize the output table
    alert2_table = table([], [], [], [], 'VariableNames', {'Time', 'AlertCode', 'AlertName', 'AlertDescription'});

    % Check if there are any alerts
    if any(T.Alerts_2 > 0)
        % Find the indices where alerts occur
        Alert_2 = find(T.Alerts_2 > 0);

        % Loop through the alerts and analyze them
        for i = 1:length(Alert_2)
            current_alert_code = T.Alerts_2(Alert_2(i));

            % Only process the alert if it's different from the previous one
            if current_alert_code ~= previous_alert_code
                % Decode the alert code
                alerts = decode_alerts_2(current_alert_code);

                % Append each decoded alert to the table
                for j = 1:length(alerts)
                    % Handle time format
                    if iscell(time)
                        current_time = time{Alert_2(i)};
                    else
                        current_time = time(Alert_2(i));
                    end
                    
                    % Create a new row
                    new_row = {current_time, alerts(j).AlertCode, alerts(j).AlertName, alerts(j).AlertDescription};
                    
                    % Append the row to the table
                    alert2_table = [alert2_table; new_row];
                end
            end

            % Update the previous alert code
            previous_alert_code = current_alert_code;
        end
    else
        fprintf("There were no alerts in Alert2.\n");
    end
end
