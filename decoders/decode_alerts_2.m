function [active_alerts] = decode_alerts_2(alert_code)
    % Decodes an alert code integer into individual alert parameters and returns only the active alerts.
    %
    % Input:
    % - alert_code: Integer representing the bit field alert code.
    %
    % Output:
    % - active_alerts: Struct array containing the alert name, description, and status for active alerts (Status = 1).
    
    % Define the alert names and descriptions as per the table
    alert_names = {'Passive_Method_Grid_Disconnect', 'RPR_Disconnect', 'PV1_UV_Alert', 'PV2_UV_Alert', ...
                   'PV3_UV_Alert', 'Bat_UV_Alert', 'Reserved_1', 'Reserved_2', ...
                   'Reserved_3', 'Reserved_4', 'Reserved_5', 'Reserved_6', ...
                   'Reserved_7', 'Reserved_8', 'Reserved_9', 'Reserved_10'};
               
    alert_descriptions = {'Disconnected from the grid due to passive islanding', ...
                          'Disconnected from the grid due to Reverse Power Restriction.', ...
                          'Gate Block PV1 converter due to UV', 'Gate Block PV2 converter due to UV', ...
                          'Gate Block PV3 converter due to UV', 'Gate Block Battery converter due to UV', ...
                          'Reserved for future expansion.', 'Reserved for future expansion.', ...
                          'Reserved for future expansion.', 'Reserved for future expansion.', ...
                          'Reserved for future expansion.', 'Reserved for future expansion.', ...
                          'Reserved for future expansion.', 'Reserved for future expansion.', ...
                          'Reserved for future expansion.', 'Reserved for future expansion.'};
    
    % Initialize the output structure
    active_alerts = struct([]);
    
    % Loop through each alert and check if the corresponding bit is set in the alert_code
    for i = 0:15
        bit_status = bitget(alert_code, i+1);  % Extract the bit (1 or 0)
        
        % Only add the active alerts (bit_status == 1)
        if bit_status == 1
            active_alerts(end+1).AlertCode = sprintf('WAR 08%d.SEInverter', 816 + i);  % Alert code as per the table
            active_alerts(end).AlertName = alert_names{i+1};
            active_alerts(end).AlertDescription = alert_descriptions{i+1};
            active_alerts(end).Status = bit_status;  % 1 if alert is active
        end
    end
end
