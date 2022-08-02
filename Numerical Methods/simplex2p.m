
function  simplex2p(type, c, A, rel, b)

% The Two-Phase Method for solving the LP problem

%                     min(or max) z = c*x
%                     Subject to  Ax rel b
%                                   x >= 0

% The input parameter type holds information about type of the LP 
% problem to be solved. For the minimization problem type = 'min' 
% and for the maximization problem type = 'max'.
% The input parameter rel is a string holding the relation signs.
% For instance, if rel = '<=>', then the constraint system consists
% of one inequality <=, one equation, and one inequality >=.

if (type == 'min')
   mm = 0;
else
   mm = 1;
   c = -c;
end
b = b(:);
c = c(:)';
[m, n] = size(A);
n1 = n;
les = 0;
neq = 0;
red = 0;
if length(c) < n
   c = [c zeros(1,n-length(c))];
end
for i=1:m
   if(rel(i) == '<')
      A = [A vr(m,i)];
      les = les + 1;
   elseif(rel(i) == '>')
      A = [A -vr(m,i)];
   else
      neq = neq + 1;
   end
end
ncol = length(A);
if les == m
   c = [c zeros(1,ncol-length(c))];
   A = [A;c];
   A = [A [b;0]];
   [subs, A, z, p1] = loop(A, n1+1:ncol, mm, 1, 1);
   disp('                    End of Phase 1')
   disp('          *********************************')
else
   A = [A eye(m) b];
   if m > 1
      w = -sum(A(1:m,1:ncol));
   else
      w = -A(1,1:ncol);
   end
   c = [c zeros(1,length(A)-length(c))];
   A = [A;c];
   A = [A;[w zeros(1,m) -sum(b)]];
   subs = ncol+1:ncol+m;
   av = subs;
   [subs, A, z, p1] = loop(A, subs, mm, 2, 1);
   if p1 == 'y'
         disp('                    End of Phase 1')
         disp('          *********************************')
      end
   nc = ncol + m + 1;
   x = zeros(nc-1,1);
   x(subs) = A(1:m,nc);
   xa = x(av);
   com = intersect(subs,av);
   if (any(xa) ~= 0)
      disp(sprintf('\n\n                    Empty feasible region\n'))
      return
   else
      if ~isempty(com)
         red = 1;
      end
   end
   A = A(1:m+1,1:nc);
   A =[A(1:m+1,1:ncol) A(1:m+1,nc)];
   [subs, A, z, p1] = loop(A, subs, mm, 1, 2);
   if p1 == 'y'
         disp('                    End of Phase 2')
         disp('          *********************************')
      end
end
if (z == inf | z == -inf)
   return
end
[m, n] = size(A);
x = zeros(n,1);
x(subs) = A(1:m-1,n);
x = x(1:n1);
if mm == 0
   z = -A(m,n);
else
   z = A(m,n);
end
disp(sprintf('\n\n           Problem has a finite optimal solution\n'))
disp(sprintf('\n Values of the legitimate variables:\n')) 
for i=1:n1
   disp(sprintf(' x(%d)= %f ',i,x(i)))
end
disp(sprintf('\n Objective value at the optimal point:\n'))
disp(sprintf(' z= %f',z))
t = find(A(m,1:n-1) == 0);
if length(t) > m-1
   str = 'Problem has infinitely many solutions';
   msgbox(str,'Warning Window','warn')
end
if red == 1
   disp(sprintf('\n Constraint system is redundant\n\n'))
end

function [subs, A, z, p1]= loop(A, subs, mm, k, ph)

% Main loop of the simplex primal algorithm.
% Bland's rule to prevente cycling is used.

tbn = 0;
str1 = 'Would you like to monitor the progress of Phase 1?';
str2 = 'Would you like to monitor the progress of Phase 2?';
if ph == 1
   str = str1;
else
   str = str2;
end
question_ans = questdlg(str,'Make a choice Window','Yes','No','No');
if strcmp(question_ans,'Yes')
   p1 = 'y';
end
if p1 == 'y' & ph == 1
   disp(sprintf('\n\n                     Initial tableau'))
   A
   disp(sprintf(' Press any key to continue ...\n\n'))
   pause
end
if p1 == 'y' & ph == 2
   tbn = 1;
   disp(sprintf('\n\n                     Tableau %g',tbn))
   A
   disp(sprintf(' Press any key to continue ...\n\n'))
   pause
end
[m, n] = size(A);
[mi, col] = Br(A(m,1:n-1));
while ~isempty(mi) & mi < 0 & abs(mi) > eps
   t = A(1:m-k,col);
   if all(t <= 0)
      if mm == 0
         z = -inf;
      else
         z = inf;
      end
      disp(sprintf('\n        Unbounded optimal solution with z= %s\n',z))
      return
   end
   [row, small] = MRT(A(1:m-k,n),A(1:m-k,col));
   if ~isempty(row)
      if abs(small) <= 100*eps & k == 1
         [s,col] = Br(A(m,1:n-1));
      end
      if p1 == 'y'
         disp(sprintf('          pivot row-> %g   pivot column-> %g',...
            row,col))
      end
      A(row,:)= A(row,:)/A(row,col);
      subs(row) = col;
      for i = 1:m
         if i ~= row
            A(i,:)= A(i,:)-A(i,col)*A(row,:);
         end
      end
      [mi, col] = Br(A(m,1:n-1));
   end
   tbn = tbn + 1;
   if p1 == 'y'
      disp(sprintf('\n\n                    Tableau %g',tbn))
      A
      disp(sprintf(' Press any key to continue ...\n\n'))
      pause
   end
end
z = A(m,n);








