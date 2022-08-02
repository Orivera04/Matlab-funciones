
function varargout = dsimplex(type, c, A, b)

% The Dual Simplex Algorithm for solving the LP problem

%                      min (max) z = c*x
%                    Subject to  Ax >= b
%                                 x >= 0
% 

if type == 'min'
   mm = 0;
else
   mm = 1;
   c = -c;
end
str = 'Would you like to monitor the progress of computations?';
A = -A;
b = -b(:);
c = c(:)';
[m, n] = size(A);
A = [A eye(m) b];
A = [A;[c zeros(1,m+1)]];
question_ans = questdlg(str,'Make a choice Window','Yes','No','No');
if strcmp(question_ans,'Yes')
   p1 = 'y';
else
   p1 = 'n';
end
if p1 == 'y'
   disp(sprintf('\n\n                     Initial tableau'))
   A
   disp(sprintf(' Press any key to continue ...\n\n'))
   pause
end
subs = n+1:n+m;
[bmin, row] = Br(b);
tbn = 0;
while ~isempty(bmin) & bmin < 0 & abs(bmin) > eps
   if A(row,1:m+n) >= 0
      disp(sprintf('\n\n               Empty feasible region\n'))
      varargout(1)={subs(:)};
      varargout(2)={A};
      varargout(3) = {zeros(n,1)};
      varargout(4) = {0};
      return
   end
   col = MRTD(A(m+1,1:m+n),A(row,1:m+n));
   if p1 == 'y'
      disp(sprintf('          pivot row-> %g   pivot column-> %g',...
            row,col))
   end
   subs(row) = col;
   A(row,:)= A(row,:)/A(row,col);
      for i = 1:m+1
      if i ~= row
         A(i,:)= A(i,:)-A(i,col)*A(row,:);
      end
   end
   tbn = tbn + 1;
   if p1 == 'y'
      disp(sprintf('\n\n                    Tableau %g',tbn))
      A
      disp(sprintf(' Press any key to continue ...\n\n'))
      pause
   end
   [bmin, row] = Br(A(1:m,m+n+1));
end
x = zeros(m+n,1);
x(subs) = A(1:m,m+n+1);
x = x(1:n);
if mm == 0
   z = -A(m+1,m+n+1);
else
   z = A(m+1,m+n+1);
end
disp(sprintf('\n\n           Problem has a finite optimal solution\n\n'))
disp(sprintf('\n Values of the legitimate variables:\n')) 
for i=1:n
   disp(sprintf(' x(%d)= %f ',i,x(i)))
end
disp(sprintf('\n Objective value at the optimal point:\n'))
disp(sprintf(' z= %f',z))
disp(sprintf('\n Indices of basic variables in the final tableau:'))
varargout(1)={subs(:)};
varargout(2)={A};
varargout(3) = {x};
varargout(4) = {z};


