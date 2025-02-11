function reset_events_table = analyze_dsp_uptime(T)
    % Validate inputs
    if ~ismember('Dsp_ut', T.Properties.VariableNames) || ~ismember('EventTime', T.Properties.VariableNames)
        error('Table T must contain "Dsp_ut" and "EventTime" columns.');
    end

    % Extract the uptime column and time column
    uptime = T.Dsp_ut;
    time = T.EventTime;

    % Identify reset indices
    reset_indices = find(diff(uptime) < 0);

    % Initialize the output table
    reset_events_table = table('Size', [0, 3], ...
                               'VariableTypes', {'datetime', 'double', 'string'}, ...
                               'VariableNames', {'Time', 'DSPCounterBeforeReset', 'Description'});

    % Populate the output table with unexpected reset event details
    for i = 1:length(reset_indices)
        idx = reset_indices(i); % Index of the reset event
        next_value = uptime(idx + 1);

        % Check if the reset is unexpected
        if ~(uptime(idx) == 6553 && next_value == 0 || uptime(idx) == 6552 && next_value == 0)
            % Add unexpected reset details to the output table
            new_row = {time(idx + 1), uptime(idx), "Unexpected DSP reset occurred."};
            reset_events_table = [reset_events_table; new_row]; %#ok<AGROW>
        end
    end
end
