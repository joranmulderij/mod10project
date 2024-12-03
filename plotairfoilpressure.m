function [] = plotairfoilpressure(airfoil, index)

hold on
half = ceil(length(airfoil(1).foil.xcp)/2);
plot(airfoil(1).foil.xcp(1:half), airfoil(1).foil.cp(1:half,index));
plot(airfoil(1).foil.xcp(half+1:end), airfoil(1).foil.cp(half+1:end,index));
title(['c_p over x at \alpha = ', num2str(airfoil(1).foil.alpha(index))])
xlabel('x/c')
ylabel('c_p')
clear half

end

