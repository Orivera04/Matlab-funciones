
function[A, subs, x, z] = simplex(type, c, A, b, varargin);

% The simplex algorithm for the LP problem

%                    min(max) z = c*x
%                 Subject to: Ax <= b
%                              x >= 0

% Vector b must be nonnegative.
% For the minimization problems the string type = 'min', 
% otherwise type = 'max'.
% The fifth input parameter is optional. If it is set to 'y',
% then the initial and final tableaux are displayed to the
% screen.
% Output parameters:
% A - final tableau of the simplex method
% subs - indices of the basic variables in the final tableau
% x - optimal solution
% z - value of the objective function at x.

if any(b < 0)
   error(' Right hand sides of the constraint set must be nonnegative.')
end
if type == 'min'
   tp = -1;
else
   tp = 1;
   c = -c;
end
[m, n] = size(A);
A = [A eye(m)];
b = b(:);
c = c(:)';
A = [A b];
d = [c zeros(1,m+1)];
A = [A;d];
if nargin == 5
   disp(sprintf('     ________________________________________________'))
   disp(sprintf('\n              Tableaux of the Simplex Algorithm'))
   disp(sprintf('     ________________________________________________'))
   disp(sprintf('\n                  Initial tableau\n'))
   A
   disp(sprintf(' Press any key to continue ...\n\n'))
   pause
end
[mi, col] = Br(A(m+1,1:m+n));
subs = n+1:m+n;
while ~isempty(mi) & mi < 0 & abs(mi) > eps
   t = A(1:m,col);
   if all(t <= 0)
      disp(sprintf('\n       Problem has unbounded objective function'));
      x = zeros(n,1);
      if tp == -1
         z = -inf;
      else
         z = inf;
      end
      return;
   end
   row = MRT(A(1:m,m+n+1),A(1:m,col));
   if ~isempty(row)
      A(row,:)= A(row,:)/A(row,col);
      subs(row) = col;
      for i = 1:m+1
         if i ~= row
            A(i,:)= A(i,:)-A(i,col)*A(row,:);
         end
      end
   end
   [mi, col] = Br(A(m+1,1:m+n));
end
z = tp*A(m+1,m+n+1);
x = zeros(1,m+n);
x(subs) = A(1:m,m+n+1);
x = x(1:n)';
if nargin == 5
   disp(sprintf('\n\n                  Final tableau'))
   A
   disp(sprintf(' Press any key to continue ...\n'))
   pause
end






