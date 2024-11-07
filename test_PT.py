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

def main(sample_rate=980, max_voltage=6000, serial_port_channels=None, waveform_number=1, num_cycles=2):

    # Open control channels
    #serial_port_channels = ["COM10", "COM9", "COM8", "COM7", "COM4"]
    handle_array = power_tower.open_controller(serial_port_channels)

    # Generate waveforms
    num_cycles = 2
    if waveform_number == 1:
        frequency = 2  # [Hz]
        #output_vector = max_voltage*(1/2)*(1 + np.sin(np.linspace(-np.pi/2, (3/2)*np.pi, sample_rate//frequency)))
        output_vector = waveform_generator.build_sine()
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