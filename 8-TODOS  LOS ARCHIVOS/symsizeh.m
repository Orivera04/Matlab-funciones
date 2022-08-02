function [r,c]=symsizeh(A)               %last updated 1/11/95
%SYMSIZEH  Determine the size of a symbolic matrix in terms
%          of the number of rows r and number of columns of
%          entries c. (c is not the number of symbolic entries
%          in a row.)
%
%          Use in the form  ==> [r,c]=symsize(A)  <==
%                       or  ==>       symsize(A)  <==
%
%          Requires utility findcomh.
%
%  By: David R. Hill, Mathematics Dept., Temple Univ.
%      Philadelphia, PA. 19122    Email: hill@math.temple.edu

[r,n]=size(A);
v=findcomh(A);
c=length(v)+1;
if nargout==0
   r=[r c];
end
