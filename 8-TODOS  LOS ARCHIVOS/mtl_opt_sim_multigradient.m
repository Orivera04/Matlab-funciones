clc
clear all


% Mfile name
%       mtl_opt_???.m

% Revised:
%       September 26, 2011

% % Authors
%       Sri Harsha Garapati, Autar Kaw
%       Department of Mechanical Engineering
%       University of South Florida
%       Tampa, Fl 33620
%       Contact: kaw@eng.usf.edu | http://numericalmethods.eng.usf.edu/contact.html

% Purpose
%       To illustrate Multidimensional gradient method of solving Optimization problems

% Keyword
%       Multidimensional Gradient Method
%       Optimization
%% Display information

% This displays title information
disp(sprintf('\n\nSimulation of the Multidimensional Gradient Method of Optimization'))
disp(sprintf('University of South Florida'))
disp(sprintf('United States of America'))
disp(sprintf('kaw@eng.usf.edu\n'))


% Problem Statement
% Determine the minimum of the function f(x,y)=x^2+y^2+2*x+4  
% Use the point (2,1) as the initial estimate of the optimal solution

disp(sprintf('\n*******************************Problem Statement**********'))
disp(sprintf('Determine the minimum of the function f(x,y)=x^2+y^2+2*x+4'))
disp(sprintf('Use the point (2,1) as the intial estimate of the optimal solution'))

%% Inputs
%       This is the only place in the program where the user makes the changes
%       based on their wishes

%*************************************************************************

%Function to be optimized
syms x y h
f=inline('x^2+y^2+2*x+4','x','y');

% Initial guess for x
xi=1;

% Initial guess for y
yi=1;

%*************************************************************************

disp(sprintf('\n\n********************************Input Data**********************************\n')) 
disp(sprintf('     Function to be optimized = %s ',char(f) )) 
disp(sprintf('     Initial guess for X = %g',xi))
disp(sprintf('     Initial guess for Y = %g',yi))

%% Programming the Newton's Method with displaying the Outputs

disp(sprintf('\n\n******Performing the Multidimensional Gradient Method******************\n\n')) 

%Assigning the initial guess as the x_value for 1st iteration
x_val=xi;

%Assigning the initial guess as the y_value for 1st iteration
y_val=yi;

%Partial differentiation of the function with respect to x
dfdx = inline(char(diff(f(x,y),sym('x'))),'x','y');

%Partial differentiation of the function with respect to y
dfdy = inline(char(diff(f(x,y),sym('y'))),'x','y');

% Assigning the random value to partial derivative of with respect to x
% (This is given random value just to get the loop started)
dfdx_val=100;

% Assigning the random value to partiaerivative of with respect to y
% (This is given random value just to get the loop started)
dfdy_val=100;

% This loop is repeated till the absolute relative percentage difference is
% less than the tolerance value (Convergence condition)
iteration=0;
while(dfdx_val~=0 && dfdy_val~=0)

%Value of partial derivative of function with respect to x at x= x guess
dfdx_val=dfdx(x_val,y_val);

%Value of partial derivative of function with respect to y at y=y guess
dfdy_val=dfdy(x_val,y_val);

if( dfdx_val~=0 && dfdy_val~=0)
iteration=iteration+1;
g=simplify( f( x_val+(dfdx_val*h ), y_val+(dfdy_val*h)  )    );
sol_g=double(real(solve(char(g))));

n=length(sol_g);


x_val=x_val+ (dfdx_val*sol_g(1));
y_val=y_val+ (dfdy_val*sol_g(1));

fprintf(' Iteration=%g \n',iteration)
fprintf(' The approximation value for X=%g \n',x_val)
fprintf(' The approximation value for Y=%g \n\n\n',y_val)
end

end



