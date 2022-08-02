% CL2ORDP.M To compute solution of ay''+by'+cy=pulse and plot y(t)
%  INPUT:  a (a not 0), b, c, tstart_t-tend_t for pulse, 
%          t0-tf for plot. 
%  Calls function cl2ordfp and ode23  
%  Variables a b c  tstart_t tend_t passed to function cl2ordfp
fprintf('Solve aD2y+bDy+cY=Pulse[Tstart to Tend]\n')
a=input('Input a=  ')                 % Input coefficients     
b=input('Input b=  ')
c=input('Input c=  ')					
% Input Pulse length to pass to function
tstart_t=input('Input Tstart of pulse ')  % Input time of pulse
tend_t=input('Input Tend of pulse ')
%
t0=input('Initial time for equation =  ') % Input time of plot
tf=input('Final time=  ')
x0=input('[y(0) Dy(0)] =  ')
x0t=x0'
% ode23 may call function cl2ordpf several times for each t.
[t,x]=ode23('cl2ordpf',[t0,tf],x0t,[],a,b,c,tstart_t,tend_t);     
% Output of ode23 is vector t and matrix x
% y values
y=x(:,1);       % Rename variables: solution y
dy=x(:,2);      % Derivative of y
%
title_x=input('Title =  ', 's')         % Input title and labels
xlabel_1=input('xlabel =  ','s')
ylabel_1=input('ylabel =  ','s')
% Pulse_to_plot - a column vector the length of t
length_t=length(t);                     % Plot the input pulse
clear pulse_to_plot
for i=1:length_t
  if t(i) < tstart_t     
       pulse_to_plot(i) = 0;
  elseif (tstart_t <= t(i)) & (t(i) <= tend_t) 
       pulse_to_plot(i) = 1;
  elseif t(i) > tend_t 
       pulse_to_plot(i) = 0;
  end
end
pulse_to_plot= (pulse_to_plot)';
plot(t,y,'-',t,pulse_to_plot,'*')       % Plot the solution
title(eval('title_x'))
xlabel(eval('xlabel_1'))
ylabel(eval('ylabel_1'))
grid
%
% Version 5 Changed call to ode23

