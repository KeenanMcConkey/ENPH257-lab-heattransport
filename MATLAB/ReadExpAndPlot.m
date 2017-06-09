function [TempData,dt,ExpTotalTime] = ReadExpAndPlot(datafile)


x = [0.0 6.0 12.0 18.0 24.0 30.0]; % Location of sensors

% Read data files
%datafile = 'C:\Users\Daniel Kor\Desktop\HeatTransport_2017_6_2.csv';
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

temp_last = 400.0;
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
            t_heat_start = size(temp_avgs,1);
            start_heat = true;
        end
        
        temp_last = curr_avgs(1);
    end
end

for i=1:size(temp_avgs,1)
    clearpoints(h);
    addpoints(h,x,temp_avgs(i,:));
    drawnow limitrate;
    pause(0.0001);
end

figure('Name', 'ENPH257 - Temperature for Each Sensor Over Time');
title('Graph of Temperature for Each Sensor Over Time');

xlabel('Time t (s)');
ylabel('Temperature T (K)');
ylim([290.0 340.0]);
hold on;

avg_time = 1:1:size(temp_avgs,1);

for n=1:6
    plot(avg_time, temp_avgs(:,n));
    hold on;
end


%Hightlight outputs
TempData = temp;
dt = 1; 
ExpTotalTime = dt*numel(time);
end 

%Try to go through the temperature array. While loop through it, just one
%index with the next index. If the difference is high, then initialize
%current index as the first entry. 