% ----------------------------------------------------------------------%
%{
Author: Zachary Yoder, 30 May 2024
Last updated: Zachary Yoder, 13 November 2024
 
Description:    Test script for evaluating PowerTower basic waveform tracking

DEPENDENCIES:   build_ramped_square(sample_rate, time_array, max_voltage)
                tx(handle, CMD, val)
                read_controller(handle_array, num_data_points)
%}
% ----------------------------------------------------------------------%

clear
% Set up key parameters
sample_rate = 980; % [Hz]
max_voltage = 5000; % [V]

% Open handles
serial_port_channels = ["COM4"];
handle_array = open_controller(serialportlist, 0);

flush(handle_array(1))
% Generate test waveforms
waveform_number = 1;
    % [1] sine
    % [2] ramped square
num_cycles = 10;

if waveform_number == 1
    % Generate sine wave
    frequency = 5; % [Hz]
    output_vector = max_voltage*(1/2)*(1 + sin(linspace(-pi/2, (3/2)*pi, sample_rate/frequency))).';
elseif waveform_number == 2
    % Generate ramped square wave
    time_array = [0.5, 0.1, 1, 0.1, 0.5]; % [s]
    output_vector = build_ramped_square(sample_rate, time_array, max_voltage);
end

% Executed timed operation
tic; % start timer
tx(handle_array, 'V', 8); % start data streaming from device

% Output signal
for i = 1:num_cycles
    output_vector = -output_vector;
    write_controller(handle_array, output_vector, sample_rate);
end

% Read data from device
data_array = read_controller(handle_array, length(output_vector)*num_cycles);

% Plot data
figure(1)
hold on
t = data_array(:, 1)/sample_rate;
plot(t, data_array(:, 2), '.-') % V_l
plot(t, data_array(:, 3), '.-') % V_r
plot(linspace(0, length(output_vector(:, 1))/sample_rate, length(output_vector)), abs(output_vector), 'k');
xlabel('Time [s]')
ylabel('Voltage [V]')
legend('V_l', 'V_r', 'Prescribed')
