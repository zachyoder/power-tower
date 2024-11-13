import numpy as np
'''
Author: Z. Yoder, 2023
Last updated: Z. Yoder, 7 November 2024

Description: This module creates various waveforms.
'''

def build_ramped_square(sample_rate, time_array, max_voltage):
    '''
    Generates a ramped square voltage wave.

    Parameters:
    sample_rate (float): Sample rate of the output signal in Hz.
    time_array (list): List of time intervals in seconds [zero time, ramp up time, on time, ramp down time, zero time].
    max_voltage (float): Maximum voltage of the square wave in volts.

    Returns:
    numpy.ndarray: Ramped square wave signal at sample_rate frequency.
    '''
    # Compute indices of inflection points
    inflection_points = np.zeros(len(time_array), dtype=np.uint32)
    for i in range(len(time_array)):
        inflection_points[i] = np.uint32(sum(time_array[:i+1])*sample_rate)

    # Initialize empty array
    total_samples = int(sample_rate*sum(time_array))
    ramped_square = np.zeros(total_samples)

    # Zero time (already zero)

    # Ramp up
    ramped_square[inflection_points[0]:inflection_points[1]] = np.linspace(
        0, max_voltage, int(time_array[1] * sample_rate)
    )

    # On time
    ramped_square[inflection_points[1]:inflection_points[2]] = max_voltage

    # Ramp down
    ramped_square[inflection_points[2]:inflection_points[3]] = np.linspace(
        max_voltage, 0, int(time_array[3] * sample_rate)
    )

    # Zero time (already zero)

    return ramped_square

def build_sine(sample_rate, frequency, max_voltage):
    '''
    Generates a sine voltage wave.

    Parameters:
    sample_rate (float): Sample rate of the output signal in Hz.
    frequency (float): Frequency of sine wave.
    max_voltage (float): Maximum voltage of the square wave in volts.

    Returns:
    numpy.ndarray: Ramped sine wave signal at sample_rate frequency.
    '''
    output_vector = max_voltage*(1/2)*(1 + np.sin(np.linspace(
        -np.pi/2, (3/2)*np.pi, int(sample_rate/frequency)
    )))

    return output_vector