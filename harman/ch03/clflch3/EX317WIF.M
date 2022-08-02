% EX317WIF.M  20 x 20 hilbert
%   Test the condition number and error in Hilb20*x=b
%      x=[1 1 1 ....1]
clear                  % Clear variables and the screen
clc
format rat             % Rational numbers
Hilb20=hilb(20);       % 20 x 20
% Look at a few entries
Hilrow1=Hilb20(1,:)    % First row  1  1/2  ...... 1/n	
pause                  % Strike a key to continue    
Hilrow20=Hilb20(20,:)  % 20th row 1/20 .....      1/(2n-1)
pause
%
% Find b in Hilb20 * x =b  
%
xexact=ones(20,1);     % Column matrix
b=Hilb20*xexact        % Constant (displayed)
pause
%
%  Let MATLAB try and solve it and then display errors
%
format long e
cnHilb20 = cond(Hilb20)  % Condition Number
pause
xcomp = Hilb20\b         % Computed value of solution
pause                    % Note MATLAB's message
fprintf('Error in calculated value\n')
xerror=xcomp - xexact   % Display error in each component
%
pause
format short
xcomp               % Easier to understand the error
%
% Display error in bcomp to see how far it is off 
%
pause
bcomp = Hilb20*xcomp;    % Look at bcomp if desired    
errorb=bcomp-b
%
%   The result is misleading bcomp is close but xcomp is way off
%


