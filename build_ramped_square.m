% ----------------------------------------------------------------------%
%{
Author: Zachary Yoder, 30 May 2024
Last updated: Zachary Yoder, 30 May 2024
 
Description: This function generates a ramped square voltage wave

INPUTS:         sample_rate     [Hz] rate of output signal
                time_array      [s] [zero time, ramp up time, on time, ramp down time, zero time]
                max_voltage     [V] max voltage of the square wave in volts (not kV)
OUTPUTS:        ramped_square   Nx1 ramped square wave signal at sample_rate frequency
%}
% ----------------------------------------------------------------------%

function ramped_square = build_ramped_square(sample_rate, time_array, max_voltage)

    % Compute indices of inflection points
    inflection_points = zeros(1, length(time_array));
    for i = 1:length(time_array)
        inflection_points(i) = cast(sum(time_array(1:i))*sample_rate, 'uint32');
    end

    % Initialize empty vector
    ramped_square = zeros(cast(sample_rate*sum(time_array), 'uint32'),1);

    % Zero time (already zero)
    % Ramp up
    ramped_square(inflection_points(1)+1:inflection_points(2)) = linspace(0, max_voltage, time_array(2)*sample_rate);
    % On time
    ramped_square(inflection_points(2)+1:inflection_points(3)) = max_voltage;
    % Ramp down
    ramped_square(inflection_points(3)+1:inflection_points(4)) = linspace(max_voltage, 0, time_array(4)*sample_rate);
    % Zero time (already zero)

end