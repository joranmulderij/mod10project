function [airfoil] = myxfoil(coords, simopts)

[airfoil.data,airfoil.foil] = xfoil(coords,simopts.alpha,simopts.Re,simopts.Mach,'oper iter 60','ppar N 181','oper xtr 0.1 0.1');

end

