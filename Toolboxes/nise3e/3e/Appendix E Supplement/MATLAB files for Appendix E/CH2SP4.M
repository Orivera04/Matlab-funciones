% Nise, N.S. 
% Control Systems Engineering, 3rd ed. 
% John Wiley & Sons, New York, NY, 10158-0012
%
% Control Systems Engineering Toolbox Version 3.0 
% Copyright © 2000 by John Wiley & Sons, Inc.
%
% ch2sp4 (Example 2.10)     MATLAB's Symbolic Math Toolbox may be used to simplify 
% the solution of simultaneous equations using  Cramer's Rule. A system of simultaneous 
% equations can be represented in matrix form by Ax = B, where A is the matrix formed 
% from the coefficients of the unknowns in the simultaneous equations, x is a vector 
% containing the unknowns, and B is a vector containing the inputs. Cramer's Rule states 
% that xk, the kth element of the solution vector, x, is found using xk = det(Ak)/det(A),
% where Ak is the matrix formed by replacing the kth column of matrix A  with the input 
% vector, B. In the text, we call det(A), delta. In MATLAB matrices are written with a 
% space or comma separating the elements of each row. The next row is indicated with a 
% semicolon or carriage return.  The entire matrix is then enclosed in a pair of square 
% brackets. Applying the above to the solution of Example 2.10: 
% A=[(R1+L*s) -L*s;-L*s (L*s+R2+(1/(C*s)))] and  Ak=[(R1+L*s) V;-L*s 0]. The function 
% det(matrix) evaluates the determinant of the square matrix argument. Let us now find 
% the transfer function, G(s) = I2(s)/V(s), asked for in Example 2.10. The function, 
% simple(S), where  S is a symbolic function, is introduced in the solution. Simple(S) 
% simplifies the solution by shortening the length of S. The use of simple(I2) shortens 
% the solution by combining like powers of the Laplace variable, s.

'(ch2sp4) Example 2.10'       % Display label.
syms s R1 R2 L C V            % Construct symbolic objects for frequency
                              % variable 's', and 'R1', 'R2', 'L', 'C', and 'V'.
A2=[(R1+L*s) V;-L*s 0]        % Form Ak = A2.
A=[(R1+L*s) -L*s;-L*s (L*s+R2+(1/(C*s)))]
                              % Form A.
I2=det(A2)/det(A);            % Use Cramer's Rule to solve for I2(s).
I2=simple(I2);                % Reduce complexity of I2(s).
G=I2/V;                       % Form transfer function, G(s) = I2(s)/V(s).
'G(s)'                        % Display label.
pretty(G)                     % Pretty print G(s).
