% heat_data_uncertainty - Simulating heat flow through aluminium rod with uncertainty
 
function [TempData,dt,ExpTotalTime] = heat_data_uncertainity(datafile)

x = [0.0 6.0 12.0 18.0 24.0 30.0]; % Location of sensors

% Read data files
datafile = '/Users/Keenan/Documents/Processing/HeatTransport/HeatTransport_2017_6_9.csv';
raw_data = csvread(datafile, 1, 0); % Use csvread function to read our .csv data files
volt = csvread(datafile, 1, 7, [1 7 (size(raw_data,1)-1) 12]); % Specify the columns that 
temp = csvread(datafile, 1, 13, [1 13 (size(raw_data,1)-1) 18]); % contain volt/temp data
time = linspace(0, size(volt,1), size(volt,1)); % Based on size of the other data
FullTimeIdx = size(volt,1);

close all;
figure('Name', 'ENPH257 - Aluminium Rod Data Graph'); % Graph specifications
title('Graph of Temperature At Varying Points on an Aluminium Rod');
ylim([290.0 340.0]);
xlabel('Distance x (cm)');
ylabel('Temperature T (K)');
h = animatedline('Color', 'r'); % Use animatedline function to show change in time
hold on;

sz = size(temp);
conv_C_K = 273.15*ones(sz); % Conversion from degrees C to degrees K
temp = temp + conv_C_K; % Convert all temp reading to K

temp_avgs = [];
num_readings = 10; % Readings to take before averaging out readings

temp_last = 1000.0; % Used to find where heating starts
start_heat = false;

for i=1:(size(temp,1)-num_readings)
    if (mod(i,num_readings) == 0)
        curr_avgs = [0.0 0.0 0.0 0.0 0.0 0.0];
        
        for j=1:6
            curr_sum = sum(temp(i:(i+num_readings-1),j));
            curr_avgs(j) = curr_sum./num_readings; % Add readings to avg them
        end
        
        temp_avgs = [temp_avgs; curr_avgs];
        
        if ((curr_avgs(1) - temp_last) > 1 && start_heat == false) 
            t_heat_start = size(temp_avgs,1)
            start_heat = true; % Flagged for heat start
        end
        
        temp_last = curr_avgs(1);
    end
end

for i=1:size(temp_avgs,1) % Draw animated line graph
    clearpoints(h);
    addpoints(h,x,temp_avgs(i,:));
    drawnow limitrate;
    pause(0.000001);
end

figure('Name', 'ENPH257 - Temperature for Each Sensor Over Time');
title('Graph of Temperature for Each Sensor Over Time');
xlabel('Time t (s)'); % Draw grap of each sensor over time
ylabel('Temperature T (K)');
ylim([290.0 340.0]);
hold on;

avg_time = 1:1:size(temp_avgs,1);

for n=1:6
    temp_std_n(n) = std(temp_avgs(:,n), 1, 1); % Calculate standard dev
    temp_err = temp_std_n(n)*ones(size(avg_time)); % for each sensor
    errorbar(10*avg_time, temp_avgs(:,n), temp_err, 'horizontal');
    %plot(10*avg_time, temp_avgs(:,n));
    hold on;
end
% Create strings to print to legend
legend_1 = strcat('Sensor 1 - SD: ',num2str(temp_std_n(1))); 
legend_2 = strcat('Sensor 2 - SD: ',num2str(temp_std_n(2)));
legend_3 = strcat('Sensor 3 - SD: ',num2str(temp_std_n(3)));
legend_4 = strcat('Sensor 4 - SD: ',num2str(temp_std_n(4)));
legend_5 = strcat('Sensor 5 - SD: ',num2str(temp_std_n(5)));
legend_6 = strcat('Sensor 6 - SD: ',num2str(temp_std_n(6)));

legend(legend_1, legend_2, legend_3, legend_4, legend_5, legend_6);

%Hightlight outputs
TempData = temp;
dt = 1; 
ExpTotalTime = dt*numel(time);
end 

%Try to go through the temperature array. While loop through it, just one
%index with the next index. If the difference is high, then initialize
%current index as the first entry. 