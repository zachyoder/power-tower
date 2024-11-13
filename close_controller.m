% ----------------------------------------------------------------------%
% Author: Jonathan Fiene, 2023
% Last updated: Zachary Yoder, 30 May 2024
% 
% Description: This function generalizes close_controller to close an arbitrary
% number of controllers
%
% INPUTS: handle_array = [handle1, handle2, handle3,..., handleN]
% ----------------------------------------------------------------------%

function close_controller(handle_array)

    % Close serial communication for each element in handle_array
    for i = 1:length(handle_array)
        delete(handle_array(i));
    end
end