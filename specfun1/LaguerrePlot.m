% Plot the first few Laguerre polynomials

x=[0:.02:5];
y = zeros(6,251);

for k=0:5
    y(k+1,:) = polyval(LaguerrePoly(k),x);
end

figure;
plot(x,y(1,:),x,y(2,:),x,y(3,:),x,y(4,:),x,y(5,:),x,y(6,:)),
    xlabel('x'),...
    ylabel('L_n(x)'),title('Laguerre polynomials (n\leq 5)')
h = legend('L_0', 'L_1', 'L_2', 'L_3', 'L_4', 'L_5', 3);
grid on;
