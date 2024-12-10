function [airfoil] = calculate_finite_wing(airfoil, sim, plane)

% calculate alpha_0
airfoil.alpha_0 = nan;
for i = 1:length(airfoil(1).data.CL)
    c_l = airfoil(1).data.CL(i);
    if c_l > 0
        assert(i > 1);
        c_l_prev = airfoil(1).data.CL(i-1);
        amount_between = -c_l_prev / (c_l - c_l_prev);
        airfoil.alpha_0 = airfoil(1).data.alpha(i-1) * (1 - amount_between) + airfoil(1).data.alpha(i) * amount_between;
        break;
    end
end

% calculate a_0
dalpha = airfoil(1).data.alpha(sim.max_linear_alpha_index) - airfoil(1).data.alpha(1);
dc_l = airfoil(1).data.CL(sim.max_linear_alpha_index) - airfoil(1).data.CL(1);
airfoil.a_0 = dc_l / dalpha;

% calculate a
airfoil.a = airfoil.a_0 / (1 + 57.3 * airfoil.a_0 / (pi * plane.e * plane.AR));

end

