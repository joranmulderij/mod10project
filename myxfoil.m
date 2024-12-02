function [airfoil] = myxfoil(coords, simops)

[airfoil.data,airfoil.foil] = xfoil(coords,simops.alpha,simops.Re,simops.Mach,'oper iter 60','ppar N 181','oper xtr 0.1 0.1');

end

