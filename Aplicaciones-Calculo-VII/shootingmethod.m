clc
clf
clear all

% Mfile name
%       mtl_int_sim_shootingmethod.m

% Revised:
%       March 7, 2008

% % Authors
%       Nathan Collier, Autar Kaw
%       Department of Mechanical Engineering
%       University of South Florida
%       Tampa, Fl 33620
%       Contact: kaw@eng.usf.edu | http://numericalmethods.eng.usf.edu/contact.html

% Purpose
%       To illustrate the use of Runge-Kutta method in the Shooting method as applied
%       to a function of the user's choosing.

% Keyword
%       Runge-Kutta
%       Shooting Method
%       Ordinary Differential Equations
%       2nd Order Boundary Value Problem

% Inputs
%       This is the only place in the program where the user makes the changes
%       based on their wishes

% Define the differential equation to be solved for of the form
% 
%      A1*d/dx(dy/dx) + A2*dy/dx + A3*y + A4 = 0
%
% The coefficients a1, a2, and a3 can be functions of x and y while
% a4 can be a function of x only. Define these functions here. 

   A1 = @(x,y) 2 ;
   A2 = @(x,y) 4 ;
   A3 = @(x,y) 6 ;
   A4 = @(x) 8 ;

% Create functions 1 and 2 for use in the method

   f1 = @(x,y,z) z ;
   f2 = @(x,y,z) 1/A1(x,y)*(A2(x,y)*z+A3(x,y)*y+A4(x)) ;

% x0, x location of known initial condition

   x0=0 ;

% y0, corresponding value of y at x0

   y0=10 ;

% xf, x location of known boundary condition

   xf=1 ;

% yf, corresponding value of y at x0

   yf=0 ;

% dydx1, initial guess of the derivative dy/dx at x = x0

   dydx1 = -15 ;

% dydx2, initial guess of the derivative dy/dx at x = x0

   dydx2 = -10 ;

% n, number of steps to take

   n=10 ;

%**********************************************************************

% Displays title information
disp(sprintf('\n\nShooting Method of Solving Ordinary Differential Equations'))
disp('University of South Florida')
disp('United States of America')
disp('kaw@eng.usf.edu')
disp('NOTE: This worksheet demonstrates the use of Matlab to illustrate the')
disp('shooting method (by means of the 4th Order Runge-Kutta method) to solve')
disp('higher order ODE''s with displacement boundary conditions.') 

disp(sprintf('\n*******************************Introduction*********************************'))
% Displays introduction text
disp(sprintf('The shooting method of solving ODEs is used when there are multiple initial \nconditions to be satisfied at different independent variable locations. For \nexample, as in many real life problems such as a simply supported beam, \nthe boundary conditions are y(0) = 0 and y(L) = 0 where y represents the \ndisplacement and L is the beam length. The methods for solving ODE''s \nbegin at one point and using approximations of the derivative, find the \nsolution from one end to another. These methods will not take into account \nthe boundary condition on the other end. The shooting method uses a method \nof solving ODEs (4th order Runge-Kutta in this example) in a way that \nsatisfies both boundary conditions'))

% Displays inputs used
disp(sprintf('\n\n****************************Input Data******************************'))
disp('Below are the input parameters to begin the simulation. Although this method')
disp('can be used to solve ODE''s of any order, the ODE being approximated here is')
disp('of second order.')
disp(sprintf('\n     A1*d/dx(dy/dx) + A2*(dy/dx) + A3*y + A4 = 0\n'))
disp('This second order equation can be written in terms of 2 first order equations.')
disp('The user must be able to break up his ODE into these two functions.') ;
disp(sprintf('\n     f1 = dy/dx = z    '))
disp(sprintf('     f2 = dz/dx = 1/A1 * ( A2*z + A3*y + A4 )'))
disp(sprintf('     x0 = initial x'))
disp(sprintf('     y0 = initial y'))
disp(sprintf('     xf = final x'))
disp(sprintf('     yf = final y'))
disp(sprintf('     dydx1 = 1st guess of derivative at x = x0'))
disp(sprintf('     dydx2 = 2nd guess of derivative at x = x0'))
disp(sprintf('     n = number of steps to take')) 
format short g
disp(sprintf('\n-----------------------------------------------------------------'))
disp(sprintf('\n     x0 = %g',x0))
disp(sprintf('     y0 = %g',y0))
disp(sprintf('     xf = %g',xf))
disp(sprintf('     yf = %g',yf))
disp(sprintf('     dydx1 = %g',dydx1))
disp(sprintf('     dydx2 = %g',dydx2))
disp(sprintf('     n = %g',n))
disp(sprintf('\n-----------------------------------------------------------------'))
disp(sprintf('For this simulation, the following parameters are constant.'))

% compute the spacing
h=(xf-x0)/n ;
disp(sprintf('\n     h = ( xf - x0 ) / n'))
disp(sprintf('       = ( %g - %g ) / %g',xf,x0,n))
disp(sprintf('       = %g',h))

% determine the x value for each step
for i = 1:n+1
  x(i)=x0+(i-1)*h;
end

% The simulation begins here.
disp(sprintf('\n\n********************************Simulation**********************************'))
disp(sprintf('\nIteration 1'))
disp(sprintf('-----------------------------------------------------------------'))
disp('The first step is to use the 4th Order Runge-Kutta method to solve the')
disp('problem using the first guess for the derivative (dydx1) and only the left')
disp('boundary conditions (x0,y0). If the initial guess for the derivative was right,')
disp('then the approximation should end up exactly on yf. The following shows the')
disp('result of the 4th Order Runge-Kutta method and compares it to the second')
disp('boundary condition.')

% Set initial conditions and pick first derivative as initial condition.
y1(1)=y0;
z1(1)=dydx1;

