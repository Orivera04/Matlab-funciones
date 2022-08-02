% EX1_7.M Define t values (151 points, 0.0, 0.01, ...) and 
%  plot y(t)=(2*sqrt(3)/9)*exp(-4*t).*sin(w*t + pi/3)
t=[0:.01:1.5];
%  Define y(t)
w= 4*sqrt(3);		% Fixed frequency		
y=(2*sqrt(3)/9)*exp(-4*t).*sin(w*t + pi/3);
% Plot the results with a grid
clf			% Clear previous figures
plot(t,y)
grid
title('Plotting example')
xlabel('Time t')
ylabel('y(t)')
legend(['w=',num2str(w),' radians/sec'])
