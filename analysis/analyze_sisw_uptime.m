function reset_events_table = analyze_sisw_uptime(T)
    % Validate inputs
    if ~ismember('Sisw_ut', T.Properties.VariableNames) || ~ismember('EventTime', T.Properties.VariableNames)
        error('Table T must contain "Sisw_ut" and "EventTime" columns.');
    end

    % Extract the uptime column and time column
    uptime = T.Sisw_ut;
    time = T.EventTime;

    % Find indices where the uptime counter resets
    reset_indices = find(diff(uptime) < 0);

    % Initialize the output table
    num_resets = length(reset_indices);
    reset_events_table = table('Size', [num_resets, 3], ...
                               'VariableTypes', {'datetime', 'double', 'string'}, ...
                               'VariableNames', {'Time', 'Sisw_ut_beforeReset', 'Description'});

    % Populate the output table with reset event details
    for i = 1:num_resets
        idx = reset_indices(i); % Index of the reset event
        reset_events_table.Time(i) = time(idx + 1); % Time of the reset event
        reset_events_table.Sisw_ut_beforeReset(i) = uptime(idx); % Uptime counter value after reset
        reset_events_table.Description(i) = "SISW_App was reset here.";
    end
end
