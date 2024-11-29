function [] = plotfoil(airfoil)

x = airfoil.foil.x(:, end);
x = x(x <= 1);
y = airfoil.foil.y(1:length(x), end);

plot(x(:,end), y(:,end))
daspect([1 1 1])

end

