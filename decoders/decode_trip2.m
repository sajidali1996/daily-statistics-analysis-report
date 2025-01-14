function [active_faults] = decode_trip2(fault_code)
    % Decodes a new fault code integer into individual fault parameters and returns only the active faults.
    %
    % Input:
    % - fault_code: Integer representing the bit field fault code.
    %
    % Output:
    % - active_faults: Struct array containing the fault name, description, and status for active faults (Status = 1).
    
    % Define the fault names and descriptions as per the table
    fault_names = {'DC_Component_Trip', 'Phase1_overload_Trip', 'Phase2_overload_Trip', 'Batt_Over_Temp_Trip', ...
                   'Inv_Over_Temp_Trip', 'PV_Over_Temp_Trip', 'Aux_Over_Temp_Trip', 'Inverter Overload HW Trip', ...
                   'Battery Overload HW Trip', 'Ipv1_OC_Trip', 'Ipv2_OC_Trip', 'Ipv3_OC_Trip', ...
                   'reserved4', 'reserved5', 'reserved6', 'Custom Logs trip'};
               
    fault_descriptions = {'DC component of the grid current is greater than 1% of rated current.', ...
                          'Overload occurred on inverter phase 1.', 'Overload occurred on inverter phase 2.', ...
                          'Trip in case of over temperature in battery power module.', ...
                          'Trip in case of over temperature in inverter power module.', ...
                          'Trip in case of over temperature in PV power module.', ...
                          'Trip in case of over temperature in Aux. converter.', ...
                          'Hardware over current trip on inverter.', 'Hardware overcurrent trip on battery.', ...
                          'Over current on PV1.', 'Over current on PV2.', 'Over current on PV3.', ...
                          'Reserved fault.', 'Reserved fault.', 'Reserved fault.', ...
                          'User initiated customized logs.'};
    
    % Initialize the output structure
    active_faults = struct([]);
    
    % Loop through each fault and check if the corresponding bit is set in the fault_code
    for i = 0:15
        bit_status = bitget(fault_code, i+1);  % Extract the bit (1 or 0)
        
        % Only add the active faults (bit_status == 1)
        if bit_status == 1
            active_faults(end+1).FaultCode = sprintf('FLT 08%d.SEInverter', 848 + i);  % Fault code as per the table
            active_faults(end).FaultName = fault_names{i+1};
            active_faults(end).FaultDescription = fault_descriptions{i+1};
            active_faults(end).Status = bit_status;  % 1 if fault is active
        end
    end
end
