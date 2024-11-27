clc
clear
close all
%% Variables
velocity = 50; % [m/s]
mu = 1.81*10^(-5); % [Pa s]
rho = 1.223; % [kg/m^3]
c = 0.25; % [m]
alpha = linspace(-5,20,26); % [-] AoA
Mach = velocity/343; % [-] Mach number
Re = rho*c*velocity/mu; % [-] Reynolds Number

%% XFoil
airfoil(1).coords = 'NACA5512';

[airfoil(1).data,airfoil(1).foil] = xfoil(airfoil(1).coords,alpha,Re,Mach,'oper iter 300','ppar N 300');

%% Plotting
figure(1)
hold on
plot(airfoil(1).data.alpha,airfoil(1).data.CL)
%plot(airfoil(2).data.alpha,airfoil(2).data.CL,'^b')

title("Lift Polars at Re = 8.4*10^5")
xlabel("AoA [deg]")
ylabel("C_L [-]")
grid on
legend({'NACA 0012','NACA 63(2)-415'})

figure(2)
hold on
plot(airfoil(1).data.alpha,(airfoil(1).data.CL./airfoil(1).data.CD),'xr')

title("Lift/Drag Ratio at Re = 8.4*10^5")
xlabel("AoA [deg]")
ylabel("C_L/C_D [-]")
grid on
legend({'NACA 0012','NACA 63(2)-415'})

%% Plot foil
figure
plotfoil(airfoil(1).foil)
