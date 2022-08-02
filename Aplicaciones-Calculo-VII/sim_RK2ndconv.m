clc
clf
clear all

% Mfile name
%       mtl_int_sim_RK2ndconv.m

% Revised:
%       March 7, 2008

% % Authors
%       Nathan Collier, Autar Kaw
%       Department of Mechanical Engineering
%       University of South Florida
%       Tampa, Fl 33620
%       Contact: kaw@eng.usf.edu | http://numericalmethods.eng.usf.edu/contact.html

% Purpose
%       To illustrate the convergence of the 2nd order Runge-Kutta method applied 
%       to a function of the user's choosing.

% Keyword
%       Runge-Kutta
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

   x0=2 ;

% y0, corresponding value of y at x0

   y0=1 ;

% xf, x location at where you wish to see the solution to the ODE

   xf=7 ;

% a2, parameter which must be between 0 and 1. Certain names are associated
% with different parameters.
% 
% a2 = 0.5 Heun's Method
%    = 2/3 Ralston's Method
%    = 1.0 Midpoint Method

   a2 = 0.5 ;

% n, maximum number of steps to take. Needs to be in powers of 2,
%    for example 2,4,8,16,...

   n=8 ;

%**********************************************************************

% Displays title information
disp(sprintf('\n\n2nd Order Runge-Kutta Method of Solving Ordinary Differential Equations'))
disp(sprintf('University of South Florida'))
disp(sprintf('United States of America'))
disp(sprintf('kaw@eng.usf.edu\n'))
disp('NOTE: This worksheet demonstrates the use of Matlab to illustrate ')
disp('the Runge-Kutta method, a numerical technique in solving ordinary ')
disp('differential equations.')


disp(sprintf('\n*******************************Introduction*********************************'))

% Displays introduction text
disp('The following simulation illustrates the convergence of the 2nd Order')
disp('Runge-Kutta method of solving ordinary differential equations (ODEs). ')
disp('This section is the only section where the user interacts with the ')
disp('program.  The user enters ordinary differential equation of the ')
disp('f(x, y)=dy/dx, the initial conditions, and the value of x at which the')
disp('solution is desired. By entering this data, the program will calculate')
disp('the exact (Matlab numerical value if it is not exact) value of the ')
disp('solution, followed by the results using 2nd Order Runge-Kutta method')
disp('with 1, 2, 4, 8 ... n steps. The program will also display the true')
disp('error, the absolute relative percentage true error, the approximate')
disp(' error, the absolute relative aprroximate percentage error, and the ')
disp('least number of significant digits correct all as a function of number ')
disp('of segments.')

% Displays what inputs are being used.
disp(sprintf('\n\n*****************************Input Data*******************************\n'))
disp(sprintf('     f = dy/dx ')) 
disp(sprintf('     x0 = initial x ')) 
disp(sprintf('     y0 = initial y ')) 
disp(sprintf('     xf = final x ')) 
disp(sprintf('     a2 = constant value between 0 and 1.'))
disp(sprintf('        = 0.5, Heun Method'))
disp(sprintf('        = 1.0, Midpoint Method'))
disp(sprintf('        = 0.66667, Ralston''s Method'))
disp(sprintf('     n = number of steps to take in powers of 2 (2,4,8,16...)')) 
format short g
disp(sprintf('\n-----------------------------------------------------------------\n'))
disp(sprintf(['     f(x,y) = dy/dx = ' fcnstr]))
disp(sprintf('     x0 = %g',x0))
disp(sprintf('     y0 = %g',y0))
disp(sprintf('     xf = %g',xf))
disp(sprintf('     n = %g',n))
disp(sprintf('\n-----------------------------------------------------------------'))
disp(sprintf('For this simulation, the following parameters are constant.\n'))

% Find the spacing, h
h=(xf-x0)/n ;
disp(sprintf('     h = ( xf - x0 ) / n '))
disp(sprintf('       = ( %g - %g ) / %g ',xf,x0,n))
disp(sprintf('       = %g',h))

% The following 3 parameters are needed by the method and calculated in the following fashion.
a1=1-a2 ;
disp(sprintf('\n    a1 = 1 - a2'))
disp(sprintf('       = 1 - %g',a2))
disp(sprintf('       = %g',a1))
p1=1/2/a2 ;
disp(sprintf('\n    p1 = 1 / ( 2 * a2 )'))
disp(sprintf('       = 1 / ( 2 * %g )',a2))
disp(sprintf('       = %g',p1))
q11=p1 ;
disp(sprintf('\n   q11 = p1'))
disp(sprintf('       = %g',q11))

