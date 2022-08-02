function v=dot(x,y)                         %last updated 6/10/93
%DOT   The dot product of two n-vectors x and y is computed.
%      The vectors can be either rows, columns, or matrices
%      of the same size.
%
%      Use in the form  --->  dot(x,y)  <---
%
%By: David R. Hill, Math. Dept., Temple University
%    Philadelphia, Pa. 19122
blk=setstr(219);
er='Error in dot: arguments not of same size.';
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

