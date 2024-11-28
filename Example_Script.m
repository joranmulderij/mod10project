clc
clear
close all
%% Variables
velocity = 50; % [m/s]
mu = 1.81*10^(-5); % [Pa s]
rho = 1.223; % [kg/m^3]
c = 0.25; % [m]
% alpha = linspace(-5,24,25); % [-] AoA
alpha = -5:0.5:24; % [-] AoA
Mach = velocity/343; % [-] Mach number
Re = rho*c*velocity/mu; % [-] Reynolds Number

%% XFoil
airfoil(1).coords = 'NACA4412';
airfoil(2).coords = 'NACA4421';
% airfoil(3).coords = 'NACA4440';

[airfoil(1).data,airfoil(1).foil] = xfoil(airfoil(1).coords,alpha,Re,Mach,'oper iter 60','ppar N 181','oper xtr 1.0');
[airfoil(2).data,airfoil(2).foil] = xfoil(airfoil(2).coords,alpha,Re,Mach,'oper iter 60','ppar N 181','oper xtr 1.0');
% [airfoil(3).data,airfoil(3).foil] = xfoil(airfoil(3).coords,alpha,Re,Mach,'oper iter 60','ppar N 181','oper xtr 1.0');

%% Plot Lift v alpha
figure
hold on
plot(airfoil(1).data.alpha,airfoil(1).data.CL, 'xr')
plot(airfoil(2).data.alpha,airfoil(2).data.CL, 'xb')
% plot(airfoil(3).data.alpha,airfoil(3).data.CL, 'xb')
title("Lift Polars at Re = 8.4*10^5")
xlabel("AoA [deg]")
ylabel("C_L [-]")
grid on
legend({'NACA 4412','NACA 4421'})

%% Plot Pitching moment v alpha
% figure
% hold on
% plot(airfoil(1).data.alpha,airfoil(1).data.Cm, 'xr')
% plot(airfoil(2).data.alpha,airfoil(2).data.Cm, 'xb')
% plot(airfoil(3).data.alpha,airfoil(3).data.Cm, 'xb')
% title("Pitching moment")
% xlabel("AoA [deg]")
% ylabel("C_m [-]")
% grid on
% legend({'NACA 4412','NACA 4421'})

%% Plot Lift v Drag

% figure(2)
% hold on
% plot(airfoil(1).data.alpha,(airfoil(1).data.CL./airfoil(1).data.CD),'xr')
% 
% title("Lift/Drag Ratio at Re = 8.4*10^5")
% xlabel("AoA [deg]")
% ylabel("C_L/C_D [-]")
% grid on
% legend({'NACA 0012','NACA 63(2)-415'})

%% Plot foil
% figure
% tiledlayout(2,1)
% nexttile
% plotfoil(airfoil(1).foil)
% nexttile
% plotfoil(airfoil(2).foil)
