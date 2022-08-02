function i=mmfind(x,A)
%MMFIND Find Indices of a Vector in a Matrix. (MM)
% MMFIND(x,A) returns the indices of the matrix A where the vector x appears.
% If x is a row, MMFIND(x,A) returns the row indices of A where x appears.
% If x is a column, MMFIND(x,A) returns the column indices of A where x appears.
%
% NaNs in x designate rows or columns where any value is a valid match.
% The length of x must equal the appropriate dimension of A.
% If no matches are found an empty array is returned.

% D.C. Hanselman, University of Maine, Orono ME,  04469
% 2/26/98
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if ndims(x)~=2|min(size(x))~=1, error('x Must be a Vector.'), end
if ndims(A)~=2, error('A Must be a 2-D Array'), end
[rx,cx]=size(x);
[rA,cA]=size(A);
if rx==1
   if cx~=cA, error('No. Columns in x Must be Equal to Columns in A.'), end
   n=find(isnan(x));
   x(n)=[]; A(:,n)=[]; % throw out don't care columns
   i=find(all(A==x(ones(rA,1),:),2));
elseif cx==1
   if rx~=rA, error('No. Rows in x Must be Equal to Rows in A.'), end
   n=find(isnan(x));
   x(n)=[]; A(n,:)=[]; % throw out don't care rows
   i=find(all(A==x(:,ones(cA,1)),1));
end
