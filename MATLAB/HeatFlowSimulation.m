function HeatFlowSimulation 

  
%Experiemetal data. The data helps determine the dt and time we want to use
%in our simulation
 
%File to read.
datafile = '/Users/Keenan/Documents/Processing/HeatTransport/HeatTransport_2017_6_9.csv';
[TempExpData,ExpDt,ExpTotalTime]= heat_data_uncertainty(datafile);


%Go to Simulation  

%Initiailize Constants:
length = 0.3; %[m]
numSlice = 50;
dt = 0.1;
dx = length/numSlice; %[m]

%Initialize time to match experimental data.
Time = 6000;
coolingInterval = 600; % manually change based on intervals to modulate power source.

numTime = Time/dt;
sensors = 6; 

sigma = 5.67367E-8; %[W*m^-2*K^-4] Stefan-Boltzmann constant 
c = 900; %Specific heat capacity [J/(kgK)]

CtoK = 273;

%Rod Geometry

diameter = 2.00E-2; %[m]
radius = diameter/2;
cross_area = pi*radius^2;
surface_area= 2*pi*radius*dx;
rho = 2700; %density of aluminum.
%mass of aluminum.

%Variable Parameters.

%Note:
%Split the parameter into 3 different regions: First slice, middle slices,
%and last slice.

%For each slice, we have different conductivity(k), convection current (kc)
%and emissivity (eps).

%voltage = 15; %check 
%resistance = 15; %check 
powerIn = 10;
powerEff = 0.6; %account for other things, like whether the power is actually going through the rod.

%First slice parameters:
epsFirst = 0.8; %Emissivity. High because of the power resistor's black case.
kcFirst = 20.0; %Convection constant [W/m^2/K].
kFirst = 150; %Conductvity.

%Mid slices parameters:
epsMid = 0.3; %Emissivity. 
kcMid = 10.0; %Convection constant [W/m^2/K].
kMid = 150; %Conductvity.

%Last slice parameters:
epsLast = 0.1; %Emissivity. High because of the power resistor's black case.
kcLast = 10.0; %Convection constant [W/m^2/K].
kLast = 150; %Conductvity.

%Concise Calculations

C3 = c*rho*dx^2;
C = c*rho*pi*radius^2 * dx;


%Ambient Temperature 
Tamb = TempExpData(1:1);


