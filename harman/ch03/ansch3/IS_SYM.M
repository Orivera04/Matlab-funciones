function truth=is_sym(A)
%  Determine if a matrix is symmetric)
%  CALL: truth=is_sym(A)
%   truth=1 (true) if A is symmetrical, truth=0 if not
%  Calls function is_sqr
truth=1;    % assume true
if is_sqr(A)
 s=size(A);
 if s > 1
  for row = 2:s
   for col = 1:row-1
     if A(row,col) ~=A(col,row)
      truth=0;
     end
    end
  end
 end
else
 truth=0;
end 