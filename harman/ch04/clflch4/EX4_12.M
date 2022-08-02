% EX4_12.M Demonstrate Caley-Hamilton theorem
%   as in Example 4.12 for A^2-(a+d)*A+(ad-bc)*I=0.
%  (This requires the Symbolic Math Toolbox)
%
fprintf('Test of Caley-Hamilton theorem \n')
A=sym('[a,b;c,d]')      % General 2x2 matrix
I=sym('[1,0;0,1]');     % Identity
c1='a+d';
c2='a*d-b*c';
Aconst=sym(c2)*sym(I);    % Compute constant term
Alin=sym(c1)*sym(A);      % Linear term
Asq=sym(A)^2;             % A^2
R1=sym(Aconst)-sym(Alin); % Sum the terms
R2=sym(Asq)+sym(R1);
%  
fprintf('Strike a key to continue \n')
pause
fprintf('Result = A^2-(a+d)*A+(ad-bc)*I =0? \n')
Result=simplify(R2)
%
% Version 5 Replaced symmul, etc.
