% ----------------------------------------------------------------------%
%{
Author: Zachary Yoder, 11 November 2024
Last updated: Zachary Yoder, 11 November 2024

Description: This function reads N output vectors from N handles

INPUTS:         handle_array = [handle1, handle2, handle3,..., handleN]
                num_data_points = number of samples to be read
OUTPUTS:        data_array = [t, V_l, V_r] num_data_points x 3 array of read data
DEPENDENCIES:   tx(handle, CMD, VAL)
%}
% ----------------------------------------------------------------------%

function data_array = read_controller(handle_array, num_data_points)

for i = 1:length(handle_array)
    h = handle_array(i);

    % Read in raw data for this handle
    raw_data = zeros(num_data_points,6); % num_data_points x 6
    for j = 1:num_data_points
        raw_data(j,:) = read(h,6,'uint8');
    end

    tx(h,'P'); % pause data streaming

    % Initialize data vectors
    t = zeros(num_data_points,1);
    l = t;
    r = t;
    
    % Normalize values
    t_init = raw_data(1,2); % initial time value, dictated by device clock
    t_base = 0;
    for k = 2:num_data_points
        if(raw_data(k,2)==0)
            t_base = t_base + 255;
        end
        t(k, 1) = raw_data(k,2) - t_init + t_base;
        l(k, 1) = raw_data(k,3) + raw_data(k,4)*255;
        r(k, 1) = raw_data(k,5) + raw_data(k,6)*255;
    end
    
    data_array = [t,l,r];
    %plot(t,l,'.-',t,r,'.-')
end

