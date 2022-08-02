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
%       To illustrate multi-dimensional search method of solving Optimization
%       Problems

% Keyword
%       Golden Section Search Method
%       Multi-dimensional search method
%       Optimization
%% Display information

% This displays title information
disp(sprintf('\n\nSimulation of the Multi Dimensional Search Method of Optimization'))
disp(sprintf('University of South Florida'))
disp(sprintf('United States of America'))
disp(sprintf('kaw@eng.usf.edu\n'))


% Problem Statement
% Use multidimensinal search method to optimize the surface area of the
% gutter.The cross-sectional area   of a gutter with base and edge is
% given by, A=(6-2*lcos(theta))l*sin(theta). Use an intial guess
% for length to be 3 and for theta to be pi/2. Use epsilon value of 0.05

disp(sprintf('\n*******************************Problem Statement**********'))
disp(sprintf('Use multidimensinal search method to optimize the surface area of the gutter.'))
disp(sprintf('The cross-sectional area   of a gutter with base and edge is'))
disp(sprintf('given by, A=(6-2*lcos(theta))l*sin(theta). Use an intial guess'))
disp(sprintf('for length to be 3 and for theta to be pi/2. Use epsilon value of 0.05'))

%% Inputs
%       This is the only place in the program where the user makes the changes
%       based on their wishes

%*************************************************************************

%Surface area of the gutter
syms theta l
A=(6-2*l+l*cos(theta))*l*sin(theta);

% Intial guess for unknown variable l
initial_l=3;

% Initialguess for unknown variable theta 
initial_theta=22/42;

% Initial Interval

epsilon=0.05;

%*************************************************************************

disp(sprintf('\n\n********************************Input Data**********************************')) 
disp(sprintf('     Function to be optimized = %s, Surface area of the  gutter ',char(A) )) 
disp(sprintf('     Intial guess for length = %g ',initial_l))
disp(sprintf('     Intial guess for theta = %g',initial_theta))
disp(sprintf('     Epsilon = %g, Interval proximity ',epsilon))



%% Programming the Golden Section Search Method along length dimension

disp(sprintf('\n\n******Performing the Golden section search method along the length dimension******************')) 
range=100*epsilon;
iteration=0;

% Lower limit of the length (zero) . Because length can not be negative
xl=0; 

%Upper limit of the length . This is taken from our intial guess
xu=initial_l;

% Performing the golden search method along the length direction
while(range>epsilon)

%Substituting the intial guess for theta in the function to be optimized
Area_l=subs(A,theta,initial_theta);
    
%Iteration, counting the number of iterations
iteration=iteration+1;

d=(sqrt(5)-1)/2*(xu-xl);

%calculatiing the point x1
x1=xl+d;

%calculating the point x2
x2=xu-d;

%calculating f(x1)
val1=subs(Area_l,l,x1);

%calculating f(x2);
val2=subs(Area_l,l,x2);

% storing the interval as an array
interval=[xl xu];

%calculating the range of the interval
range=xu-xl;

%Calculating the optimization point, (xl+xu)/2
optimization_length= (xu+xl)/2;

% Printing the iteration number for golden search method for length
% dimension
fprintf('Iteration Number=%g\n',iteration)

%Printing the interval
fprintf('Interval=')
disp(interval)

%Printing the optimization length approximation
fprintf('optimized approximation for length=%g\n\n\n',optimization_length)

%Adjusting the interval values for the next iteration

%if f(x1)>f(x2)
if(val1>val2)
    xl=x2;
    x2=x1;
    xu=xu;
    d=(sqrt(5)-1)/2*(xu-xl);
    x1=xl+d;
end

%if f(x1)<f(x2)
if(val1<val2)
    xl=xl;
    xu=x1;
    x1=x2;
    d=(sqrt(5)-1)/2*(xl-xu);
    x2=xu-d;
end
   
end



%% Programming the Golden Section Search Method along theta dimension

disp(sprintf('\n\n******Performing the Golden section search method along the theta dimension******************')) 
range=100*epsilon;
iteration=0;

% Lower limit of theta (zero)
xl=0; 

%Upper limit of the length . This is taken from our intial guess
xu=pi/2;

% Performing the golden search method along the length direction
while(range>epsilon)

%Substituting the intial guess for theta in the function to be optimized
Area_theta=subs(A,l,optimization_length);
    
%Iteration, counting the number of iterations
iteration=iteration+1;

d=(sqrt(5)-1)/2*(xu-xl);

%calculatiing the point x1
x1=xl+d;

%calculating the point x2
x2=xu-d;

%calculating f(x1)
val1=subs(Area_theta,theta,x1);

%calculating f(x2);
val2=subs(Area_theta,theta,x2);

% storing the interval as an array
interval=[xl xu];

%calculating the range of the interval
range=xu-xl;

%Calculating the optimization point, (xl+xu)/2
optimization_theta= (xu+xl)/2;

% Printing the iteration number for golden search method for theta
% dimension
fprintf('Iteration Number=%g\n',iteration)

%Printing the interval
fprintf('Interval=')
disp(interval)

%Printing the optimization theta approximation
fprintf('optimized approximation of theta=%g\n\n\n',optimization_theta)

%Adjusting the interval values for the next iteration

%if f(x1)>f(x2)
if(val1>val2)
    xl=x2;
    x2=x1;
    xu=xu;
    d=(sqrt(5)-1)/2*(xu-xl);
    x1=xl+d;
end

%if f(x1)<f(x2)
if(val1<val2)
    xl=xl;
    xu=x1;
    x1=x2;
    d=(sqrt(5)-1)/2*(xl-xu);
    x2=xu-d;
end
   
end


%% Maximum Area of the gutter
Area_max=subs(A,l,optimization_length);
Area_max=double(subs(Area_max,theta,optimization_theta));

%% Output
disp(sprintf('\n\n******Final Output******************')) 
fprintf(' Optimization values for Length=%g\n',optimization_length)
fprintf(' Optimization values for Theta=%g\n',optimization_theta)
fprintf(' Maximum surface area of the gutter=%g\n',Area_max);


