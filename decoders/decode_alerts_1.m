function [active_alerts] = decode_alerts_1(alert_code)
    % Decodes an alert code integer into individual alert parameters and returns only the active alerts.
    %
    % Input:
    % - alert_code: Integer representing the bit field alert code.
    %
    % Output:
    % - active_alerts: Struct array containing the alert name, description, and status for active alerts (Status = 1).
    
    % Define the alert names and descriptions as per the table
    alert_names = {'Grid_OV_Disconnection', 'Grid_UV_Disconnection', 'Grid_OF_Disconnection', 'Grid_UF_Disconnection', ...
                   'CT_Disconnected', 'CT_Reversed', 'Active_Method_Grid_Disconnect', 'Precharge_fail', ...
                   'Bus_undervoltage', 'Bus_sustain_fail', 'Output_caps_charged', 'Excessive_bus_normal_to_low_transitions', ...
                   'Sync_timeout alert.', 'reserved1', 'reserved2', 'reserved3'};
               
    alert_descriptions = {'Grid Overvoltage warning', 'Grid Undervoltage warning', 'Grid Overfrequency warning', ...
                          'Grid Under frequency warning', 'CT disconnection detected', 'CT reversal detected', ...
                          'Disconnected from the grid due to active islanding.', 'DC bus precharge failed.', ...
                          'DC bus undervoltage alert.', 'DC bus sustain failed.', 'Inverter output cap voltage is above 20V when control is enabled', ...
                          'Indicates that there are more than 10 low bus events in the last 30 minutes.', ...
                          'Grid Sync. took more than 1 minute.', 'Reserved for future expansion.', 'Reserved for future expansion.', 'Reserved for future expansion.'};
    
    % Initialize the output structure
    active_alerts = struct([]);
    
    % Loop through each alert and check if the corresponding bit is set in the alert_code
    for i = 0:15
        bit_status = bitget(alert_code, i+1);  % Extract the bit (1 or 0)
        
        % Only add the active alerts (bit_status == 1)
        if bit_status == 1
            active_alerts(end+1).AlertCode = sprintf('WAR 08%d.SEInverter', 800 + i);  % Alert code as per the table
            active_alerts(end).AlertName = alert_names{i+1};
            active_alerts(end).AlertDescription = alert_descriptions{i+1};
            active_alerts(end).Status = bit_status;  % 1 if alert is active
        end
    end
end
