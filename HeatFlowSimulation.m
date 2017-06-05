function HeatFlowSimulation 

  
%Experiemetal data. The data helps determine the dt and time we want to use
%in our simulation
 
%File to read.
datafile = 'C:\Users\Daniel Kor\Desktop\HeatTransport_2017_6_2.csv';
[TempExpData,ExpDt,ExpTotalTime]= ReadExpAndPlot(datafile);


%Go to Simulation  

%Initiailize Constants:
length = 0.3; %[m]
numSlice = 50;
dt = 0.1;
dx = length/numSlice; %[m]

%Initialize time to match experimental data.
Time = ExpTotalTime; 
coolingInterval = 65;

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

voltage = 15; %check 
resistance = 15; %check 
powerIn = voltage^2 / resistance;
powerEff = 1; %account for other things, like whether the power is actually going through the rod.

%First slice parameters:
epsFirst = 1.0; %Emissivity. High because of the power resistor's black case.
kcFirst = 20.0; %Convection constant [W/m^2/K].
kFirst = 200; %Conductvity.

%Mid slices parameters:
epsMid = 0.5; %Emissivity. High because of the power resistor's black case.
kcMid = 20.0; %Convection constant [W/m^2/K].
kMid = 200; %Conductvity.

%Last slice parameters:
epsLast = 0.5; %Emissivity. High because of the power resistor's black case.
kcLast = 20.0; %Convection constant [W/m^2/K].
kLast = 200; %Conductvity.

%Concise Calculations

C3 = c*rho*dx^2;
C = c*rho*pi*radius^2 * dx;


%Ambient Temperature 
Tamb = TempExpData(1:1);


%Create the temperature, time and sensor length array:
t = linspace(0,Time,numTime); 
%ExpT = linspace(0,
Temp = ones(numTime,numSlice); %The entries are the temperatures at a given position and time. 
x = linspace(0,length,numSlice); 
sensorLength = [0.0,6.0,12.0,18.0,24.0,30.0];

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
 
  figure()
  Label = ones(1,6);
  for ii = 1:6
    actualLength = sensorLength(ii);
    Label(ii) = ii;
    for jj  = 1:numSlice
        if actualLength == x(jj)
            ii=jj;
        end 
    end
     plot(t,Temp(:,ii)); 
     ylabel('Temperature (K)');
     xlabel ('Time(s)');  
     ylim([290.0 350.0]);
     title('Temperature measurements at Sensors over Time')
     hold on;
     
     plot(t,TempExpData(:,ii),'.');
    
     hold on;
    
  end 
  

end 











