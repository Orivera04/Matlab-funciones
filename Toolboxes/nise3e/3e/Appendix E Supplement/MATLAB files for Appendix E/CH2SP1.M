% Nise, N.S. 
% Control Systems Engineering, 3rd ed. 
% John Wiley & Sons, New York, NY, 10158-0012
%
% Control Systems Engineering Toolbox Version 3.0 
% Copyright © 2000 by John Wiley & Sons, Inc.
%
% Chapter 2: Modeling in the Frequency Domain
%
% ch2sp1    MATLAB's calculating power is greatly enhanced using the Symbolic 
% Math Toolbox. In this example we demonstrate its power by calculating inverse 
% Laplace transforms of F(s). The beginning of any symbolic calculation requires 
% defining the symbolic objects. For example, the Laplace transform variable, s, 
% or the time variable, t, must be defined as a symbolic object. This definition 
% is performed using the syms command. Thus syms s defines s as a symbolic object; 
% syms t defines t as a symbolic object; and syms s t defines both s and t as 
% symbolic objects. We need only define objects that we input to the program. 
% Variables produced by the program need not be defined. Thus, if we are finding 
% inverse Laplace transforms, we need only define s as a symbolic object, since t 
% results from the calculation. Once the object is defined, we can then type F as 
% a function of s as we normally would write it. We do not have to use vectors to 
% represent the numerator and denominator. The Laplace transforms or time functions 
% can also be printed in the MATLAB Command Window as we normally would write it. 
% This form is called pretty printing. The command is pretty(F), where F is the 
% function we want to pretty  print. In the code below, you can see the difference 
% between normal printing and pretty printing if you run the code without the 
% semicolons at the steps where the functions, F or f, are defined.  Once F(s) is 
% defined as F, we can find the inverse Laplace transform using the command 
% ilaplace(F). In the example below, we find the inverse Laplace transforms of 
% the frequency functions in the examples used for Cases 2 and 3 in Section 2.2 
% in the text.   

'(ch2sp1)'                   % Display label.
syms s                       % Construct symbolic object for 
                             % Laplace variable 's'.
'Inverse Laplace transform'  % Display label.					 
F=2/[(s+1)*(s+2)^2];         % Define F(s) from Case 2 example.
'F(s) from Case 2'           % Display label.
pretty(F)                    % Pretty print F(s).
f=ilaplace(F);               % Find inverse Laplace transform.
'f(t) for Case 2'            % Display label.
pretty(f)                    % Pretty print f(t) for Case 2.
F=3/[s*(s^2+2*s+5)];         % Define F(s) from Case 3 example.
'F(s) for Case 3'            % Display label.
pretty(F)                    % Pretty print F(s) for Case 3.
f=ilaplace(F);               % Find inverse Laplace transform.
'f(t) for Case 3'            % Display label.
pretty(f)                    % Pretty print f(t) for Case 3.
