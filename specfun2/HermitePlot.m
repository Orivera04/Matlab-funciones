% Plot the first few Hermite polynomials

x=[-2:.02:2];
y = zeros(6,201);

for k=0:5
    y(k+1,:) = polyval(HermitePoly(k),x);
end

figure;
plot(x,y(1,:),x,y(2,:),x,y(3,:),x,y(4,:),x,y(5,:),x,y(6,:)),
    xlabel('x'),...
    ylabel('H_n(x)'),title('Hermite polynomials (n\leq 5)')
h = legend('H_0', 'H_1', 'H_2', 'H_3', 'H_4', 'H_5', 3);
grid on;
