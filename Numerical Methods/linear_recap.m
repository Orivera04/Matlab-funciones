%% Linear Equations Chapter Recap
% This is an executable program that illustrates the statements
% introduced in the Linear Equations Chapter of "Experiments in MATLAB".
% You can access it with
%
%    linear_recap
%    edit linear_recap
%    publish linear_recap

%% Backslash
    format bank
    A = [3 12 1; 12 0 2; 0 2 3]
    b = [2.36 5.26 2.77]'
    x = A\b

%% Forward slash
    x = b'/A'

%% Inconsistent singular system
    A(3,:) = [6 0 1]
    A\b

%% Consistent singular system
    b(3) = 2.63

%% One particular solution
    x = A(1:2,1:2)\b(1:2);
    x(3) = 0
    A*x
    
%% Null vector
    z = null(A)
    A*z

%% General solution
    t = rand   % Arbitrary parameter
    y = x + t*z
    A*y
