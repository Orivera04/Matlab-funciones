% Delete from this folder !!!

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


