clc
clf
clear all

% Mfile name
%       mtl_int_sim_finitedifmethod.m

% Revised:
%       March 7, 2008

% % Authors
%       Nathan Collier, Autar Kaw
%       Department of Mechanical Engineering
%       University of South Florida
%       Tampa, Fl 33620
%       Contact: kaw@eng.usf.edu | http://numericalmethods.eng.usf.edu/contact.html

% Purpose
%       To illustrate the finite difference method as applied
%       to a function of the user's choosing.

% Keyword
%       Finite Difference
%       Ordinary Differential Equations
%       2nd Order Boundary Value Problem

% Inputs
%       This is the only place in the program where the user makes the changes
%       based on their wishes

% Coefficients in the form 
%
%      a1(x) d/dx(dy/dx) + a2(x) dy/dx + a3(x) y + a4(x)
%
% Unlike the other functions, these need to be only functions of x. If
% if your function is not a function of x, add a 0*x term.

   a1=inline('1+x','x') ;
   a2=inline('2*x','x') ;
   a3=inline('3-x','x') ;
   a4=inline('4*x','x') ;

% x0, x location of known initial condition

   x0=0 ;

% y0, corresponding value of y at x0

   y0=10 ;

% xf, x location at where you wish to see the solution to the ODE

   xf=1 ;

% yf, y location at where you wish to see the solution to the ODE

   yf=12 ;

%**********************************************************************

% calculate the spacing
h=(xf-x0)/5.0 ;

% Approximation, set up system of equations
for i = 1:6
 x(i)=x0+(i-1)*h;
end

A=[1 0 0 0 0 0
    a1(x(2))/h^2-a2(x(2))/2/h a3(x(2))-a1(x(2))*2/h^2 a1(x(2))/h^2+a2(x(2))/2/h 0 0 0
    0 a1(x(3))/h^2-a2(x(3))/2/h a3(x(3))-a1(x(3))*2/h^2 a1(x(3))/h^2+a2(x(3))/2/h 0 0
    0 0 a1(x(4))/h^2-a2(x(4))/2/h a3(x(4))-a1(x(4))*2/h^2 a1(x(4))/h^2+a2(x(4))/2/h 0
    0 0 0 a1(x(5))/h^2-a2(x(5))/2/h a3(x(5))-a1(x(5))*2/h^2 a1(x(5))/h^2+a2(x(5))/2/h
    0 0 0 0 0 1];

B=[y0
    -a4(x(2))
    -a4(x(3))
    -a4(x(4))
    -a4(x(5))
yf];    

% Solve the system of equations
Y=inv(A)*B;

% Display title information
disp(sprintf('\n\nFinite Difference Method of Solving Ordinary Differential Equations'))
disp('University of South Florida')
disp('United States of America')
disp('kaw@eng.usf.edu')
disp(sprintf('\nNOTE: This worksheet demonstrates the use of Matlab to illustrate the \nFinite Difference method, a numerical technique in solving ordinary \ndifferential equations')) 

% Displays introduction information
disp(sprintf('\n*****************************Introduction*********************************'))
disp('This worksheet demonstrates how the finite difference method may be')
disp('used to solve higher order, ordinary differential equations. The ')
disp('differential equation solved here is of the form:')
disp(sprintf('\n   A1(x)*(d^2/dx^2)y + A2(x)*(d/dx)y + A3(x)*y + A4(x)=0\n'))
disp('An approximation is used for the derivatives and the differential ')
disp('equation is reduced to a system of linear equations.')

% Displays input data being used
disp(sprintf('\n\n****************************Input Data**********************************'))
format short g
disp(sprintf('\n     x0 = %g',x0))
disp(sprintf('     y0 = %g',y0))
disp(sprintf('     xf = %g',xf))
disp(sprintf('     yf = %g',yf))

disp(sprintf('\n-----------------------------------------------------------------'))
disp(sprintf('For this simulation, the following parameter is constant.'))
disp(sprintf('\n     h = %g',h))

% The following sets up the display of the linearized ODE.
disp(sprintf('\n********************************Simulation**********************************'))
disp(sprintf('\nThe following system is generated using a central divided difference for the'))
disp(sprintf('derivative terms.'))
disp(sprintf('\n   [1] y(1) = y0'))
disp(sprintf('   [2] (a1(x(2))/h^2-a2(x(2))/2/h)*y(2) + (a3(x(2))-a1(x(2))*2/h^2)*y(2)'))
disp(sprintf('            + (a1(x(2))/h^2+a2(x(2))/2/h)*y(2) = -A4(x(2)'))
disp(sprintf('   [3] (a1(x(3))/h^2-a2(x(3))/2/h)*y(3) + (a3(x(3))-a1(x(3))*2/h^2)*y(3)'))
disp(sprintf('            + (a1(x(3))/h^2+a2(x(3))/2/h)*y(3) = -A4(x(3)'))
disp(sprintf('   [4] (a1(x(4))/h^2-a2(x(4))/2/h)*y(4) + (a3(x(4))-a1(x(4))*2/h^2)*y(4)'))
disp(sprintf('            + (a1(x(4))/h^2+a2(x(4))/2/h)*y(4) = -A4(x(4)'))
disp(sprintf('   [5] (a1(x(5))/h^2-a2(x(5))/2/h)*y(5) + (a3(x(5))-a1(x(5))*2/h^2)*y(5)'))
disp(sprintf('            + (a1(x(5))/h^2+a2(x(5))/2/h)*y(5) = -A4(x(5)'))
disp(sprintf('   [6] y(6) = yf\n')) 


disp(sprintf('   [1] y(1) = %g',y0))
disp(sprintf('   [2] ( %g )*y(2) + ( %g )*y(2) + ( %g )*y(2) = %g',a1(x(2))/h^2-a2(x(2))/2/h,a3(x(2))-a1(x(2))*2/h^2,a1(x(2))/h^2+a2(x(2))/2/h,-a4(x(2))))
disp(sprintf('   [3] ( %g )*y(3) + ( %g )*y(3) + ( %g )*y(3) = %g',a1(x(3))/h^2-a2(x(3))/2/h,a3(x(3))-a1(x(3))*2/h^2,a1(x(3))/h^2+a2(x(3))/2/h,-a4(x(3))))
disp(sprintf('   [4] ( %g )*y(4) + ( %g )*y(4) + ( %g )*y(4) = %g',a1(x(4))/h^2-a2(x(4))/2/h,a3(x(4))-a1(x(4))*2/h^2,a1(x(4))/h^2+a2(x(4))/2/h,-a4(x(4))))
disp(sprintf('   [5] ( %g )*y(5) + ( %g )*y(5) + ( %g )*y(5) = %g',a1(x(5))/h^2-a2(x(5))/2/h,a3(x(5))-a1(x(5))*2/h^2,a1(x(5))/h^2+a2(x(5))/2/h,-a4(x(5))))
disp(sprintf('   [6] y(6) = %g\n',yf))

disp('Solving this system for the unknowns (y(1),y(2),y(3),y(4),y(5), and y(6)) will')
disp('approximate the solution of the original ODE at those points.')
disp(sprintf('\n\n   (x,y)=(%g,%g)(%g,%g)(%g,%g)(%g,%g)(%g,%g)(%g,%g)\n\n',x(1),Y(1),x(2),Y(2),x(3),Y(3),x(4),Y(4),x(5),Y(5),x(6),Y(6)))

% plot the approximate solution
plot(x,Y,'LineWidth',2,'Color',[0 0 1]);
title('Approximate ODE Solution by Finite Differences');

