clc
clf
clear all

% Mfile name
%       mtl_int_sim_eulerconv.m

% Revised:
%       March 7, 2008

% % Authors
%       Nathan Collier, Autar Kaw
%       Department of Mechanical Engineering
%       University of South Florida
%       Tampa, Fl 33620
%       Contact: kaw@eng.usf.edu | http://numericalmethods.eng.usf.edu/contact.html

% Purpose
%       To illustrate the convergence of euler's method applied
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

   fcnstr='y*x^2-1.2*y' ;
   f=inline(fcnstr) ;

% x0, x location of known initial condition

   x0=0 ;

% y0, corresponding value of y at x0

   y0=1 ;

% xf, x location at where you wish to see the solution to the ODE

   xf=2 ;

% n, maximum number of steps to take. Needs to be in powers of 2,
%    for example 2,4,8,16,...

   n=128 ;

%**********************************************************************

% Displays title information
disp(sprintf('\n\nEuler Method of Solving Ordinary Differential Equations'))
disp(sprintf('University of South Florida'))
disp(sprintf('United States of America'))
disp(sprintf('kaw@eng.usf.edu\n'))
disp('NOTE: This worksheet demonstrates the use of Matlab to illustrate ')
disp('Euler''s method, a numerical technique in solving ordinary differential')
disp('equations.') 

disp(sprintf('\n*******************************Introduction*********************************'))

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
    ya = ya + f(xa,ya)*h ;
    xa = xa + h ;
 
    % store these variables for plotting later
    xaa(j)=xa ;
    yaa(j)=ya ;
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
title('Exact and Approximate Solution of the ODE by RK4 Method');
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











