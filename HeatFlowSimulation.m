function HeatFlowSimulation 

%Initiailize Constants:
length = 0.3; %[m]
numSlice = 50;
Time = 100000; 

dt = 0.1; %[s]
dx = length/numSlice; %[m]

numTime = Time/dt;

sensors = 6; 

sigma = 5.67367E-8; %[W*m^-2*K^-4] Stefan-Boltzmann constant 

CtoK = 273;

%Rod Geometry

diameter = 2.00E-2; %[m]
radius = diameter/2;
cross_area = pi*radius^2;
surface_area= 2*pi*radius*dx;
rho = 2700; %density of aluminum.
%mass of aluminum.

%Initialize Test values (TBD).

voltage = 15; %check 
resistance = 20; %check 
powerIn = voltage^2 / resistance;
powerEff = 0.70; %account for other things, like whether the power is actually going through the rod.
eps = 1; %account for the fact of more glue.
sigma = 5.67367E-8; %Stefan-Boltzmann constant.
kc = 12.7; %Convection constant [W/m^2/K].
k = 200; %Conductivity [W/mK]
c = 900; %Specific heat capacity [J/(kgK)]


%Concise Calculations

C3 = c*rho*dx^2;
C = c*rho*pi*radius^2 * dx;
alpha = k/(c*rho); 


%Ambient Temperature 
Tamb = CtoK + 20;


%Create the temperature and length array:
Temp = ones(numTime,numSlice); %The entries are the temperatures at a given position and time. 
x = linspace(0,length,numSlice); 

%Initial Conditions:
% Theat = CtoK + 50; 
% Temp(1,1) = Theat;
Temp(1,1:numSlice) = Tamb;

%Loop in time 


for m =2:numTime
    
    %Start with the first slice. 
    
    Pin = powerIn*powerEff;
    
    Ploss = (surface_area + cross_area )*(  kc * (Temp(m-1,1) - Tamb ) + sigma * eps * ( Temp(m-1,1).^4 - Tamb.^4 ) );
    
    Pactual = Pin - Ploss;
    
    Temp(m ,1) = Temp(m-1,1) + dt * ( (Pactual/C) - k * ( Temp(m-1,1) - Temp(m-1,2) ) /C3 );
    
    %Mid Slices
    
    Temp(m,2:numSlice-1) = Temp(m-1,2:numSlice-1) + dt* k * ( Temp(m-1,1:numSlice-2) - 2 * Temp(m-1,2:numSlice-1) + Temp(m-1, 3:numSlice) )/C3;
    
    Ploss =  (surface_area) * (  kc * (Temp(m-1,2:numSlice-1) - Tamb ) + sigma * eps * ( Temp(m-1,2:numSlice-1).^4 - Tamb.^4 ) );
    
    Temp(m,2:numSlice-1) = Temp(m,2:numSlice-1) - dt * ( Ploss / C ); 
    
    %End slice.
    
    Temp(m,numSlice) = Temp (m-1,numSlice) +  (dt * k * ( Temp(m-1,numSlice-1) - Temp(m-1,numSlice) ) )/C3 ;
    
    Ploss = (surface_area + cross_area )*( kc * (Temp(m-1,numSlice) - Tamb ) + sigma * eps * ( Temp(m-1,numSlice).^4 - Tamb.^4 ) );
    
    Temp(m,numSlice) = Temp (m,numSlice) -  dt * ( Ploss / C ); 
   
%      plot(x,Temp(m,:));
%  
%      drawnow;
%     
    
end 
  plot(x,Temp(numTime,:));
  ylabel('Temperature (K)');
  xlabel ('Length (m)');
  
  plot(x, 
end 











