function status_table = decode_controlStatus_opt(T)
%this function is same as decode_controlStatus but this one is optimized
%for faster run time
    input_array = T.Control_status;

    % Define bit descriptions
    bit_info = {
        0, 'Grid_status';
        1, 'Grid_relay_status';
        2, 'Load_relay_status';
        3, 'Hardware_trip_status';
        4, 'Controls_status';
        5, 'Export_status';
        6, 'Safety_trip_status';
        7, 'Trip_reset_status';
        8, 'Battery_status1';
        9, 'Battery_status2';
        10, 'PV_availability';
        11, 'Battery_availability';
        12, 'Comm_trip_status';
        13, 'Aux_Relay_Status';
        14, 'Bleeder_Status';
        15, 'Simulation_Mode_Status'
    };

    % Precompute constants
    num_bits = 16;
    num_rows = numel(input_array);
    bit_columns = ~cellfun(@isempty, bit_info(:, 2));
    variable_names = [{'Index'}, bit_info(bit_columns, 2)'];

    % Preallocate table
    status_table = array2table(zeros(num_rows, numel(variable_names)), ...
        'VariableNames', variable_names);
    status_table.Index = (1:num_rows)'; % Add index column

    % Vectorized binary extraction for all bits
    binary_matrix = zeros(num_rows, num_bits);
    for bit = 1:num_bits
        binary_matrix(:, bit) = bitget(input_array, bit); % Extract each bit
    end

    % Populate the table with binary data
    status_table{:, 2:end} = binary_matrix(:, bit_columns);

    % Combine Battery_status1 and Battery_status2 fields
    batt = bin2dec(strcat(string(binary_matrix(:, 9)), string(binary_matrix(:, 10))));
    status_table.Battery_status1 = batt; % Replace Battery_status1 with the combined value
    status_table.Battery_status2 = []; % Remove Battery_status2
end
