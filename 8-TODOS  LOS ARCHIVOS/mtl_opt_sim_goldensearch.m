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
%       To illustrate equal interval search method of solving Optimization
%       Problems

% Keyword
%       Golden Section Search Method
%       Optimization
%% Display information

% This displays title information
disp(sprintf('\n\nSimulation of the Golden Section Search Method of Optimization'))
disp(sprintf('University of South Florida'))
disp(sprintf('United States of America'))
disp(sprintf('kaw@eng.usf.edu\n'))


% Problem Statement
% The cross-sectional area of a gutter with equal base and edge length of
% 2 is given by, A=4*sin(theta)*(1+cos(theta)). Use an initial interval
% of (0,pi/2). Use an intial interval epsilon=0.05

disp(sprintf('\n*******************************Problem Statement**********'))
disp(sprintf('The cross-sectional area   of a gutter with equal base and edge length of'))
disp(sprintf('2 is given by, A=4*sin(theta)*(1+cos(theta)). Use an initial interval'))
disp(sprintf('of (0,pi/2). Find the Use an intial epsilon value to be 0.05'))

%% Inputs
%       This is the only place in the program where the user makes the changes
%       based on their wishes

%*************************************************************************

%Surface area of the gutter
A=inline('4*sin(theta)*(1+cos(theta))');

% Lower limit of the interval
xl=0;

% upper limit of the interval

xu=pi/2;

% Initial Interval

epsilon=0.05;

%*************************************************************************

disp(sprintf('\n\n********************************Input Data**********************************\n')) 
disp(sprintf('     Function to be optimized = %s, Surface area of the  gutter ',char(A) )) 
disp(sprintf('     a = %g, Lower limit of the initial interval ',xl))
disp(sprintf('     b = %g, Upper limit of the initial interval ',xu))
disp(sprintf('     Epsilon = %g, Interval proximity ',epsilon))


%% Programming the Golden Section Search Method with displaying the Outputs

disp('**********************************************************************************************')
disp('Golden section search method')
range=100*epsilon;
iteration=0;
while(range>epsilon)
    
% iteration, counting the number of iterations
iteration=iteration+1;    
d=(sqrt(5)-1)/2*(xu-xl);

%calculatiing the point x1
x1=xl+d;

%calculating the point x2
x2=xu-d;

%calculating f(x1)
val1=A(x1);

%calculating f(x2);
val2=A(x2);

% storing the interval as an array
interval=[xl xu];

%calculating the range of the interval
range=xu-xl;

%Calculating the optimization point, (xl+xu)/2
optimization_point= (xu+xl)/2;

% Storing the values in matrix to display at the end

%Printing the Iteration Number
fprintf('Iteration Number=%g\n',iteration)

%Printing the search interval
fprintf('Search Interval=')
disp(interval)

%Printing the optimization point
fprintf('optimization point=%g\n\n\n',optimization_point)

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




  

