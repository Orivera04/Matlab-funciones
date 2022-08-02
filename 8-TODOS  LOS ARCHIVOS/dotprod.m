function v=dotprod(x,y)                         %last updated 7/8/94
%DOTPROD   The dot product of two n-vectors x and y is computed.
%          The vectors can be either rows, columns, or matrices
%          of the same size. For complex vectors the dot product
%          of x and y is compted as the conjugate transpose of 
%          the first times the second.
%
%      Use in the form  --->  dotprod(x,y)  <---
%
%  By: David R. Hill, Math Dept, Temple University,
%      Philadelphia, Pa. 19122   Email: hill@math.temple.edu

%Note: this routine varies from MATLAB's dot command in
%      how complex vectors are handled and how rectangular
%      matrices are handled.
%
blk=setstr(219);
er='Error in dotprod: arguments not of same size.';
[mx nx]=size(x);[my ny]=size(y);
if (mx*nx ~= max([mx nx])) | (my*ny ~= max([my ny]))
   %check if one is a row and one a column
   % if not check for same size
   if (mx == my) & (nx == ny)
      %things are same size but not rows or columns
   else
      disp([blk blk blk er])
      return
   end
end
x=x(:);y=y(:);
v=x'*y;

