% Plot the first few Legendre polynomials

x=[-1:.01:1];
y = zeros(6,201);

for k=0:5
    y(k+1,:) = polyval(LegendrePoly(k),x);
end

figure;
plot(x,y(1,:),x,y(2,:),x,y(3,:),x,y(4,:),x,y(5,:),x,y(6,:)),
    xlabel('x'),...
    ylabel('P_n(x)'),title('Legendre polynomials (n\leq 5)')
h = legend('P_0', 'P_1', 'P_2', 'P_3', 'P_4', 'P_5', 4);
grid on;