% Application of 4th order Runge-Kutta to solve higher order ODE's
for i = 1:n
  k1y=f1(x(i),y1(i),z1(i));
  k1z=f2(x(i),y1(i),z1(i));
  k2y=f1(x(i)+0.5*h,y1(i)+0.5*k1y*h,z1(i)+0.5*k1z*h);
  k2z=f2(x(i)+0.5*h,y1(i)+0.5*k1y*h,z1(i)+0.5*k1z*h);
  k3y=f1(x(i)+0.5*h,y1(i)+0.5*k2y*h,z1(i)+0.5*k2z*h);
  k3z=f2(x(i)+0.5*h,y1(i)+0.5*k2y*h,z1(i)+0.5*k2z*h);
  k4y=f1(x(i)+h,y1(i)+k3y*h,z1(i)+k3z*h);
  k4z=f2(x(i)+h,y1(i)+k3y*h,z1(i)+k3z*h);
  y1(i+1)=y1(i)+h/6*(k1y+2*k2y+2*k3y+k4y);
  z1(i+1)=z1(i)+h/6*(k1z+2*k2z+2*k3z+k4z);
end  

disp(sprintf('\n     y1(xf) = %g',y1(n+1)))
disp(sprintf('     yf = %g\n',yf))

disp(sprintf('\nIteration 2'))
disp(sprintf('-----------------------------------------------------------------'))
disp('Most likely the first guess of the derivative was not correct. So we repeat')
disp('this process using the second guess for the derivative (dydx2). Again, we')
disp('can compare the results with the boundary condition.')
    
y2(1)=y0;
z2(1)=dydx2;
for i = 1:n
  k1y=f1(x(i),y2(i),z2(i));
  k1z=f2(x(i),y2(i),z2(i));
  k2y=f1(x(i)+0.5*h,y2(i)+0.5*k1y*h,z2(i)+0.5*k1z*h);
  k2z=f2(x(i)+0.5*h,y2(i)+0.5*k1y*h,z2(i)+0.5*k1z*h);
  k3y=f1(x(i)+0.5*h,y2(i)+0.5*k2y*h,z2(i)+0.5*k2z*h);
  k3z=f2(x(i)+0.5*h,y2(i)+0.5*k2y*h,z2(i)+0.5*k2z*h);
  k4y=f1(x(i)+h,y2(i)+k3y*h,z2(i)+k3z*h);
  k4z=f2(x(i)+h,y2(i)+k3y*h,z2(i)+k3z*h);
  y2(i+1)=y2(i)+h/6*(k1y+2*k2y+2*k3y+k4y);
  z2(i+1)=z2(i)+h/6*(k1z+2*k2z+2*k3z+k4z);
end

disp(sprintf('\n     y2(xf) = %g\n     yf = %g\n',y2(n+1),yf))

disp(sprintf('\nIteration 3'))
disp(sprintf('-----------------------------------------------------------------'))

% Linearly interpolate to obtain another estimate for the derivative at x = x0    
dydx3=(dydx1-dydx2)/(y1(n+1)-y2(n+1))*(yf-y2(n+1))+dydx2;
y3(1)=y0;
z3(1)=dydx3;

disp('Now we can use these two results to find a new approximation for the')
disp('derivative. We can linearly interpolate to find and approximation for dydx3.')
disp('This will certainly get the next guess closer, although how close will depend')
disp('on the character on the ODE.')
disp(sprintf('\n     dydx3 = ( dydx1 - dydx2 )/( y1(xf) - y2(xf) )*( yf - y2(xf) ) + dydx2'))
disp(sprintf('     dydx3 = ( %g - %g )/( %g - %g )*( %g - %g ) + %g',dydx1,dydx2,y1(n+1),y2(n+1),yf,y2(n+1),dydx2))
disp(sprintf('           = %g\n',dydx3))

for i = 1:n
  k1y=f1(x(i),y3(i),z3(i));
  k1z=f2(x(i),y3(i),z3(i));
  k2y=f1(x(i)+0.5*h,y3(i)+0.5*k1y*h,z3(i)+0.5*k1z*h);
  k2z=f2(x(i)+0.5*h,y3(i)+0.5*k1y*h,z3(i)+0.5*k1z*h);
  k3y=f1(x(i)+0.5*h,y3(i)+0.5*k2y*h,z3(i)+0.5*k2z*h);
  k3z=f2(x(i)+0.5*h,y3(i)+0.5*k2y*h,z3(i)+0.5*k2z*h);
  k4y=f1(x(i)+h,y3(i)+k3y*h,z3(i)+k3z*h);
  k4z=f2(x(i)+h,y3(i)+k3y*h,z3(i)+k3z*h);
  y3(i+1)=y3(i)+h/6*(k1y+2*k2y+2*k3y+k4y);
  z3(i+1)=z3(i)+h/6*(k1z+2*k2z+2*k3z+k4z);
end

disp('Now we can use this new approximation for the derivative (dydx3) to solve')
disp('another 4th Order Runge-Kutta problem. Comparing the result with the')
disp('boundary condition, we find')

disp(sprintf('\n     y3(xf) = %g',y3(n+1)))
disp(sprintf('     yf = %g',yf))
disp(sprintf('     Error = %g\n\n',y3(n+1)-yf))

% Plot the three approximations showing the improvement
plot([x0 xf],[y0 yf],'O','MarkerSize',10,'Color',[0 0 0]);
hold on
plot(x,y1,'-','LineWidth',2,'Color',[1 0 0]);
plot(x,y2,'-','LineWidth',2,'Color',[0 1 0]);
plot(x,y3,'-','LineWidth',2,'Color',[0 0 1]);
legend('Boundary Conditions','1st Iteration','2nd Iteration','3rd Iteration');


