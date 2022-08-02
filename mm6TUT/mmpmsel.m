function pp=mmpmsel(P,i)
%MMPMSEL Select Subset of a Polynomial Matrix. (MM)
% MMPMSEL(P,I) returns a polynomial matrix by selecting 
% those indexed by the vector I.
% Leading zero columns are deleted from the selection.
% Examples:
% MMPMSEL(P,[1 1 1]) duplicates the first polynomial 3 times.
% MMPMSEL(P,[3 2]) selects the third and second polynomial
% placing the third in the first row of the result.
% MMPMSEL(P) returns P with leading zero columns deleted.
%
% See also MMP2PM, MMPM2P, MMPMDER, MMPMFIT, MMPMINT, MMPMEVAL.

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 7/16/96, v5: 1/14/97, 3/30/98
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

[rp,cp]=size(P);
if nargin==1, i=1:rp; end
if any(i<1|i>rp), error('I Contains Indices Outside the Rows of P.'), end
pp=P(i,:);  % keep only selected polynomials
c=find(any(abs(pp)>=100*eps,1));
pp=pp(:,c(1):cp);
