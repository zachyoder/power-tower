% ----------------------------------------------------------------------%
%{
Author: Jonathan Fiene, 2023
Last updated: Zachary Yoder, 30 May 2024
 
Description: This function generalizes opens an arbitrary number of controllers
from the specific ports

INPUTS:     port_array = [port1, port2, port3,..., portN]
            calibration_flag = boolean
OUTPUTS:    handle_array = [handle1, handle2, handle3,..., handleN]
%}
% ----------------------------------------------------------------------%

function handle_array = open_controller(port_array, calibration_flag)
    % Note: could add input here for ADC filter, gain, deadband

    % Open serial communication from specified ports
    for i = 1:length(port_array)
        % Open serial port
        handle_array(i) = serialport(port_array(i), 9600);

        if calibration_flag
            tx(handle_array(i), 'C'); % calibrate each device
        end

        % Set default values (note - use Python for better default specification)
        tx(handle_array(i), 'G', 30); % set proportional gain
        tx(handle_array(i), 'F', 900); % set ADC filter
        tx(handle_array(i), 'A', 747); % set ADC scale
        tx(handle_array(i), 'D', 20); % set deadband
    end
end