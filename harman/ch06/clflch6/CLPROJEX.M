% CLPROJEX.M Solve the equations of flight for a projectile 
%    with air resistance and plot trajectory
% INPUTS:  drag, initial velocity [Vox Voy] = [X0(1),X0(2)], 
%          M number of points in interval, h step size.
% Fixed Parameter Values g, t(0), r(0)
% Calls functions clrk4pj to solve system of equations and 
%  clprojf to define the system
global drag g
g=9.81;         % Gravity  9.81 m/sec-sec
t0=0.0;         % Initial time
r=[0 0];       % Initial [x y]
% Input Parameters
drag=input('drag= ');
% drag=0.0 is ideal case
v=input('Enter initial velocity v=[Vx(0) Vy(0)] = ');
M=input('Number of points= ');
h=input('Step in time= ');
%
Vx=v(1);        % Initial x velocity
Vy=v(2);        % Initial y velocity
X0=[r(1) r(2) Vx Vy];
% Let X(:,1)=x; X(:,2)=y; X(:,3)=x'; X(:,4)=y' state vector
% Create system matrix and solution 
%  Last is the index of the last nonzero value of X(:,2), i.e. y
[T,X,Last]=clrk4pj('clprojf',t0,M,h,X0);
%
fprintf('Strike a key to plot results\n')
pause
% Plot range versus height
plot(X(1:Last,1),X(1:Last,2))
title(['Projectile-Tfinal is ',num2str(T(Last)),'sec','; Drag= ',...
num2str(drag)])
xlabel('Range in meters')
ylabel('Height in meters')
hold off
%
% Modify the script (and the comments) to allow input of parameters
%  t(0) and r(0). The test cases are
%  x''= -drag*|v|x'  with ideal solution x= Vox*t  =X(1)
%  y''= -drag*|v|y'-g with ideal solution y=(-g/2)t**2+Voy*t=X(2)
% Modify CLPROJF to change equations
