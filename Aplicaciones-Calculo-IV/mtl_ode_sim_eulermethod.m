clc
clf
clear all

% Mfile name
%       mtl_int_sim_eulermethod.m

% Revised:
%       March 7, 2008

% % Authors
%       Nathan Collier, Autar Kaw
%       Department of Mechanical Engineering
%       University of South Florida
%       Tampa, Fl 33620
%       Contact: kaw@eng.usf.edu | http://numericalmethods.eng.usf.edu/contact.html

% Purpose
%       To illustrate Euler's method applied
%       to a function of the user's choosing.

% Keyword
%       Euler's Method
%       Convergence
%       Ordinary Differential Equations
%       Initial Value Problem

% Inputs
%       This is the only place in the program where the user makes the changes
%       based on their wishes

% dy/dx in form of f(x,y). In general it can be a function of both 
% variables x and y. If your function is only a function of x then
% you will need to add a 0*y to your function.

   fcnstr='exp(-x)+0*y' ;
   f=inline(fcnstr) ;

% x0, x location of known initial condition

   x0=3 ;

% y0, corresponding value of y at x0

   y0=2 ;

% xf, x location at where you wish to see the solution to the ODE

   xf=12 ;

% n, number of steps to take

   n=10 ;

%**********************************************************************

% Displays title information
disp(sprintf('\n\nEuler Method of Solving Ordinary Differential Equations'))
disp(sprintf('University of South Florida'))
disp(sprintf('United States of America'))
disp(sprintf('kaw@eng.usf.edu\n'))
disp('NOTE: This worksheet demonstrates the use of Matlab to illustrate ')
disp('Euler''s method, a numerical technique in solving ordinary differential')
disp('equations.') 

% Displays introduction text
disp(sprintf('\n***************************Introduction****************************')) 
disp('Euler''s method approximates the solution to an ordinary differential')
disp('equation by using the equation expressed in the form dy/dx = f(x,y) to')
disp('approximate the slope. This slope is used to project the solution to')
disp('the ODE a fixed distance away.')

% Displays inputs being used
disp(sprintf('\n\n****************************Input Data*****************************'))
disp(sprintf('     f = dy/dx ')) 
disp(sprintf('     x0 = initial x ')) 
disp(sprintf('     y0 = initial y ')) 
disp(sprintf('     xf = final x ')) 
disp(sprintf('     n = number of steps to take')) 
format short g
disp(sprintf('\n-----------------------------------------------------------------\n'))
disp(sprintf(['     f(x,y) = dy/dx = ' fcnstr]))
disp(sprintf('     x0 = %g',x0))
disp(sprintf('     y0 = %g',y0))
disp(sprintf('     xf = %g',xf))
disp(sprintf('     n = %g',n))
disp(sprintf('\n-----------------------------------------------------------------'))
disp(sprintf('For this simulation, the following parameter is constant.\n'))
h=(xf-x0)/n ;
disp(sprintf('     h = ( xf - x0 ) / n '))
disp(sprintf('       = ( %g - %g ) / %g ',xf,x0,n))
disp(sprintf('       = %g',h))
xa(1)=x0 ;
ya(1)=y0 ;

% Here begins the method
disp(sprintf('\n\n**************************Simulation*****************************'))

for i=1:n
  disp(sprintf('\nStep %g',i))
  disp(sprintf('-----------------------------------------------------------------'))

% Adding Step Size
  xa(i+1)=xa(i)+h ;

% Calculating f(x,y) at xa(i) and ya(i)
  fcn = f(xa(i),ya(i)) ;

% Using Euler's formula
  ya(i+1)=ya(i)+fcn*h ;

  disp('1) Evaluate the function f at the previous, values of x and y.')
  disp(sprintf('     f( x%g , y%g ) = f( %g , %g ) = %g',i-1,i-1,xa(i),ya(i),fcn))
  disp(sprintf('2) Apply the Euler method to estimate y%g',i))
  disp(sprintf('     y%g = y%g + f( x%g, y%g ) * h ',i,i-1,i-1,i-1))
  disp(sprintf('        = %g + %g * %g ',ya(i),fcn,h))
  disp(sprintf('        = %g',ya(i+1)))
  disp(sprintf('   at x%g = %g',i,xa(i+1)))
end

% The following are the results 
disp(sprintf('\n\n**************************Results****************************'))

% The following finds what is called the 'Exact' solution
xspan = [x0 xf];
[x,y]=ode45(f,xspan,y0);
[yfi dummy]=size(y);
yf=y(yfi);

% Plotting the Exact and Approximate solution of the ODE.
hold on
xlabel('x');ylabel('y');
title('Exact and Approximate Solution of the ODE by Euler''s Method');
plot(x,y,'--','LineWidth',2,'Color',[0 0 1]);            
plot(xa,ya,'-','LineWidth',2,'Color',[0 1 0]);
legend('Exact','Approximation');

disp('The figure window that now appears shows the approximate solution as ') 
disp('piecewise continuous straight lines. The blue line represents the exact')
disp('solution. In this case ''exact'' refers to the solution obtained by the')
disp(sprintf('Matlab function ode45.\n'))

disp('While Euler''s method is valid for approximating the solutions of') 
disp('ordinary differential equations, the use of the slope at one point')
disp('to project the value at the next point is not very accurate. Note the')
disp('approximate value obtained as well as the true value and relative true') 
disp('error at our desired point x = xf.')

disp(sprintf('\n   Approximate = %g',ya(n+1))) 
disp(sprintf('   Exact       = %g',yf))
disp(sprintf('\n   True Error = Exact - Approximate')) 
disp(sprintf('              = %g - %g',yf,ya(n+1)))
disp(sprintf('              = %g',yf-ya(n+1)))
disp(sprintf('\n   Absolute Relative True Error Percentage'))
disp(sprintf('              = | ( Exact - Approximate ) / Exact | * 100'))
disp(sprintf('              = | %g / %g | * 100',yf-ya(n+1),yf))
disp(sprintf('              = %g',abs( (yf-ya(n+1))/yf )*100))

disp(sprintf('\nThe Euler approximation can be more accurate if we made our'))
disp(sprintf('step size smaller (that is, increasing the number of steps).\n\n'))












