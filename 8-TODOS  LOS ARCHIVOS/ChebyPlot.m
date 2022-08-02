% Plot the first few Chebyshev polynomials

x=[-1:.01:1];
y = zeros(6,201);

for k=0:5
    y(k+1,:) = polyval(ChebyshevPoly(k),x);
end

figure;
plot(x,y(1,:),x,y(2,:),x,y(3,:),x,y(4,:),x,y(5,:),x,y(6,:)),
    xlabel('x'),...
    ylabel('T_n(x)'),title('Chebyshev polynomials (n\leq 5)')
h = legend('T_0', 'T_1', 'T_2', 'T_3', 'T_4', 'T_5', 4);
grid on;
