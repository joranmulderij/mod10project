function [] = plot_lift_v_alpha(airfoil, sim)

plot(airfoil.data.alpha, airfoil.data.CL, 'xr')

% plot(naca2412.data.alpha([1, ops.sim.max_linear_alpha_index]), naca2412.data.CL([1, ops.sim.max_linear_alpha_index]), 'b')
max_linear_alpha = airfoil.data.alpha(sim.max_linear_alpha_index);
max_linear_C_L = airfoil.a_0 * (max_linear_alpha - airfoil.alpha_0);
max_linear_C_L_corrected = airfoil.a * (max_linear_alpha - airfoil.alpha_0);
plot([airfoil.alpha_0, max_linear_alpha], [0, max_linear_C_L], 'b')
plot([airfoil.alpha_0, max_linear_alpha], [0, max_linear_C_L_corrected], 'g')

end

