function y = mat2strh(x,k)            %last updated 11/11/94
%MAT2STR   Converts a numeric matrix X to a matrix of strings
%          with k blanks between entries. If argument k is
%          omitted one blank is used.
%
%    Use in the form    --->  mat2strh(X,k)  <---
%                 or    --->  mat2strh(X)    <---
%
%By: David R. Hill, Math. Dept., Temple University,
%    Philadelphia, Pa. 19122
if nargin==1
   k=1;
end
if k<0 | k~=fix(k)
   disp('>>>>>> Error: Second argument must be a positive integer.')
   return
end
[m,n]=size(x);
maxl=1;
for i=1:m
   for j=1:n
      l=length(num2str(x(i,j)));
      if l>maxl,maxl=l;end
   end
end
y=[];
for i = 1:m
   temp=[];
   for j = 1:n
      st=num2str(x(i,j));l=length(st);
      if l==maxl
         temp=[temp blanks(k) st];
      else
         temp=[temp blanks(k) blanks(maxl-l) st];
      end
   end
   y = [y;temp];
end