% The following lines solve the ODE via the matlab function ode45. yf is selected to be the 
% exact value at xf.
xspan = [x0 xf];
[x,y]=ode45(f,xspan,y0);
[yfi dummy]=size(y);
yf=y(yfi);

% The proceeding loop runs the method in iteration, generating the approximation at different
% step sizes as well as the errors.
nstep = floor(log2(n)) ;

xaa=zeros(2^nstep+1,1) ;
yaa=zeros(2^nstep+1,1) ;

for i=0:nstep

  % Increases the number of steps to examine in powers of 2
  NN(i+1)=2^i ;
  h=(xf-x0)/NN(i+1) ;

  % Find the approximation
  xa=x0 ;
  ya=y0 ;
  xaa(1)=x0 ;
  yaa(1)=y0 ;
  for j=1:NN(i+1)
    k1 = f(xa,ya) ;
    k2 = f(xa+p1*h,ya+q11*k1*h) ;
    ya=ya+(a1*k1+a2*k2)*h ;
    xa=xa+h;
 
    % store these variables for plotting later
    xaa(j+1)=xa ;
    yaa(j+1)=ya ;
  end
  YY(i+1)=ya ;

  % Find the True Error, and Absolute Relative True Error
  Et(i+1)=yf-ya ;
  Etabs(i+1)=abs((ya-yf)/yf) ;

  % If you are on the 2nd iteration or later, calculate the Relative Error,
  % Absolute Relative Error, and Significant Digits correct. 
  if(i > 0)
    Ea(i+1)=YY(i+1)-YY(i) ;
    Eaabs(i+1)=abs((YY(i+1)-YY(i))/YY(i)) ;
    SD(i+1)=floor((2-log10(Eaabs(i+1)/0.5))) ;
    if(SD(i+1)<0)
      SD(i+1)=0
    end
  else
    Ea(1)=0 ;
    Eaabs(1)=0 ;
    SD(1)=0 ;
  end

end

% Display the results of the study in a table
disp(sprintf('\n\n************************Table of Values******************************\n'))

disp('       Approx       True      Relative       Approx   Rel Appr   Sig   ')
disp(' n      Soln        Error    True Error      Error     Error   Digits ')
disp('-----------------------------------------------------------------------')

for i=1:nstep+1
string = '%4i  %+1.3e  %+1.3e  %+1.3e  %+1.3e  %+1.3e  %2i' ;
disp(sprintf(string,NN(i),YY(i),Et(i),Etabs(i),Ea(i),Eaabs(i),SD(i)))
end
disp('-----------------------------------------------------------------------')


% The following generates 3 plots. This function detects information about your
% screensize and tries to then place/size the graphs accordingly.
scnsize = get(0,'ScreenSize');

% Graph 1: Exact and Approximate Solution at maximum N
hold on
xlabel('x');ylabel('y');
title('Exact and Approximate Solution of the ODE by RK2 Method');
plot(x,y,'--','LineWidth',2,'Color',[0 0 1]);            
plot(xaa,yaa,'-','LineWidth',2,'Color',[0 1 0]);
legend('Exact','Approximation');

% Graph 2: Approximation and True Errors
fig2=figure ;
set(fig2,'Position',[0.2*scnsize(3),0.2*scnsize(3),0.6*scnsize(3),0.2*scnsize(4)]) ;
subplot(1,3,1); plot(NN,YY,'-O','LineWidth',2,'Color',[1 0 0]);
title('Approximate vs Number of Steps')

subplot(1,3,2); plot(NN,Et,'-O','LineWidth',2,'Color',[0 0 1]);
title('Et vs Number of Steps')

subplot(1,3,3); plot(NN,Etabs,'-O','LineWidth',2,'Color',[0 0 1]);
title('Abs et vs Number of Steps')

% Graph 3: Relative Errors and Significant Digits
fig = figure ;
set(fig,'Position',[0.2*scnsize(3),0,0.6*scnsize(3),0.2*scnsize(4)]) ;
subplot(1,3,1); plot(NN,Ea,'-O','LineWidth',2,'Color',[0 1 0]);
title('Ea vs Number of Steps')

subplot(1,3,2); plot(NN,Eaabs,'-O','LineWidth',2,'Color',[0 1 0]);
title('Abs ea vs Number of Steps')

subplot(1,3,3); plot(NN,SD,'-O','LineWidth',2,'Color',[1 0.5 0.5]);
title('Significant Digits Correct vs Number of Steps')
