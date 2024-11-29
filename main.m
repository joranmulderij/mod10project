clc
clear
close all
%% Variables
ops.velocity = 200; % [m/s]
ops.mu = 1.81*10^(-5); % [Pa s]
ops.rho = 1.223; % [kg/m^3]
ops.c = 0.5; % [m]
% simopts.alpha = -5:1:15; % [-] AoA
ops.alpha = 0.5; % [-] AoA
ops.Mach = ops.velocity/343; % [-] Mach number
ops.Re = ops.rho*ops.c*ops.velocity/ops.mu; % [-] Reynolds Number
ops.g = 9.81; % [m/s^2]
ops.plane.m = 10600; % [kg]
ops.plane.weight = ops.plane.m * ops.g; % [N]
ops.plane.wing_length = 19.2; % [m] (wingspan of G280)

%% XFoil
airfoil(1) = myxfoil('NACA4412', ops);
c_l = airfoil(1).data.CL(1); % [-]
l = 1/2 * ops.rho * ops.velocity^2 * ops.c * c_l; % [N/m]
L = l * ops.plane.wing_length;
disp(['Lift / Weight: ', num2str(L/ops.plane.weight)]);

% airfoil(2) = myxfoil('NACA4421', simopts);

%% Plot Lift v alpha
% figure
% hold on
% plot(airfoil(1).data.alpha,airfoil(1).data.CL, 'xr')
% plot(airfoil(2).data.alpha,airfoil(2).data.CL, 'xb')
% % plot(airfoil(3).data.alpha,airfoil(3).data.CL, 'xb')
% title("Lift Polars at Re = 8.4*10^5")
% xlabel("AoA [deg]")
% ylabel("C_L [-]")
% grid on
% legend({'NACA 4412','NACA 4421'})

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
% plotfoil(airfoil(1))
% nexttile
% plotfoil(airfoil(2))
