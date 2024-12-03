clc
clear
close all
%% Variables

% Simulation options
ops.sim.velocity = 50; % [m/s]
ops.sim.c = 0.5; % [m]
ops.sim.mu = 1.81*10^(-5); % [Pa s]
ops.sim.rho = 1.223; % [kg/m^3]
ops.sim.alpha = -5:1:15; % [-] AoA
ops.sim.max_linear_alpha_index = 12; % index of alpha range
% ops.sim.alpha = 0.5; % [-] AoA
ops.sim.Mach = ops.sim.velocity/343; % [-] Mach number
ops.sim.Re = ops.sim.rho*ops.sim.c*ops.sim.velocity/ops.sim.mu; % [-] Reynolds Number

ops.g = 9.81; % [m/s^2]
ops.plane.m = 10600; % [kg]
ops.plane.weight = ops.plane.m * ops.g; % [N]
ops.plane.S = 30; % [m^2] % Needs more research
ops.plane.e = 0.95; % [-] % Needs more research
ops.plane.AR = 9; % [-] % Needs more research

%% XFoil
airfoil(1) = myxfoil('NACA4412', ops.sim);

%% Critical Mach number
% plot(airfoil(1).foil.xcp)

%% Lift
for i = 1:length(airfoil(1).data.CL)
    c_l = airfoil(1).data.CL(i);
    if c_l > 0
        assert(i > 1);
        c_l_prev = airfoil(1).data.CL(i-1);
        amount_between = -c_l_prev / (c_l - c_l_prev);
        alpha_0 = deg2rad(airfoil(1).data.alpha(i-1) * (1 - amount_between) + airfoil(1).data.alpha(i) * amount_between);
        break;
    end
end
clear amount_between c_l c_l_prev
dalpha = deg2rad(airfoil(1).data.alpha(ops.sim.max_linear_alpha_index) - airfoil(1).data.alpha(1));
dc_l = airfoil(1).data.CL(ops.sim.max_linear_alpha_index) - airfoil(1).data.CL(1);
a_0 = dc_l / dalpha;
clear dalpha dc_l
a = a_0 / (1 + a_0 / (pi * ops.plane.e * ops.plane.AR));
velocity = 100;
alpha = deg2rad(4);
C_L = a_0 * (alpha - alpha_0);
L = 1/2 * ops.sim.rho * velocity^2 * C_L * ops.plane.S; % [N]
disp(['Lift / Weight: ', num2str(L/ops.plane.weight)]);

%% Pressure v x plot

index = 7;
figure
hold on
half = ceil(length(airfoil(1).foil.xcp)/2);
plot(airfoil(1).foil.xcp(1:half), airfoil(1).foil.cp(1:half,index));
plot(airfoil(1).foil.xcp(half+1:end), airfoil(1).foil.cp(half+1:end,index));
title(['c_p over x at \alpha = ', num2str(airfoil(1).foil.alpha(index))])
xlabel('x/c')
ylabel('c_p')

% airfoil(2) = myxfoil('NACA4421', simopts);

%% Plot Lift v alpha
figure
hold on
plot(airfoil(1).data.alpha([1, ops.sim.max_linear_alpha_index]), airfoil(1).data.CL([1, ops.sim.max_linear_alpha_index]), 'b')
plot(airfoil(1).data.alpha, airfoil(1).data.CL, 'xr')
% plot(airfoil(2).data.alpha,airfoil(2).data.CL, 'xb')
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
% plotfoil(airfoil(1))
% nexttile
% plotfoil(airfoil(2))
