function [] = plotfoil(airfoil, chord_length)

x = airfoil.x(:, end);
x = x(x <= 1);
y = airfoil.y(1:length(x), end);

plot(x(:,end)*chord_length, y(:,end)*chord_length)
daspect([1 1 1])

hold on

end

