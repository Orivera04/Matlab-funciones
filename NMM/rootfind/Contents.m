% NMM toolbox:  routines for finding the roots of f(x) = 0
%
% bisect      Use bisection to find a root of the scalar equation f(x) = 0
% brackPlot   Find and plot brackets for roots of a function.
% demoBisect  Use bisection to find the root of x - x^(1/3) - 2
% demoNewton  Use Newton's method to find the root of f(x) = x - x^(1/3) - 2
% fx3         Evaluates f(x) = x - x^(1/3) - 2
% fx3n        Evaluate f(x) = x - x^(1/3) - 2 and dfdx for Newton algorithm
% legs        Evaluate f(theta) for picnic leg geometry.  Used with root-finders.
% legsn       Evaluate f(theta) and fprime(theta) for the picnic leg problem.
%             Used with the Newton's method.
% legsnNG     Evaluate f(theta) and fprime(theta) for the picnic leg problem.
%             without using global variables.  Used with newtonNG
% legz        Evaluate f(theta) for picnic leg geometry.  Use pass-through
%             parameters in fzero to send w, h, and b values to this function.
%             Used with fzero
% newton      Newton's method to find a root of the scalar equation f(x) = 0
% newtonNG    Newton's method to find a root of the scalar equation f(x) = 0
%             This version can pass optional input arguments to the f(x) function
% secant      Shell of the secant function.  Implementation left to the reader
% tablen      Use Newton's method to find dimensions of picnic table legs
% tablenNG    Use Newton's method to find dimensions of picnic table legs
%             Variable input arguments are passed through to newtonNG
% tablez      Use fzero to find dimensions of picnic table legs
