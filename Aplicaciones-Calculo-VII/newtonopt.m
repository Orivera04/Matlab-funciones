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
%       To illustrate Newton's method of solving Optimization problems

% Keyword
%       Newton's Method
%       Optimization
%% Display information

% This displays title information
disp(sprintf('\n\nSimulation of the Newtons Method of Optimization'))
disp(sprintf('University of South Florida'))
disp(sprintf('United States of America'))
disp(sprintf('kaw@eng.usf.edu\n'))


% Problem Statement
% The cross-sectional area of a gutter with equal base and edge length of
% 2 is given by, A=4*sin(theta)*(1+cos(theta)). Use an initial interval
% of (0,pi/2). Find the interval after 3 iterations. Use an intial interval
% epsilon=0.2

disp(sprintf('\n*******************************Problem Statement**********'))
disp(sprintf('The cross-sectional area   of a gutter with equal base and edge length of'))
disp(sprintf('2 is given by, A=4*sin(theta)*(1+cos(theta)). Use an initial interval'))
disp(sprintf('of (0,pi/2). Use the intial guess value to be pi/4. Performs the iterations till'))
disp(sprintf(' the accuracy is with in 1%'))

%% Inputs
%       This is the only place in the program where the user makes the changes
%       based on their wishes

%*************************************************************************

%Surface area of the gutter
syms theta
A=4*sin(theta)*(1+cos(theta));

% Lower limit of the interval
xl=0;

% upper limit of the interval
xu=pi/2;

% Initial Guess
theta_0=pi/4;

% Tolerance
tol=1;

%*************************************************************************

disp(sprintf('\n\n********************************Input Data**********************************\n')) 
disp(sprintf('     Function to be optimized = %s, Surface area of the  gutter ',char(A) )) 
disp(sprintf('     a = %g, Lower limit of the initial interval ',xl))
disp(sprintf('     b = %g, Upper limit of the initial interval ',xu))
disp(sprintf('     Initial guess = %g, Initial guess for the newton method ',theta_0))
disp(sprintf('     Tolerance = %g, Allowable Tolerance ',tol))



%% Programming the Newton's Method with displaying the Outputs

disp(sprintf('\n\n******Performing the Newtons method along the theta dimension******************\n\n')) 

epsa=tol+100;
iteration=0;
theta_val=theta_0;

% This loop is repeated till the absolute relative percentage difference is
% less than the tolerance value (Convergence condition)
while(epsa>tol)
    
% iteration, counting the number of iterations
iteration=iteration+1; 

%Calculating f'(theta)
dA=diff(A,theta,1);

%Calculating f"(theta)
d2A=diff(A,theta,2);

%Calculating f'(theta) @ theta=theta_value
dA_val=subs(dA,theta,theta_val);

%Calculating f'(theta) @ theta=theta_value
d2A_val=subs(d2A,theta,theta_val);

%Storing the theta value from the previous iteration
theta_old=theta_val;

%Calculating the new theta value
theta_val=theta_val-(dA_val/d2A_val);

% Finding the absolute relative percentage difference between the present
% and previous approximation
epsa=abs((theta_val-theta_old)/theta_val)*100;

%Finding the f(theta) @ theta_val
A_val=subs(A,theta,theta_val);

%Printing the iteration number
fprintf('Iteration Number=%g\n',iteration)

%Printing the new approximation
fprintf('optimized theta=%g radians\n\n\n',theta_val)

end



