function vent=symenth(A,r,c)               %last updated 1/11/95
%SYMENTH  Find the (r,c) entry of symbolic matrix A and return
%         it in vent.
%
%         Use in the form  ==> vent=symenth(A,r,c)  <==
%
%         Utility findcomh is required.
%
%By: David R. Hill, Mathematics Dept., Temple Univ.
%       Philadelphia, PA. 19122    Email: hill@math.temple.edu
v=findcomh(A);k=length(v);numc=k+1;  %numc=# of columns in A
[m,n]=size(A);
if r>m
   disp('Row number out of range')
   return
end
if c>numc
   disp('Column number out of range.')
   return
end
if c==1
   place=2:v(1)-1;
end
if c==numc
   place=(v(k)+1:n-1);
end
if c>1 & c<numc
   place=(v(c-1)+1:v(c)-1);
end
vent=A(r,place);
