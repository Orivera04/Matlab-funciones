function v = findcomh(A)                         %last updated 1/11/95
%findcomh  Finding the location of commas in a symbolic matrix.
%          Upon return v contains the column numbers that contain
%          commas. This is a utility.
%
%         Use in the form  ==>  v = findcomh(A)  <==
%
%  By: David R. Hill, Mathematics Dept., Temple Univ.
%      Philadelphia, PA. 19122    Email: hill@math.temple.edu
[m,n]=size(A);
v=[];
for k=1:n           %only first row is searched since commas are
   if A(1,k)==',';  %aligned column-wise
      v=[v k];
   end
end
