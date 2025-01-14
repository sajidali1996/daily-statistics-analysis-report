function [active_faults] = decode_trip1(fault_code)
    % Decodes a fault code integer into individual fault parameters and returns only the active faults.
    %
    % Input:
    % - fault_code: Integer representing the bit field fault code.
    %
    % Output:
    % - active_faults: Struct array containing the fault name, description, and status for active faults (Status = 1).
    
    % Define the fault names and descriptions as per the table
    fault_names = {'Iinv1_OC_Trip', 'Iinv2_OC_Trip', 'Ibat1_OC_Trip', 'Ibat2_OC_Trip', ...
                   'Vinv1_OV_Trip', 'Vinv2_OV_Trip', 'Vbus_c1_OV_Trip', 'Vbus_c2_OV_Trip', ...
                   'Vbus_OV_Trip', 'Vbat_OV_Trip', 'Vpv1_OV_Trip', 'Vpv2_OV_Trip', 'Vpv3_OV_Trip', ...
                   'Iaux_OC_Trip', 'Ground_Fault_Trip', 'CM4_Comm_Timeout_Trip'};
               
    fault_descriptions = {'Over current on inverter phase 1.', 'Over current on inverter phase 2.', ...
                          'Over current on battery converter leg1.', 'Over current on battery converter leg2.', ...
                          'Over voltage on inverter phase 1.', 'Over voltage on inverter phase 2.', ...
                          'Over voltage on dc bus capacitor 1.', 'Over voltage on dc bus capacitor 2.', ...
                          'Over voltage on dc bus.', 'Over voltage on battery input.', ...
                          'Over voltage on PV1 input.', 'Over voltage on PV2 input.', ...
                          'Over voltage on PV3 input.', 'Over current on auxiliary converter.', ...
                          'Excessive ground fault current.', 'CM4 did not communicate for 4 minutes. Self recovering.'};
    
    % Initialize the output structure
    active_faults = struct([]);
    
    % Loop through each fault and check if the corresponding bit is set in the fault_code
    for i = 0:15
        bit_status = bitget(fault_code, i+1);  % Extract the bit (1 or 0)
        
        % Only add the active faults (bit_status == 1)
        if bit_status == 1
            active_faults(end+1).FaultCode = sprintf('FLT 083%d.SEInverter', 832 + i);  % Fault code as per the table
            active_faults(end).FaultName = fault_names{i+1};
            active_faults(end).FaultDescription = fault_descriptions{i+1};
            active_faults(end).Status = bit_status;  % 1 if fault is active
        end
    end
end
