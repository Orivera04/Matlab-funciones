% EX5_17.M Step response of second order differential equation
%  D2y + 2*z*Wn*Dy + Wn^2*y=U(t) for underdamped and critically
%   damped system ; z=2/Wn and z=1, wn=sqrt(40) 
clear                % Clear workspace and
clf                  %  figures
Wn=sqrt(40)          % Natural frequency - radians/second
z1=2/Wn              % Damping
t=[0:.005:5];        % Time for plotting
y1=.2453*( 1 -(1/3)*exp(-2*t).*sin(6*t)-exp(-2*t).*cos(6*t)); 
ycrit=.2453*( 1-(1 + Wn*t).*exp(-Wn*t)); 
plot(t,y1,'-',t,ycrit,'-.')
axis([0,5,0,.5])     % Set plotting limits
xlabel('Time in seconds')
ylabel('y(t)')
title('Step Response of Second Order D.E.')
legend('z=.3162','z=1.0')
%
% Version 5  legend (lower case)
 