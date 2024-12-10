function [index] = indexwherealphais(airfoil, alpha)

for i = 1:length(airfoil.data.alpha)
    alpha_i = airfoil.data.alpha(i);
    if alpha > alpha_i
        index = i;
        return
    end
end

end

