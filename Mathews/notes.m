% NOTES
%
% MATLAB Preliminaries
% 
% MATLAB File types
% Scripts    are used for storing several executable statements.
% Functions  are used for functions and subroutines.
% MAT-files  are used for storing data.
% 
% Editing
% 
% The command window.
%
% 1. The command window is used for immediate mode entering and display 
% of variables and execution of a MATLAB command. 
% 
% 2. The command window is used for execution of a functions, subroutines 
% and programs that are stored in an  M-File .
% 
% The edit window.
%
% 1. The edit window is write and edit functions, subroutines and programs 
% which are to be stored in an  M-File. 
% 
% The graph window
% 
% 1. The graph window is used to view plotted data.
% 
% Diary
% Diary <filename>  directs output to the file
% Diary off         suspends the diary
% Diary on          turns diary on again
% 
% Conservation of resources
% 
%  Most numerical experiments involve columns of numbers which might extend 
% several pages.  It is not necessary to see all of the computations in a project.
% Judicious use of diary and files commands such as X(1:5:N) will reduce the 
% amount of paperwork.  Before you hand in a project, determine how little is required.
% 
% 
% Obtaining Help
% 
% HELP topic  gives help on the topic.
% HELP word  where 'word' is a filename, 
% displays the first comment lines in the M-file 'word.m'.
% 
% Housekeeping
% 
%   ;      Place at the end of line to suppress the computer echo.
%   ,      Used at the end of a line if the computer echo is desired.
%   %    This is a comment.
% 
%   format short       output displays four decimal places
%   format long        output displays fourteen decimal places
%   who                   list of variables
%   what                  list of files
%   clear                  clear workspace
%   clear variables   clear variables
%   clear functions   clear functions
%   clc                     clear display
%   clg                     clear graph
% 
% Assignment Statements
% 
%   ¯x = 2;
%   ¯y = x^2 -3*x + 2;
% 
% Form of a MATLAB Program M-File of executable statements
% 
% %  <program-name>
% {<specification-statements>}
% {<executable-statements>}
% 
% Form of a MATLAB Subroutine M-File
% 
% function (output-list) = <subroutine-name> (argument-list)
% {<specification-statements>}
% {<executable-statements>}
% 
% Example, store the following subroutine in the M-file;  sroot.m
% 
% function  r = sroot(A)
% % Newton's method to find  A^(1/2)
% p0 = 1;                             % Starting value.
% for k=1:50,
% p1 = (p0+A/p0)/2;
% disp(p1);
% if abs(p1-p0)/p1 < eps, break, end;
% p0 = p1;
% end
% 
% Form of a function (or subroutine) call.
% 
% ¯ sroot(5)
% 
%    3
%    2.33333333333333
%    2.23809523809524
%    2.23606889564336
%    2.23606797749998
%    2.23606797749979
%    2.23606797749979
% 
% 
% Form of a MATLAB function M-File
% 
% function <output-list> = <function-name> (argument-list)
% {<specification-statements>}
% {<executable-statements>}
% <output-name> = <returned computation>
% 
%   Store the following functions in the M-files:  f.m  and  G.m
% 
% function y = f(x)
% y = exp(-x./10) + sin(x);
% 
% function W = G(Z)       % Z is a 1 by 2 vector
% x = Z(1);
% y = Z(2);
% W = [x.^2-y.^2  2*x.*y];
% 
% Form of a Function call.
% ¯f(pi/2)
% 
%  ans =
%  1.85463599915323
% 
% ¯G([2 1])
% 
%   ans =
%    3     4
% 
% Arrays
% 
%  All variable in MATLAB are treated as arrays. A scalar is a one by one array.
%  Initialization can fill an array with either zeros or ones.
% 
% ¯Z = zeros(1,5)         % Initialize a row vector with zeros.
% 
%   Z =
%     0     0     0     0     0
% 
% ¯W = zeros(3,1)         % Initialize a column vector with zeros.
% 
%   W =
%     0
%     0
%     0
% 
% ¯M = ones(2,4)          % Initialize a matrix with ones.
% 
%   M =
%     1     1     1     1
%     1     1     1     1
% 
% ¯size(M)
% 
%   ans =
%     2     4
% 
% Vectors
% 
%   Vectors can be entered and stored as a matrix with one row or one column
% 
% ¯V = [1,2,3,4]
% 
%   V =
%     1     2     3     4
% 
% 
% ¯length(V)
% 
%   ans =
%     4
% 
% ¯sum(V)         % The sum of the elements of V.
% 
%   ans =
%     10
% 
% ¯mean(V)        % The mean of the elements of V.
% 
%   ans =
%     2.5000
% 
% 
% Transpose 
% 
% ¯W =  [1,
%      2,
%      3,
%      4]
% 
%   W =
%        1
%        2
%        3
%        4
% ¯W'
% 
%   ans =
%     1     2     3     4
% 
% Colon
% 
%   Used for creating a list and it is used for selecting part(s) of a list.
% 
% ¯X = 1:20;          % A list of integers from 1 to 20.
% ¯Y = X.^2;          % A list of their squares.
% ¯Y(10:20)           % Display only the last 11 entries.
% 
%   ans =
%     100  121  144  169  196  225  256  289  324  361  400
% 
% ¯A = [1  2  3  4,
%       5  6  7  8,
%       9 10 11 12];
% 
% ¯A(1,3)             % Select one element in a matrix.
% 
%   ans =
%     3
% 
% ¯A(2:3, 1:2)        % Select a sub-matrix.
% 
%   ans =
%     5     6
%     9    10
% 
% 
% Arithmetic Operations
% 
%   +    Addition
%   -    Subtraction
%   *    Multiplication
%   /    Division
%   ^    Power
% 
% 
% Arithmetic Operations for arrays (also useful for functions to be plotted)
% 
%   .+  Element-wise addition
%   .-  Element-wise subtraction
%   .*  Element-wise multiplication
%   ./  Element-wise division  or  use  (  ).^(-1)
%   .^  Element-wise power
% 
% ¯A = [1 2,
%       3 4];
% ¯A^2                 % Square a matrix.
% 
%   ans =
%      7    10
%     15    22
% 
% ¯A.^2                % Square each element in a matrix.
%   ans =
%     1     4
%     9    16
% 
% ¯C = inv(A)          % Find the inverse of a matrix.
%   C =
%     -2.0000    1.0000
%      1.5000   -0.5000
% 
% ¯A*C                 % Verify that C is the inverse.
%   ans =
%     1.0000         0
%     0.0000    1.0000
% 
% Relational Operators
% 
%   ==   Equal to
%   ~=   Not equal to
%   <    Less than
%   >    Greater than
%   <=   Less than or equal to
%   >=   Greater than or equal to
% 
% Logical Operators
% 
%   ~    Not  Complement
%   &    And  True if both operands are true
%   |    Or  True if either (or both) operands are true
% 
% Boolean Values
% 
%   1    True
%   0    False
% 
% IF (Block) Control Statement
% 
% Performs the series of {<executable-statement>} following it 
% or transfers control to an ELSEIF, ELSE, or ENDIF statement, 
% depending on (<logical-expression>).
% 
% if (<logical-expression#1>),
%   {<executable-statements>}
% elseif (<logical-expression#2>),
%   {<executable-statements>}
% end
% 
% 
% if (<logical-expression#1>),
%   {<executable-statements>}
% elseif (<logical-expression#2>),
%   {<executable-statements>}
%         
% else
%   {<executable-statements>}
% end
% 
% 
% Break
% 
% if n==3, break, end
% 
% for k=1:100,
%   x=sqrt(k);
%   if x>5, break, end
% end
% 
% 
% For loop
% 
% sum1 = 0;
%   for k = 1:1:10000,
%   sum1 = sum1 + 1/k;
% end
% sum1
% 
%   sum1 =
%       9.78760603604434
% 
% sum2 = 0;
% for k = 10000:-1:1,
%   sum2 = sum2 + 1/k;
% end
% sum2
% 
%   sum2 =
%       9.78760603604439
% 
% for j = 1:5,
%   for k = 1:5,
%     A(j,k) = 1/(j+k-1);
%   end
% end
% A                        % The 5 by 5 Hilbert matrix A will be displayed.
% 
% 
% While (Block) Control Statement
% 
% m = 10;
% k = 0;
% while k<=m
%   x = k/10;
%   disp([x, x^2, x^3]);   % A table of values will be printed.
%   k = k+1;
% end
% 
% 
% Pause statement
% 
%   pause
% 
% Mathematical functions
% 
%   cos(x)    cosine (radians)
%   sin(x)    sine (radians)
%   tan(x)    tangent (radians)
%   exp(x)    exponential  exp(x)
%   acos(x)   inverse cosine (radians)
%   asin(x)   inverse sine (radians)
%   atan(x)   inverse tangent (radians)
%   log(x)    natural logarithm base  e
%   log10(x)  common logarithm base  10
%   sqrt(x)   square root
%   abs(x)    absolute value
%   round(x)  round to nearest integer
%   fix(x)    round towards zero
%   floor(x)  round towards -Œ
%   ceil(x)   round towards +Œ
%   sign(x)   signum function
%   cosh(x)   hyperbolic cosine
%   sinh(x)   hyperbolic sine
%   tanh(x)   hyperbolic tangent
%   acosh(x)  inverse hyperbolic cosine
%   asinh(x)  inverse hyperbolic sine
%   atanh(x)  inverse hyperbolic tangent
%   real(z)   real part of complex number z
%   imag(z)   imaginary part of complex number z
%   conj(z)   complex conjugate of the complex number z
%   angle(z)  argument of complex number z
%   rem(p,q)  remainder when p is divided by q
% 
% 
% Data Analysis
% 
%   max       maximum value
%   min       minimum value
%   mean      mean value
%   median    median value
%   std       standard deviation
%   sort      sorting
%   sum       sum the elements
%   prod      form product of the elements
%   cumsum    cumulative sum of elements
%   cumprod   cumulative product of elements
%   diff      approximate derivatives (differences)
%   hist      histogram
%   corrcoef  correlation coefficients
%   cov       covariance matrix
% 
% 
% Graphics
% 
%   Store the following script in the M-file;  sketch.m 
% 
% X = 0:pi/8:pi;
% Y = sin(X);
% axis([-0.2 3.2 -0.1 1.1]);
% plot(X,Y);
% hold on;
% plot([-0.2 3.2],[0,0],[0,0],[-0.1 1.1]);
% xlabel('x');
% ylabel('y');
% title('Graph of y = sin(x)');
% grid;
% axis;
% hold off;
% 
%   Issue the command  sketch  and obtain the graph
% 
% 
% 
% Remark. Data used by the plot command must be two vectors of equal length.
%   
%   X =
%     0  0.3927 0.7854 1.1781 1.5708 1.9635 2.3562 2.7489  3.1416
%   Y =
%     0  0.3827 0.7071 0.9239 1.0000 0.9239 0.7071 0.3827  0.0000
% 
% 
% Polynomial functions
% 
%   The coefficients of a polynomial are stored as a coefficient list.
% 
%   ¯C = [1 -3 2]
%   C =
%     1    -3     2
% 
%   If  C  is a vector whose elements are the coefficients  of a polynomial, 
%   then polyval(C,x)  is the value of the polynomial evaluated at x.  
% 
%   ¯for x=0:0.5:3,
%     disp([x,polyval(C,x)]),
%   end
% 
%   0           2
%   0.5000      0.7500
%   1           0
%   1.5000     -0.2500
%   2           0
%   2.5000      0.7500
%   3           2
% 
% 
% Finding the roots of a polynomial.  Let  p(x)  =  x5 - 10x4 + 35x3 - 50x2 + 24
% 
% ¯C = [1  -10  35  -50  24]
% C =
%      1   -10    35   -50   24
% 
% ¯roots(C)
% ans =
%     4.0000
%     3.0000
%     2.0000
%     1.0000
% 
% Other operations with polynomials are:
% 
%   conv     polynomial multiplication
%   polyfit  polynomial curve fitting
% 
% 
%   Graph the polynomial  p(x)  =  x5 - 10x4 + 35x3 - 50x2 + 24
% 
%   Store the following script in the M-file;  sketch.m 
% 
% C = [1  -10  35  -50  24];
% X=-0.2:0.1:4.2;
% Y=polyval(C,X);
% axis([-0.2 4.2 -2.3 4.3]);
% plot(X,Y);
% hold on;
% plot([-0.2 4.2],[0,0],[0,0],[-2.3 4.3]);
% xlabel('x');
% ylabel('y');
% title('Graph of a polynomial.');
% grid;
% axis;
% hold off;
% 
%   Issue the command  sketch  and obtain the graph.
% 
% 
% 
%   For function of the independent variable x one can define f
%   as a text string:
% 
% f = 'sin(x)'
% 
%   Then use the fplot command
% 
% fplot(f,[0 10]);
% 
% 
% 
% 3-dimensional graphs
% 
%   Store the following script in the M-file;  sketch.m 
% 
% [X Y] = meshdom(-1:0.1:1, -1:0.1:1);
% Z = X.^2 - Y.^2;
% mesh(Z);
% title('Graph of z = x^2 - y^2');
% 
%   Issue the command  sketch  and obtain the graph.
% 
% 
% More commands for matrices
% 
%   zeros    zero matrix
%   ones     matrix of ones
%   rand     random elements
%   eye      identity matrix
%   meshdom  domain for mesh plots
%   rot90    rotation of matrix elements
%   fliplr   flip matrix left-to-right
%   flipud   flip matrix up-and-down
%   diag     extract or create diagonal
%   tril     lower triangular part
%   triu     upper triangular part
%   '        transpose
% 
% 
% Solution of a linear system  AX = B
% 
% ¯A = [1  2  3  4,    % Enter the matrix A.
%       2  5  1  1,
%       3  1  2  1,
%       4  1  1  3];
% 
%   A = [1  2  3  4,
%        2  5  1  1,
%        3  1  2  1,
%        4  1  1  3];
% 
% ¯B = [2 1 3 4]'      % Enter the vector B.
% 
%   B =
%     2
%     1
%     3
%     4
% 
% ¯X = A\B             % Solve the linear system AX = B.
% 
%   X =
%      0.8333
%     -0.2273
%      0.2576
%      0.2121
% 
% ¯A*X                 % Verify that X is the solution.
% 
%   ans =
%     2
%     1
%     3
%     4
% 
% 
% Eigenvectors and eigenvalues
% 
% ¯A = [1  2  3  4,    % Enter the matrix A.
%       2  5  1  1,
%       3  1  2  1,
%       4  1  1  3];
% 
% ¯[V E] = eig(A)      % V is a matrix of eigenvectors.
%                      % E is a diagonal matrix of eigenvalues.
% 
%   V =
%     -0.2397   -0.0481   -0.8000    0.5479
%      0.8438    0.0977    0.0966    0.5187
%     -0.1880   -0.8201    0.3733    0.3908
%     -0.4418    0.5618    0.4597    0.5272
% 
%   E =
%     3.6856         0         0         0
%          0    1.3717         0         0
%          0         0   -2.9395         0
%          0         0         0    8.8822
% 
