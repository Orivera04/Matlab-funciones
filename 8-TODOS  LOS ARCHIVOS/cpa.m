
function cpa(type, c, A, b)

% Gomory's cutting plane algorithm for solving  
% the integer programming problem

%                      min(max) z = c*x
%                   Subject to: Ax <= b
%                                x >= 0 and integral


str = 'Would you like to monitor the progress of computations?';
question_ans = questdlg(str,'Make a choice Window','Yes','No','No');
if strcmp(question_ans,'Yes')
   p1 = 'y';
else
   p1 = 'n';
end
if type == 'min'
   tp = -1;
else
   tp = 1;
end
[m,n] = size(A);
nlv = n;
b = b(:);
c = c(:)';
if p1 == 'y'
   [A,subs] = simplex(type,c,A,b,p1);
else
   [A,subs] = simplex(type,c,A,b);
end
[m,n] = size(A);
d = A(1:m-1,end);
pc = fractp(d);
tbn = 0;
if p1 == 'y'
   disp(sprintf('     ________________________________________________'))
   disp(sprintf('\n              Tableaux of the Dual Simplex Method'))
   disp(sprintf('     ________________________________________________'))
end
while norm(pc,'inf') > eps
   [el,i] = max(pc);
   nr = A(i,1:n-1);
   nr = [-fractp(nr) 1 -el];
   B = [A(1:m-1,1:n-1) zeros(m-1,1) A(1:m-1,end)];
   B = [B;nr;[A(m,1:n-1) 0 A(end,end)]];
   A = B;
   [m,n] = size(A);
   [bmin, row] = Br(A(1:m-1,end));
   while ~isempty(bmin) & bmin < 0 & abs(bmin) > eps
      col = MRTD(A(m,1:n-1),A(row,1:n-1));
      if p1 == 'y'
         disp(sprintf('\n          pivot row-> %g   pivot column-> %g',...
               row,col))
         tbn = tbn + 1;
         disp(sprintf('\n                    Tableau %g',tbn))
         A
         disp(sprintf(' Press any key to continue ...\n'))
         pause
      end
      if isempty(col)
         disp(sprintf('\n Algorithm fails to find an optimal solution.'))
         return
      end
      subs(row) = col;
      A(row,:)= A(row,:)./A(row,col);
      for i = 1:m
         if i ~= row
            A(i,:)= A(i,:)-A(i,col)*A(row,:);
         end
      end
     [bmin, row] = Br(A(1:m-1,end));
   end
   d = A(1:m-1,end);
   pc = fractp(d);
end
if p1 == 'y'
   disp(sprintf('\n                  Final tableau'))
   A
   disp(sprintf(' Press any key to continue ...\n'))
   pause
end
x = zeros(n-1,1);
x(subs) = A(1:m-1,end);
x = x(1:nlv);
disp(sprintf('\n           Problem has a finite optimal solution\n\n'))
disp(sprintf('\n Values of the legitimate variables:\n')) 
for i=1:nlv
   disp(sprintf(' x(%d)= %g ',i,x(i)))
end
disp(sprintf('\n Objective value at the optimal point:\n'))
disp(sprintf(' z= %f',tp*A(m,n)))


function y = fractp(x)

% Fractional part y of x, where x is a matrix.

y = zeros(1,length(x));
ind = find(abs(x - round(x)) >= 100*eps);
y(ind) = x(ind) - floor(x(ind));






