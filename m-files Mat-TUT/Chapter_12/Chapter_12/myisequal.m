function myflag = myisequal(mata,matb)
% myisequal receives two matrices and returns
% logical 1 if they are equal or 0 if not
% Format: myisequal(matrix1, matrix2)

% Assume true until & unless found to be false
myflag = logical(1);
[r c] = size(mata);
if all(size(mata) ~= size(matb))
    myflag = logical(0);
else
   for i=1:r
      for j = 1:c
         if mata(i,j) ~= matb(i,j)
             myflag = logical(0);
         end
      end
   end
end
end
