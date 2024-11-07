import numpy as np
import matplotlib.pyplot as plt
import power_tower
import waveform_generator
'''
Author: Z. Yoder, 2023
Last updated: Z. Yoder, 7 November 2024

Description: This function opens an arbitrary number of serial ports.

Parameters:
port_array: List of port names (e.g., ['COM1', 'COM2', ..., 'COMN'])

Returns:
handle_array: List of serial port handles
'''

def main(serial_port_channels, max_voltage, sample_rate=980, waveform_number=1, num_cycles=2, calibrate=False):

    # Open control channels
    #serial_port_channels = ["COM10", "COM9", "COM8", "COM7", "COM4"]
    handle_array = power_tower.open_controller(serial_port_channels, calibrate)
    # Wait for user to turn high-voltage on
    if calibrate:
        wait = input("Turn voltage on, press enter to continue")

    # Generate waveforms
    num_cycles = 2
    if waveform_number == 1:
        frequency = 2  # [Hz]
        output_vector = waveform_generator.build_sine(sample_rate, frequency, max_voltage)
    elif waveform_number == 2:
        time_array = [0.5, 0.1, 1, 0.1, 0.5]  # [s]
        output_vector = waveform_generator.build_ramped_square(sample_rate, time_array, max_voltage)

    # Plot the output waveform
    plt.plot(output_vector)
    plt.show()

    # Output signal
    for _ in range(num_cycles):
        power_tower.write_controller(handle_array, output_vector, sample_rate)

if __name__ == "__main__":
    main()