%Create the temperature, time and sensor length array:
t = linspace(0,Time,numTime); 
t_Exp = linspace(0,ExpTotalTime,ExpTotalTime);
%ExpT = linspace(0,
Temp = ones(numTime,numSlice); %The entries are the temperatures at a given position and time. 
x = linspace(0,length,numSlice); 
sensorLength = [0.0,6.0e-2,12.0e-2,18.0e-2,24.0e-2,30.0e-2];

%Initial Conditions:
% Theat = CtoK + 50; 
% Temp(1,1) = Theat;
Temp(1,1:numSlice) = Tamb;

%Loop in time 

HeatingFlag = 1;

for m =2:numTime
   
    if  mod(t(m),coolingInterval) < 0.1
        if HeatingFlag == 0
            HeatingFlag = 1;
        else
            HeatingFlag = 0;
        end
    end
    
    if HeatingFlag == 0
        Pin = 0;
        
        Ploss = (surface_area + cross_area )*(  kcFirst * (Temp(m-1,1) - Tamb ) + sigma * epsFirst * ( Temp(m-1,1).^4 - Tamb.^4 ) );

        Pactual = Pin - Ploss;

        Temp(m ,1) = Temp(m-1,1) + dt * ( (Pactual/C) - kFirst * ( Temp(m-1,1) - Temp(m-1,2) ) /C3 );

        %Mid Slices

        Temp(m,2:numSlice-1) = Temp(m-1,2:numSlice-1) + dt* kMid * ( Temp(m-1,1:numSlice-2) - 2 * Temp(m-1,2:numSlice-1) + Temp(m-1, 3:numSlice) )/C3;

        Ploss =  (surface_area) * (  kcMid * (Temp(m-1,2:numSlice-1) - Tamb ) + sigma * epsMid * ( Temp(m-1,2:numSlice-1).^4 - Tamb.^4 ) );

        Temp(m,2:numSlice-1) = Temp(m,2:numSlice-1) - dt * ( Ploss / C ); 

        %End slice.

        Temp(m,numSlice) = Temp (m-1,numSlice) +  (dt * kLast * ( Temp(m-1,numSlice-1) - Temp(m-1,numSlice) ) )/C3 ;

        Ploss = (surface_area + cross_area )*( kcLast * (Temp(m-1,numSlice) - Tamb ) + sigma * epsLast * ( Temp(m-1,numSlice).^4 - Tamb.^4 ) );

        Temp(m,numSlice) = Temp (m,numSlice) -  dt * ( Ploss / C ); 
    end 
    
    if HeatingFlag == 1
        Pin = powerIn*powerEff;
    
        Ploss = (surface_area + cross_area )*(  kcFirst * (Temp(m-1,1) - Tamb ) + sigma * epsFirst * ( Temp(m-1,1).^4 - Tamb.^4 ) );

        Pactual = Pin - Ploss;

        Temp(m ,1) = Temp(m-1,1) + dt * ( (Pactual/C) - kFirst * ( Temp(m-1,1) - Temp(m-1,2) ) /C3 );

        %Mid Slices

        Temp(m,2:numSlice-1) = Temp(m-1,2:numSlice-1) + dt* kMid * ( Temp(m-1,1:numSlice-2) - 2 * Temp(m-1,2:numSlice-1) + Temp(m-1, 3:numSlice) )/C3;

        Ploss =  (surface_area) * (  kcMid * (Temp(m-1,2:numSlice-1) - Tamb ) + sigma * epsMid * ( Temp(m-1,2:numSlice-1).^4 - Tamb.^4 ) );

        Temp(m,2:numSlice-1) = Temp(m,2:numSlice-1) - dt * ( Ploss / C ); 

        %End slice.

        Temp(m,numSlice) = Temp (m-1,numSlice) +  (dt * kLast * ( Temp(m-1,numSlice-1) - Temp(m-1,numSlice) ) )/C3 ;

        Ploss = (surface_area + cross_area )*( kcLast * (Temp(m-1,numSlice) - Tamb ) + sigma * epsLast * ( Temp(m-1,numSlice).^4 - Tamb.^4 ) );

        Temp(m,numSlice) = Temp (m,numSlice) -  dt * ( Ploss / C ); 
    
    end 

    
end 

%Select sensor length slice based on length initialization
sensorTemp = zeros(numTime,6);
sensorTemp(:,1) = Temp(:,1);
sensorTemp(:,2) = Temp(:,11);
sensorTemp(:,3) = Temp(:,21);
sensorTemp(:,4) = Temp(:,30);
sensorTemp(:,5) = Temp(:,40);
sensorTemp(:,6) = Temp(:,50);

  figure()
  for ii = 1:6
%Select sensor length slice based on length differences
%      for jj  = 1:numSlice
%          if abs( sensorLength(ii)-x(jj)) < 0.15 
%             plot(t,Temp(:,jj));
%             hold on
%             display(jj);
%          end 
%      end
     ylabel('Temperature (K)','FontSize',15);
     xlabel ('Time(s)','FontSize',15);  
     ylim([290.0 360.0]);
     title('Temperature measurements at Sensors over Time','FontSize',15)
     set(gca,'FontSize', 12);
     hold on;
     
     plot(t_Exp,TempExpData(:,ii),'.');
     
     plot(t,sensorTemp(:,ii));
    
     hold on;
    
  end 
  
     legend({'Sensor 1 Simulation','Sensor 1 Experiment',...
            'Sensor 2 Simulation','Sensor 2 Experiment',...
            'Sensor 3 Simulation','Sensor 3 Experiment',...
            'Sensor 4 Simulation','Sensor 4 Experiment',...
            'Sensor 5 Simulation','Sensor 5 Experiment',...
            'Sensor 6 Simulation','Sensor 6 Experiment'},'FontSize', 14);

        

end 











