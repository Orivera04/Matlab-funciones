% P3_22 Determine if matrix A*B is symmetric
% As written the script uses fixed matrices A*B and
%  displays A, B, and A*B and the result
%  This script calls function is_sym
A = [3 2 0;2 2 -2;0 -2 4]
B = [1 0 1;0 2 0;1 0 3]
fprintf('\n Press a key to continue Atest=A*B\n');
pause
Atest=A*B
%
if is_sym(Atest)
 fprintf('\n A*B is symmetrical\n\n')
else
 fprintf('\nA*B is not symmetrical\n\n')
end
%
% Rewrite the script as a more general script or as a function
% to allow input and testing of arbitrary matrices 
%