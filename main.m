clc
clear
close all
%% Variables

% General parameters
opt.g = 9.81; % [m/s^2]

% Simulation parameters
fastsim.Mach = 0.5; % [-] Mach number
fastsim.velocity = fastsim.Mach*343; % [m/s]
fastsim.c = 0.5; % [m]
fastsim.mu = 1.81*10^(-5); % [Pa s]
fastsim.rho = 1.223; % [kg/m^3]
fastsim.alpha = -5:0.5:10; % [-] AoA
fastsim.max_linear_alpha_index = 24; % index of alpha range
fastsim.Re = fastsim.rho*fastsim.c*fastsim.velocity/fastsim.mu; % [-] Reynolds Number

slowsim.velocity = 100; % [m/s]
slowsim.Mach = slowsim.velocity/343; % [-] Mach number
slowsim.c = 0.5; % [m]
slowsim.mu = 1.81*10^(-5); % [Pa s]
slowsim.rho = 1.223; % [kg/m^3]
slowsim.alpha = -5:1:12; % [-] AoA
slowsim.max_linear_alpha_index = 12; % index of alpha range
slowsim.Re = fastsim.rho*fastsim.c*fastsim.velocity/fastsim.mu; % [-] Reynolds Number

% Plane parameters
plane.m = 10700; % [kg]
plane.weight = plane.m * opt.g; % [N]
plane.c1 = 2.2; % [m] Base chord length
plane.c2 = 0.8; % [m] Tip chord length
plane.b = 20; % [m] Wing span (both wings)
plane.S = (plane.c1 + plane.c2)/2 * plane.b; % [m^2]
plane.e = 0.9; % [-] % Needs more research
plane.AR = plane.b^2 / plane.S; % [-]

%% XFoil
[naca2412.data, naca2412.foil] = xfoil('NACA2412',fastsim.alpha,fastsim.Re,fastsim.Mach,'oper iter 60','ppar N 181','oper xtr 0.1 0.1');
naca2412 = calculate_finite_wing(naca2412, fastsim, plane);
% [naca2412flaps.data, naca2412flaps.foil] = xfoil('NACA2412',fastsim.alpha,fastsim.Re,fastsim.Mach,'gdes flap 0.7 0 10','oper iter 60','ppar N 181','oper xtr 0.1 0.1');
% naca2612 = myxfoil('NACA2606', ops.sim);

%% Plot foils

% figure
% tiledlayout(2, 1)
% nexttile
% plotfoil(naca2412)
% nexttile
% plotfoil(naca2412flaps)

%% Lift
C_L = naca2412.a * (0 - naca2412.alpha_0);
L = 1/2 * fastsim.rho * fastsim.velocity^2 * C_L * plane.S; % [N]
disp(['Lift / Weight: ', num2str(L/plane.weight)]);

%% Drag
index = indexwherealphais(naca2412, 0);
c_d = naca2412.data.CD(index);
D = 1/2 * fastsim.rho * fastsim.velocity^2 * c_d * plane.S; % [N]

D_i = L*C_L/pi/plane.AR;

disp(['D + D_i = ', num2str(D), ' + ', num2str(D_i), ' = ', num2str(D+D_i), ' N']);

%% Pressure v x plot

% figure
% hold on
% title(['c_p over x at \alpha = ', num2str(airfoil(1).foil.alpha(index))])
% xlabel('x/c')
% ylabel('c_p')
% set(gca, 'YDir','reverse') % flip the y-axis
% plotairfoilpressure(naca2412, 7);
% plotairfoilpressure(naca2412flaps, 7);

%% Plot Lift v alpha
figure
hold on
title("Lift v Alpha")
xlabel("AoA [deg]")
ylabel("C_L [-]")
% plot(naca2412flaps.data.alpha, naca2412flaps.data.CL, 'xg')
plot_lift_v_alpha(naca2412, fastsim)
grid on
legend({'NACA 2412','NACA 2606'})

%% Plot Pitching moment v alpha
% figure
% hold on
% plot(naca2412.data.alpha,naca2412.data.Cm, 'xr')
% plot(airfoil(2).data.alpha,airfoil(2).data.Cm, 'xb')
% plot(airfoil(3).data.alpha,airfoil(3).data.Cm, 'xb')
% title("Pitching moment")
% xlabel("AoA [deg]")
% ylabel("C_m [-]")
% grid on
% legend({'NACA 4412','NACA 4421'})

%% Plot Lift v Drag

% figure
% hold on
% plot(naca2412.data.alpha,(naca2412.data.CL./naca2412.data.CD),'xr')
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
% plotfoil(naca2412)
% nexttile
% plotfoil(airfoil(2))
