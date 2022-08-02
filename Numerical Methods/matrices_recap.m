%% Matrices Chapter Recap
% This is an executable program that illustrates the statements
% introduced in the Matrices Chapter of "Experiments in MATLAB".
% You can access it with
%
%    matrices_recap
%    edit matrices_recap
%    publish matrices_recap
%
% Related EXM Programs
%
%    wiggle
%    dot2dot
%    house
%    hand

%% Vectors and matrices
    x = [2; 4]
    A = [4 -3; -2 1]
    A*x
    A'*A
    A*A'
    
%% Random matrices
    R = 2*rand(2,2)-1
    
%% Build a house
    X = house
    dot2dot(X)
    
%% Rotations
    theta = pi/6   % radians
    G = [cos(theta) -sin(theta); sin(theta) cos(theta)]
    theta = 30  % degrees
    G = [cosd(theta) -sind(theta); sind(theta) cosd(theta)]
    subplot(1,2,1)
    dot2dot(G*X)
    subplot(1,2,2)
    dot2dot(G'*X)

%% More on Vectors and Matrices

% Vectors are created with square brackets.

   v = [0 1/4 1/2 3/4 1]
   
% Rows of a matrix are separated by semicolons or new lines.
   
   A = [8 1 6; 3 5 7; 4 9 2]
   
   A = [8 1 6
        3 5 7
        4 9 2]
    
%% Creating matrices
   Z = zeros(3,4)
   E = ones(4,3)
   I = eye(4,4)
   M = magic(3)
   R = rand(2,4)
   [K,J] = ndgrid(1:4)
       
%% Colons and semicolons

% A colon creates uniformally spaced vectors.

   v = 0:0.25:1
   n = 10
   y = 1:n
 
% A semicolon at the end of a line suppresses output.

   n = 1000;
   y = 1:n;
   

%% Matrix arithmetic.
% Addition and subtraction, + and -, are element-by-element.
% Multiplication, *, follows the rules of linear algebra.
% Power, ^, is repeated matrix multiplication.

   KJ = K*J
   JK = J*K

%% Array arithmetic
% Element-by-element operations are denoted by 
% + , - , .* , ./ , .\ and .^ .

   K.*J
   v.^2

%% Transpose
% An apostrophe denotes the transpose of a real array
% and the complex conjugate transpose of a complex array.

   v = v'
   inner_prod = v'*v
   outer_prod = v*v'
   Z = [1 2; 3+4i 5]'
   Z = [1 2; 3+4i 5].'
