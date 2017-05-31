% ENPH_257_Data - Graph the data collected from aluminium rod

x = [0.0 6.0 12.0 18.0 24.0 30.0]; % Location of sensors

% Read data files
datafile = '/Users/Keenan/Documents/Processing/HeatTransport/HeatTransport_2017_5_31.csv';
raw_data = csvread(datafile, 1, 0); % Use csvread function to read our .csv data files
volt = csvread(datafile, 1, 7, [1 7 (size(raw_data,1)-1) 12]); % Specify the columns that 
temp = csvread(datafile, 1, 13, [1 13 (size(raw_data,1)-1) 18]); % contain volt/temp data
time = linspace(0, size(volt,1), size(volt,1)); % Based on size of the other data

close all;
figure('Name', 'ENPH257 - Aluminium Rod Data Graph'); % Graph specifications
title('Graph of Temperature At Varying Points on an Aluminium Rod');
ylim([290.0 340.0]);
xlabel('Distance x (cm)');
ylabel('Temperature T (K)');
h = animatedline('Color', 'r'); % Use animatedline function to show change in time
hold on;

sz = size(temp);
conv_C_K = 273.15*ones(sz);
temp = temp + conv_C_K;

temp_avgs = [];
num_readings = 100;

for i=1:(size(temp,1)-num_readings)
    if(mod(i,num_readings) == 0)
        curr_avg = [0.0 0.0 0.0 0.0 0.0 0.0];
        
        for j=1:6
            curr_sum = sum(temp(i:(i+num_readings-1),j));
            curr_avg(j) = curr_sum./num_readings;
        end
        
        temp_avgs = [temp_avgs; curr_avg];
    end
end

for i=1:size(temp_avgs,1)
    clearpoints(h);
    addpoints(h,x,temp_avgs(i,:));
    drawnow limitrate;
    pause(0.1);
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