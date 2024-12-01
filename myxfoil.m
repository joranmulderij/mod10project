function [airfoil] = myxfoil(coords, ops)

[airfoil.data,airfoil.foil] = xfoil(coords,ops.alpha,ops.Re,ops.Mach,'oper iter 60','ppar N 181','oper xtr 0.1 0.1');

end

