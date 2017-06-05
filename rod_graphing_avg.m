% ENPH_257_Data - Graph the data collected from aluminium rod

x = [0.0 6.0 12.0 18.0 24.0 30.0]; % Location of sensors

% Read data files
datafile = '/Users/Keenan/Documents/Processing/HeatTransport/HeatTransport_2017_6_5.csv';
raw_data = csvread(datafile, 1, 0); % Use csvread function to read our .csv data files
volt = csvread(datafile, 1, 7, [1 7 (size(raw_data,1)-1) 12]);   % Specify the columns that 
temp = csvread(datafile, 1, 13, [1 13 (size(raw_data,1)-1) 18]); % contain volt/temp data
time = linspace(0, size(volt,1), size(volt,1)); % Based on size of the other data

close all;
figure('Name', 'ENPH257 - Aluminium Rod Data Graph'); % Graph specifications for animated
title('Graph of Temperature At Varying Points on an Aluminium Rod'); % graph
ylim([290.0 340.0]);
xlabel('Distance x (cm)');
ylabel('Temperature T (K)');
h = animatedline('Color', 'r'); % Use animatedline function to show change in time
hold on;

sz = size(temp);
conv_C_K = 273.15*ones(sz); % Conversion from degrees C to degrees K
temp = temp + conv_C_K; % Convert all temp reading to K

temp_avgs = []; % Initialize as blank
num_readings = 10; % Readings to take before averaging out readings

temp_last = 1000.0; % Use a flag to try to pinpoint the time where
t_heat_start = 0.0; % heating starts
heating_start = false;
tmp_start = 1;

for i=1:(size(temp,1)-num_readings)
    if (mod(i,num_readings) == 0) % Average every "num_readings" readings
        curr_avgs = [0.0 0.0 0.0 0.0 0.0 0.0];
        
        for j=1:6
            curr_sum = sum(temp(i:(i+num_readings-1),j)); % Sum a set number of reading
            curr_avgs(j) = curr_sum./num_readings; % Average them
        end
        
        temp_avgs = [temp_avgs; curr_avgs]; % Create a new array with new averages
        
        if ((curr_avgs(1) - temp_last) > tmp_start && heating_start == false) 
            t_heat_start = size(temp_avgs,1) % If starting time of heating hasn't been 
            heating_start = true;            % recorded, record it
        end
        temp_last = curr_avgs(1);
    end
end

for i=1:size(temp_avgs,1)
    clearpoints(h);                  % Draw an animated line showing
    addpoints(h,x,temp_avgs(i,:));   % temperature change along the rod
    drawnow limitrate;               % animated in time
    pause(0.00001);
end

figure('Name', 'ENPH257 - Temperature for Each Sensor Over Time');
title('Graph of Temperature for Each Sensor Over Time'); % Graph specifications for
xlabel('Time t (s)');                                    % temperature vs time graph
ylabel('Temperature T (K)');
ylim([290.0 340.0]);
hold on;

avg_time = 0:1:size(temp_avgs,1)-1;          % Time space for averaged readings
avg_time = avg_time .* num_readings; % i.e. time/5

for n=1:6
    plot(avg_time, temp_avgs(:,n));
    hold on;
end