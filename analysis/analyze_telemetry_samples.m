function anomaly_table = analyze_telemetry_samples(T)
    % Validate inputs
    if ~ismember('EventTime', T.Properties.VariableNames)
        error('Table T must contain "EventTime" column.');
    end

    % Extract and preprocess time data
    event_times = T.EventTime;
    rounded_hours = dateshift(event_times, 'start', 'hour'); % Group by hour
    
    % Fast grouping by hour
    [unique_hours, ~, hour_indices] = unique(rounded_hours);
    hourly_counts = accumarray(hour_indices, 1);

    % Preallocate cell array for anomalies
    anomalies = cell(length(unique_hours), 1);
    anomaly_count = 0;

    % Thresholds for expected hourly samples
    min_samples = 3600;
    max_samples = 3660;

    % Process each hour
    for i = 1:length(unique_hours)
        hour_time = unique_hours(i);
        sample_count = hourly_counts(i);

        % Skip hours with sufficient samples
        if sample_count >= min_samples && sample_count <= max_samples
            continue;
        end

        % If anomaly detected, process minute-level counts
        current_hour_mask = (rounded_hours == hour_time);
        current_hour_times = event_times(current_hour_mask);
        rounded_minutes = dateshift(current_hour_times, 'start', 'minute');

        [unique_minutes, ~, minute_indices] = unique(rounded_minutes);
        minute_counts = accumarray(minute_indices, 1);

        % Identify anomalous minutes
        anomaly_mask = (minute_counts ~= 60 & minute_counts ~= 61);
        anomalous_minutes = unique_minutes(anomaly_mask);
        anomalous_counts = minute_counts(anomaly_mask);

        % Append anomalies
        for j = 1:length(anomalous_minutes)
            anomaly_count = anomaly_count + 1;
            anomalies{anomaly_count} = {anomalous_minutes(j), anomalous_counts(j), ...
                                        sprintf('Anomalous sample count: %d', anomalous_counts(j))};
        end
    end

    % Convert anomalies to a table
    if anomaly_count > 0
        anomalies = anomalies(1:anomaly_count); % Trim preallocated cells
        anomaly_table = cell2table(vertcat(anomalies{:}), ...
                                   'VariableNames', {'HourDetail', 'NumberOfSamples', 'Description'});
    else
        anomaly_table = table('Size', [0, 3], ...
                              'VariableTypes', {'datetime', 'double', 'string'}, ...
                              'VariableNames', {'HourDetail', 'NumberOfSamples', 'Description'});
    end
end
