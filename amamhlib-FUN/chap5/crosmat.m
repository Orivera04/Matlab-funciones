function c=crosmat(a,b)
%
% c=crosmat(a,b)
% ~~~~~~~~~~~~~~
% This function computes the vector cross
% product for vectors stored in the rows
% of matrices a and b, and returns the 
% results in the rows of c.
%
% User m functions called: none
%----------------------------------------------

c=[a(:,2).*b(:,3)-a(:,3).*b(:,2),...
   a(:,3).*b(:,1)-a(:,1).*b(:,3),...
   a(:,1).*b(:,2)-a(:,2).*b(:,1)];