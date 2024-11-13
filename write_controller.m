% ----------------------------------------------------------------------%
% Author: Zachary Yoder, 2023
% Last updated: Zachary Yoder, 30 May 2024
% 
% Description: This function writes N output vectors to N handles
%
% INPUTS: port_array = [port1, port2, port3,..., portN]
% OUTPUTS: handle_array = [handle1, handle2, handle3,..., handleN]
% DEPENDENCIES: tx(handle,CMD,VAL)
% ----------------------------------------------------------------------%

function write_controller(handle_array, output_vector, sample_rate)

    % Check number of outputs match
    if length(handle_array) ~= length(output_vector(1, :))
        disp('Handle_arr and output_vector dimension mismatch');
        return
    end

    % Execute timed operation on boards
    period = 1/sample_rate;
    t = 0;
    tic
    % Increment through each value in output_vector
    for i = 1:length(output_vector(:, 1))
        % Increment through each board
        for j = 1:length(handle_array)
            tx(handle_array(j), 'O', output_vector(i, j))
        end

        % Pause to control timing
        t = t + period; % time next loop execution should start
        pause(max([t - toc, 0])); % wait for next step, or continue if we've overrun
    end

    %{
    % Display execution time
    disp(['Prescribed time: ', num2str(length(output_vector)/sample_rate)]);
    disp(['Execution time: ', num2str(toc)]);
    %}
    
    % Disable board output
    for i = 1:length(handle_array)
        tx(handle_array(i), 'X')
    end

end