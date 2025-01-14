function status_table = decode_controlStatus(T)
    input_array=T.Control_status;
    % Define bit descriptions
    bit_info = {
        0, 'Grid_status', '1: Grid Good. 0: Grid Bad.';
        1, 'Grid_relay_status', '1: Grid relay closed. 0: Open.';
        2, 'Load_relay_status', '1: Load relay closed. 0: Load relay open.';
        3, 'Hardware_trip_status', '1: Trip active. 0: No trip.';
        4, 'Controls_status', '1: Running. 0: Stopped (Gate Blocked).';
        5, 'Export_status', '1: Enabled. 0: Disabled.';
        6, 'Safety_trip_status', '1: Trip active. 0: No trip.';
        7, 'Trip_reset_status', '1: Applied. 0: In-active.';
        8, 'Battery_status', '00: Idle. 01: Charging. 10: Discharging. 11: BAD (relay open or BMS comm failure).';
        9, '', ''; % Reserved bit
        10, 'PV_availability', '1: Available. 0: Not available.';
        11, 'Battery_availability', '1: Available. 0: Not available.';
        12, 'Comm_trip_status', '1: Trip active. 0: No trip.';
        13, 'Aux_Relay_Status', '1: Aux relay closed. 0: Aux relay open.';
        14, 'Bleeder_Status', '1: Bleeder active. 0: Bleeder not active.';
        15, 'Simulation_Mode_Status', '1: Simulation mode active. 0: Simulation mode inactive.'
    };

    % Initialize output table
    num_rows = length(input_array);
    variable_names = [{'Index'}, bit_info(~cellfun(@isempty, bit_info(:, 2)), 2)']; % Collect non-empty names
    status_table = table('Size', [num_rows, length(variable_names)], ...
                         'VariableTypes', ['double', repmat({'double'}, 1, length(variable_names) - 1)], ...
                         'VariableNames', variable_names);
    
    % Decode each input integer
    for i = 1:num_rows
        % Extract integer
        current_value = input_array(i);

        % Convert integer to binary array
        binary_status = bitget(current_value, 1:16); % Extract 16 bits
        
        % Add states to the table
        row = [i, binary_status(~cellfun(@isempty, bit_info(:, 2)))];
        status_table(i, :) = array2table(row);
    end
end
