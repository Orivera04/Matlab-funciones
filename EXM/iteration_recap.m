%% Iteration Chapter Recap 
% This is an executable program that illustrates the statements
% introduced in the Iteration chapter of "Experiments in MATLAB".
% You can run it by entering the command
%
%    iteration_recap
%
% Better yet, enter
%
%    edit iteration_recap
%
% and run the program cell-by-cell by simultaneously 
% pressing the Ctrl-Shift-Enter keys.
%
% Enter
%
%   publish iteration_recap
%
% to see a formatted report.

%% Help and Documentation
%   help punct
%   doc punct

%% Format
    format short
    100/81
    format long
    100/81
    
    format short
    format compact

%% Names and assignment statements
    x = 42
    phi = (1+sqrt(5))/2
    Avogadros_constant = 6.0221415e23
    camelCaseComplexNumber = -3+4i
    
%% Expressions
   3*4 + 5*6
   3 * 4+5 * 6
   2*(3 + 4)*3
   -2^4 + 10*29/5
   3\126
   52-8-2

%% Iteration
% Use the up-arrow key to repeatedly execute
   x = sqrt(1+x)
   x = sqrt(1+x)
   x = sqrt(1+x)
   x = sqrt(1+x)

%% For loop
   x = 42
   for k = 1:12
      x = sqrt(1+x);
      disp(x)
   end

%% While loop
   x = 42;
   k = 1;
   while abs(x-sqrt(1+x)) > 5e-5
      x = sqrt(1+x);
      k = k+1;
   end
   k

%% Vector and colon operator
   k = 1:12
   x = (0.0: 0.1: 1.00)'

%% Plot
   x = -pi: pi/256: pi;
   y = tan(sin(x)) - sin(tan(x));
   z = 1 + tan(1);
   plot(x,y,'-', pi/2,z,'ro')
   xlabel('x')
   ylabel('y')
   title('tan(sin(x)) - sin(tan(x))')

%% Golden Spiral
   golden_spiral(4)
