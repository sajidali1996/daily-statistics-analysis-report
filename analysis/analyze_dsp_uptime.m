function reset_events_table = analyze_dsp_uptime(T)
    % Validate inputs
    if ~ismember('Dsp_ut', T.Properties.VariableNames) || ~ismember('EventTime', T.Properties.VariableNames)
        error('Table T must contain "Dsu_ut" and "EventTime" columns.');
    end

    % Extract the uptime column and time column
    uptime = T.Dsp_ut;
    time = T.EventTime;

    % Identify reset indices
    reset_indices = find(diff(uptime) < 0);

    % Initialize the output table
    num_resets = length(reset_indices);
    reset_events_table = table('Size', [num_resets, 3], ...
                               'VariableTypes', {'datetime', 'double', 'string'}, ...
                               'VariableNames', {'Time', 'UptimeCounter', 'Description'});

    % Populate the output table with reset event details
    for i = 1:num_resets
        idx = reset_indices(i); % Index of the reset event
        next_value = uptime(idx + 1);

        % Determine if it's an expected overflow or an unexpected reset
        if uptime(idx) == 6553 && next_value == 0
            description = "Microcontroller uptime overflowed as expected.";
        else
            description = "Unexpected microcontroller reset occurred.";
        end

        % Add details to the output table
        reset_events_table.Time(i) = time(idx + 1); % Time of the reset event
        reset_events_table.UptimeCounter(i) = uptime(idx); % Uptime counter value after reset
        reset_events_table.Description(i) = description;
        fprintf("reset happend at %d\n",idx);
    end
end
