import time
import struct
import serial

def open_controller(port_array, calibrate):
    """
    Author: J. Fiene, 2023
    Last updated: Z. Yoder, 6 November 2024

    Description: This function opens an arbitrary number of serial ports.

    Parameters:
    port_array: (lis) Port names (e.g., ['COM1', 'COM2', ..., 'COMN'])
    calibrate: (bool) Should the boards be calibrated (voltage must be off)

    Returns:
    handle_array: List of serial port handles
    """
    handle_array = []

    # Open serial communication from specified ports
    for port in port_array:
        handle = serial.Serial(port, baudrate=9600)  # open serial port
        handle_array.append(handle)

        # Send calibration command
        if calibrate:
            tx(handle, 'C')   # calibrate with zero voltage
        
        # Send configuration commands
        tx(handle, 'F', 900)  # set ADC filter
        tx(handle, 'A', 747)  # set ADC scale
        tx(handle, 'D', 50)   # set deadband

    return handle_array

def close_controller(handle_array):
    """
    Author: J. Fiene, 2023
    Last updated: Z. Yoder, 6 November 2024

    Description: This function closes an arbitrary number of serial ports.

    Parameters:
    handle_array: List of serial port handles
    """
    for handle in handle_array:
        handle.close()  # Close the serial connection

def write_controller(handle_array, output_vector, sample_rate):
    """
    Author: Zachary Yoder, 2023
    Last updated: Zachary Yoder, 6 November 2024

    Description: This function writes N output vectors to N handles

    Parameters:
    handle_array: List of handles [handle1, handle2, handle3, ..., handleN]
    output_vector: 2D list or array with output values for each handle
    sample_rate: Frequency in Hz at which to write the values

    Dependencies:
    tx(handle, cmd, val) - a function to transmit data
    """
    # Check if the number of outputs matches
    if len(handle_array) != len(output_vector[0]):
        print('handle_array and output_vector dimension mismatch')
        return

    # Execute timed operation on boards
    period = 1 / sample_rate
    t = 0
    start_time = time.time()

    # Increment through each value in output_vector
    for i in range(len(output_vector)):
        # Increment through each handle
        for j in range(len(handle_array)):
            tx(handle_array[j], 'O', output_vector[i][j])

        # Control timing to match the period
        t += period
        while time.time() - start_time < t:
            pass

    # Disable board output
    for handle in handle_array:
        tx(handle, 'X')

def tx(handle, cmd, val=None):
    '''
    Author: J. Fiene, 2023
    Last updated: Z. Yoder, 6 November 2024

    Description: This function writes commands to power tower boards

    Parameters:
    handle: Serial port ID from open_controller
    cmd: Single-letter ASCII character
    val: Optional 16-bit integer value to pass
    '''
    if val is not None:
        # Convert `cmd` to int8, `val` to int16, and write to handle
        data = struct.pack('b', cmd) + struct.pack('h', val)
        handle.write(data)
    else:
        # Convert `cmd` to int8 and write to handle
        data = struct.pack('b', cmd)
        handle.write(data)