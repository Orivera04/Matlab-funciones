x=-4:0.05:4; y=exp(-0.5*x).*sin(5*x);
figure(1); plot(x,y);
xlabel('x-axis'); ylabel('y-axis');
hold on;
y=exp(-0.5*x).*cos(5*x);
plot(x,y);
grid; gtext('Two tails...');
hold off
