% CLCONDNO.M Solve A*x=b for A a 5x5 Hilbert matrix
%  x=[1 1 1 1 1] is answer; xcomp is computed vector
% OUTPUT: Condition number (condA) and xerror=xcomp-x
% 
format rat	   % Show rational values
format compact     %   and suppress blank lines
A=hilb(5);         % Hilbert matrix
b=[137/60 87/60 459/420 743/840 1879/2520]';
x=[1 1 1 1 1];     % Exact answer	
% Check condition number and solve
fprintf('Condition number and error in xcomp:\n')
condA=cond(A)      % Display condition number
format long        % Format decimal values
xcomp=A\b;         % Computed value of solution
fprintf('Error in calculated value xcomp(I), I=1,5\n')
xerror=xcomp - x'

