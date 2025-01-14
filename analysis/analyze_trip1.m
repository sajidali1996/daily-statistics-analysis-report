function trip1_table = analyze_trip1(T, time)
    % Initialize previous trip code to an invalid value (e.g., 0)
    previous_trip_code = 0;

    % Initialize the output table
    trip1_table = table([], [], [], [], 'VariableNames', {'Time', 'TripCode', 'TripName', 'TripDescription'});

    % Check if there are any trips
    if any(T.Trips_1 > 0)
        % Find the indices where trips occur
        Trip_1 = find(T.Trips_1 > 0);

        % Loop through the trips and analyze them
        for i = 1:length(Trip_1)
            current_trip_code = T.Trips_1(Trip_1(i));

            % Only process the trip if it's different from the previous one
            if current_trip_code ~= previous_trip_code
                % Decode the trip code
                trips = decode_trip1(current_trip_code);

                % Append each decoded trip to the table
                for j = 1:length(trips)
                    % Handle time format
                    if iscell(time)
                        current_time = time{Trip_1(i)};
                    else
                        current_time = time(Trip_1(i));
                    end
                    
                    % Create a new row
                    new_row = {current_time, trips(j).FaultCode, trips(j).FaultName, trips(j).FaultDescription};
                    
                    % Append the row to the table
                    trip1_table = [trip1_table; new_row];
                end
            end

            % Update the previous trip code
            previous_trip_code = current_trip_code;
        end
    else
        fprintf("There were no trips in Trip1.\n");
    end
end
