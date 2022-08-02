
function addconstr(type, A, subs, a, rel, d)

% Adding a constraint to the final tableau A.
% The input parameter subs holds indices of basic
% variables associated with tableau A. Parameters 
% lhs, rel, and rhs hold information about a costraint
% to be added: 
% a - coefficients of legitimate variables
% rel - string describing the inequality sign; 
% for instance, rel = '<' stands for <=.
% d - constant term of the constraint to be added.
% Parameter type is a string that describes type of
% the optimization problem. For the minimization problems
% type = 'min' and for the maximization problems type = 'max'.


clc
str = 'Would you like to monitor the progress of computations?';
question_ans = questdlg(str,'Make a choice Window','Yes','No','No');
if strcmp(question_ans,'Yes')
   p1 = 'y';
else
   p1 = 'n';
end
[m, n] = size(A);
a = a(:)';
lc = length(a);
if lc < n-1
   a = [a zeros(1,n-lc-1)];
end
if type == 'min'
   ty = -1;
else
   ty = 1;
end
x = zeros(n-1,1);
x(subs) = A(1:m-1,n);
dp = a*x;
if (dp <= d & rel == '<') | (dp >= d & rel == '>')
   disp(sprintf('\n\n             Problem has a finite optimal solution\n'))
   disp(sprintf('\n Values of the legitimate variables:\n')) 
   for i=1:n-1
      disp(sprintf(' x(%d)= %f ',i,x(i)))
   end
   disp(sprintf('\n Objective value at the optimal point:\n'))
   disp(sprintf(' z= %f',ty*A(m,n)))
   return
end
B = [A(:,1:n-1) zeros(m,1) A(:,n)];
if rel == '<'
   a = [a 1 d];
else
   a = [a -1 d];
end
for i=1:m-1
   a = a - a(subs(i))*B(i,:);
end
if a(end) > 0
   a = -a;
end
A = [B(1:m-1,:);a;B(m,:)];
if p1 == 'y'
   disp(sprintf('\n\n                     Initial tableau'))
   A
   disp(sprintf(' Press any key to continue ...\n\n'))
   pause
end
[bmin, row] = Br(A(1:m,end));
tbn = 0;
while ~isempty(bmin) & bmin < 0 & abs(bmin) > eps
   if A(row,1:n) >= 0
      disp(sprintf('\n\n               Empty feasible region\n'))
      return
   end
   col = MRTD(A(m+1,1:n),A(row,1:n));
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
  [bmin, row] = Br(A(1:m,end));
end
x = zeros(n+1,1);
x(subs) = A(1:m,end);
x = x(1:n);
disp(sprintf('\n\n           Problem has a finite optimal solution\n\n'))
disp(sprintf('\n Values of the legitimate variables:\n')) 
for i=1:n
   disp(sprintf(' x(%d)= %f ',i,x(i)))
end
disp(sprintf('\n Objective value at the optimal point:\n'))
disp(sprintf(' z= %f',ty*A(m+1,n+1)))





   
