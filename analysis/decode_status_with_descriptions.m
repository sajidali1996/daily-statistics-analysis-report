function status_description_table = decode_status_with_descriptions(bin_array, bitNo, time)

    % Validate inputs
    if length(bin_array) ~= length(time)
        error('The bin_array and time arguments must have the same length.');
    end
    
    % Define bit descriptions for all relevant bits
    bit_info = {
        0, 'Grid_status', {'Grid Good', 'Grid Bad'};
        1, 'Grid_relay_status', {'Grid relay closed', 'Grid relay open'};
        2, 'Load_relay_status', {'Load relay closed', 'Load relay open'};
        3, 'Hardware_trip_status', {'Trip active', 'No trip'};
        4, 'Controls_status', {'Running', 'Stopped (Gate Blocked)'};
        5, 'Export_status', {'Enabled', 'Disabled'};
        6, 'Safety_trip_status', {'Trip active', 'No trip'};
        7, 'Trip_reset_status', {'Applied', 'In-active'};
        8, 'Battery_status', {'Idle', 'Charging', 'Discharging', 'BAD (relay open or BMS comm failure)'};
        9, 'PV_availability', {'Available', 'Not available'};
        10, 'Battery_availability', {'Available', 'Not available'};
        11, 'Comm_trip_status', {'Trip active', 'No trip'};
        12, 'Aux_Relay_Status', {'Aux relay closed', 'Aux relay open'};
        13, 'Bleeder_Status', {'Bleeder active', 'Bleeder not active'};
        14, 'Simulation_Mode_Status', {'Simulation mode active', 'Simulation mode inactive'};
    };
    
    % Initialize the output table
    num_rows = length(bin_array);
    status_description_table = table('Size', [num_rows, 4], ...
                                     'VariableTypes', {'cell', 'cell', 'cell', 'cell'}, ...
                                     'VariableNames', {'Time', 'Status', 'State', 'Description'});

    % Track last printed status and description
    last_printed_status = '';
    last_printed_description = '';
    
    % Loop through each value in the bin_array
    row_idx = 1; % To keep track of the row in the table
    for i = 1:num_rows
        % Extract the current binary value
        current_value = bin_array(i);
        
        % Extract the value of the specified bit (bitNo)
%         bit_status = ~bitget(current_value, bitNo + 1);  % bitget is 1-based
        bit_status=current_value;
        
        % Retrieve the status and description for the specified bitNo
        bit_description = bit_info{bitNo + 1, 2};  % +1 because bit_info is 1-based
        descriptions = bit_info{bitNo + 1, 3};     % Possible descriptions based on the status value
        
        % Adjust the description based on the bit's value
        if bit_status == 0
            status = descriptions{2};  % Description for 0
        else
            status = descriptions{1};  % Description for 1
        end
        
        % Check if the status and description are different from the last printed
        if ~strcmp(status, last_printed_status) || ~strcmp(status, last_printed_description)
            % Get the current timestamp
            current_time = time(i);
            
            % Create the row for the table
            new_row = {current_time, bit_description, bit_status, status};
            
            % Add the row to the table
            status_description_table{row_idx, :} = new_row;
            row_idx = row_idx + 1;
            
            % Update the last printed status and description
            last_printed_status = status;
            last_printed_description = status;
        end
    end
    
    % Trim the table to remove any empty rows
    status_description_table(row_idx:end, :) = [];
end
