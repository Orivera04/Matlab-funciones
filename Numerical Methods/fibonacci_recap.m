%% Fibonacci Chapter Recap 
% This is an executable program that illustrates the statements
% introduced in the Fibonacci Chapter of "Experiments in MATLAB".
% You can access it with
%
%    fibonacci_recap
%    edit fibonacci_recap
%    publish fibonacci_recap

%% Related EXM Programs
%
%    fibonacci.m
%    fibnum.m
%    rabbits.m

%% Functions
% Save in file sqrt1px.m
%
%    function y = sqrt1px(x)
%    % SQRT1PX  Sample function.
%    % Usage: y = sqrt1px(x)
%
%       y = sqrt(1+x);

%% Create vector
   n = 8;
   f = zeros(1,n)
   t = 1:n
   s = [1 2 3 5 8 13 21 34]

%% Subscripts
   f(1) = 1;
   f(2) = 2;
   for k = 3:n
      f(k) = f(k-1) + f(k-2);
   end
   f

%% Recursion
%    function f = fibnum(n)
%    if n <= 1
%       f = 1;
%    else
%       f = fibnum(n-1) + fibnum(n-2);
%    end

%% Tic and Toc
   format short
   tic
      fibnum(24);
   toc

%% Element-by-element array operations
   f = fibonacci(5)'
   fpf = f+f
   ftf = f.*f
   ff = f.^2
   ffdf = ff./f
   cosfpi = cos(f*pi)
   even = (mod(f,2) == 0)
   format rat
   r = f(2:5)./f(1:4)

%% Strings
   hello_world

