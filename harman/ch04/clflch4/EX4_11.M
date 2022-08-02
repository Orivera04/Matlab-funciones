%EX4_11.M Example to show matrix operations (A^2, A^5, exp(A)) 
% Requires Symbolic Math Toolbox
%
A=[1 0 0;0 2 0;0 0 3]
Asq=A^2	        % Matrix power A*A
Afifth=A^5      % A*A*A*A*A
expA=expm(A)	% Exponential expm(A)
%
% Symbolic calculation of A*A 
syms a b c d 
Asym=[a, b ;c, d]
Asymsq = sym(Asym)*sym(Asym)
%
% Version 5 Use syms and replace sympow with sym * sym