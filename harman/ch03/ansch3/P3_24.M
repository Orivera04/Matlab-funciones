% P3_24.M  M-file to reduce the matrix
% A=[1 0 7;0 1 5;2 -1 9]
%  MATLAB does it first and then it is reduced by "hand"
%
echo on          % Monitor each step
A=[1 0 7;0 1 5;2 -1 9]
Atst=A;		 % Save a copy
%  MATLAB results
rankA=rank(A)
reducdA=rref(A)
pause            % Strike a key to continue*
clear A          % Start fresh
%
%  Our solution
A=Atst;
A(3,:)=-2*A(1,:)+A(3,:);A    % Reduce it and display each step
A(3,:)=A(2,:)+A(3,:);A
%
% Determine the rank by inspection on screen
%
% * Add a comment on the display to indicate the results
%   and the need to strike a key
% Try to automate the reduction and then display the M-file rref.M
%   to see how MATLAB does it. 
%