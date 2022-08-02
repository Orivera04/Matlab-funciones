% Nise, N.S. 
% Control Systems Engineering, 3rd ed. 
% John Wiley & Sons, New York, NY, 10158-0012
%
% Control Systems Engineering Toolbox Version 3.0 
% Copyright © 2000 by John Wiley & Sons, Inc.
%
% ch4sp2 (Example 4.12/4.13)     In this example we use MATLAB's 
% Symbolic Math Toolbox to solve state equations in the time domain.
% We make use of the Symbolic Math Toolbox's ability to perform
% integration. We first solve for the state-transition matrix
% by taking the inverse Laplace transform of (sI-A)^-1. We then use
% the convolution integral to obtain the solution. Integration is performed
% using the command int(S,v,a,b), where S is the function to be integrated, 
% v is the variable of integration, a is the lower limit of integration, 
% and b is the upper limit of integration. As an example we solve 
% Example 4.12 in the text. The state-transition matrix is obtained by the
% method demonstrated in Example 4.13 in the text.

'(ch4sp2) Example 4.12/4.13' % Display label.
syms s t tau                 % Construct symbolic object for frequency
                             % variable 's', 't', and 'tau'.
'a'                          % Display label.
A=[0 1;-8 -6]                % Create matrix A.
B=[0;1]                      % Create vector B.
X0=[1;0]                     % Create initial condition vector,X(0).
U=1                          % Create u(t).
I=[1 0;0 1];                 % Create identity matrix.
'E=(s*I-A)^-1'               % Display label.
E=((s*I-A)^-1)               % Find Laplace transform of state transition
                             % matrix, (sI-A)^-1.
Fi11=ilaplace(E(1,1));       % Take inverse Laplace transform 
Fi12=ilaplace(E(1,2));       % of each element                                             
Fi21=ilaplace(E(2,1));       % of (sI-A)^-1
Fi22=ilaplace(E(2,2));       % to find state transition matrix.
'Fi(t)'                      % Display label.
Fi=[Fi11 Fi12;Fi21 Fi22];    % Form state transition matrix, Fi(t).
pretty(Fi)                   % Pretty print state transition matrix, Fi(t).
Fitmtau=subs(Fi,t,t-tau);    % Form Fi(t-tau).
'Fi(t-tau)'                  % Display label.
pretty(Fitmtau)              % Pretty print Fi(t-tau).
x=Fi*X0+int(Fitmtau*B*1,tau,0,t);
                             % Solve for x(t).    
x=simple(x);                 % Collect terms.
x=simplify(x);               % Simplify x(t).
'x(t)'                       % Display label.
pretty(x)                    % Pretty print x(t).
