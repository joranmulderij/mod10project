clc
clear
close all
%% Variables

% General parameters
opt.g = 9.81; % [m/s^2]

% Plane parameters
plane.m = 10700; % [kg]
plane.weight = plane.m * opt.g; % [N]
plane.taper_ratio = 0.88;
plane.c1 = 2.2; % [m] Base chord length
plane.c2 = plane.c1 * plane.taper_ratio; % [m] Tip chord length
plane.c_average = (plane.c1 + plane.c2) / 2;
plane.b = 20; % [m] Wing span (both wings)
plane.S = (plane.c1 + plane.c2)/2 * plane.b; % [m^2]
plane.e = 0.98; % [-]
plane.AR = plane.b^2 / plane.S; % [-]
plane.landing_gear_height = 1.5; % [m]

% Simulation parameters
[fastsim.rho, fastsim.temperature, fastsim.pressure] = atmosModel(10000);
fastsim.Mach = 0.6; % [-] Mach number
fastsim.velocity = fastsim.Mach*343; % [m/s]
fastsim.c = 0.5; % [m]
fastsim.mu = 1.81*10^(-5); % [Pa s]
fastsim.alpha = -3:0.5:8; % [-] AoA
fastsim.max_linear_alpha_index = 20; % index of alpha range
fastsim.Re = fastsim.rho*plane.c_average*fastsim.velocity/fastsim.mu; % [-] Reynolds Number

[slowsim.rho, slowsim.temperature, slowsim.pressure] = atmosModel(0);
slowsim.velocity = 55; % [m/s]
slowsim.Mach = slowsim.velocity/343; % [-] Mach number
slowsim.mu = 1.81*10^(-5); % [Pa s]
slowsim.alpha = -10:1:20; % [-] AoA
slowsim.max_linear_alpha_index = 12; % index of alpha range
slowsim.Re = fastsim.rho*plane.c_average*fastsim.velocity/fastsim.mu; % [-] Reynolds Number

%% XFoil
airfoil.name = 'NACA 2412';
[airfoil.data, airfoil.foil] = xfoil(airfoil.name,fastsim.alpha,fastsim.Re,fastsim.Mach,'oper iter 60','ppar N 181','oper xtr 0.1 0.1');
airfoil = calculate_finite_wing(airfoil, fastsim, plane);

airfoil_flaps.name = 'NACA 2412 flaps';
[airfoil_flaps.data, airfoil_flaps.foil] = xfoil('NACA 2412',slowsim.alpha,slowsim.Re,slowsim.Mach,'gdes flap 0.7 0 10','oper iter 60','ppar N 181','oper xtr 0.1 0.1');
airfoil_flaps = calculate_finite_wing(airfoil_flaps, slowsim, plane);

airfoil_23012.name = 'NACA 23012';
[airfoil_23012.data, airfoil_23012.foil] = xfoil(airfoil_23012.name,fastsim.alpha,fastsim.Re,fastsim.Mach,'oper iter 60','ppar N 181','oper xtr 0.1 0.1');
airfoil_23012 = calculate_finite_wing(airfoil_23012, fastsim, plane);

airfoil_23015.name = 'NACA 23015';
[airfoil_23015.data, airfoil_23015.foil] = xfoil(airfoil_23015.name,fastsim.alpha,fastsim.Re,fastsim.Mach,'oper iter 60','ppar N 181','oper xtr 0.1 0.1');
airfoil_23015 = calculate_finite_wing(airfoil_23015, fastsim, plane);

%% Lift cruise
L = plane.weight;
required_cruise_C_L = L / ((1/2) * fastsim.rho * fastsim.velocity^2 * plane.S);
required_cruise_alpha = required_cruise_C_L / airfoil.a + airfoil.alpha_0;
disp(['Required /alpha cruise: ', num2str(required_cruise_alpha), ' [deg]']);

%% Drag cruise
i = find(airfoil.data.alpha>required_cruise_alpha, 1);
cruise_c_d = airfoil.data.CD(i);
cruise_D = 1/2 * fastsim.rho * fastsim.velocity^2 * cruise_c_d * plane.S; % [N]

cruise_D_i = L*required_cruise_C_L/pi/plane.AR;

disp(['D + D_i = ', num2str(cruise_D), ' + ', num2str(cruise_D_i), ' = ', num2str(cruise_D+cruise_D_i), ' N']);

%% Lift takeoff
required_takeoff_C_L = L / ((1/2) * slowsim.rho * slowsim.velocity^2 * plane.S);
required_takeoff_alpha = required_takeoff_C_L / airfoil_flaps.a + airfoil_flaps.alpha_0;
disp(['Cruise: Required /alpha takeoff: ', num2str(required_takeoff_alpha), ' [deg]']);

%% Drag takeoff
i = find(airfoil_flaps.data.alpha>required_takeoff_alpha, 1);
takeoff_c_d = airfoil_flaps.data.CD(i);
takeoff_D = 1/2 * slowsim.rho * slowsim.velocity^2 * takeoff_c_d * plane.S; % [N]

takeoff_D_i = L*required_takeoff_C_L/pi/plane.AR;

disp(['Takeoff: D + D_i = ', num2str(takeoff_D), ' + ', num2str(takeoff_D_i), ' = ', num2str(takeoff_D+takeoff_D_i), ' N']);

i = find(airfoil_flaps.data.alpha>0, 1);
takeoff_alpha_0_c_d = airfoil_flaps.data.CD(i);
takeoff_alpha_0_D = 1/2 * slowsim.rho * slowsim.velocity^2 * takeoff_alpha_0_c_d * plane.S; % [N]

takeoff_alpha_0_D_i = L*required_takeoff_C_L/pi/plane.AR/plane.e;

disp(['Takeoff alpha=0: D + D_i = ', num2str(takeoff_alpha_0_D), ' + ', num2str(takeoff_alpha_0_D_i), ' = ', num2str(takeoff_alpha_0_D+takeoff_alpha_0_D_i), ' N']);

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
plot_lift_v_alpha(airfoil, fastsim)
grid on
legend({airfoil.name})

figure
hold on
title("Lift v Alpha")
xlabel("AoA [deg]")
ylabel("C_L [-]")
% plot(naca2412flaps.data.alpha, naca2412flaps.data.CL, 'xg')
plot_lift_v_alpha(airfoil_flaps, slowsim)
grid on
legend({airfoil_flaps.name})

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

figure
hold on
plot(airfoil.data.alpha,(airfoil.data.CL./airfoil.data.CD),'xr')
plot(airfoil_23012.data.alpha,(airfoil_23012.data.CL./airfoil_23012.data.CD),'ob')
plot(airfoil_23015.data.alpha,(airfoil_23015.data.CL./airfoil_23015.data.CD),'-g')

title("Lift/Drag")
xlabel("AoA [deg]")
ylabel("C_L/C_D [-]")
grid on
legend('NACA 2412','NACA 23012','NACA 23015','Location','southeast') 


%% Plot foil
figure
tiledlayout(2,1)
nexttile
plotfoil(airfoil)
nexttile
plotfoil(airfoil_flaps)
