function pp=mmpmder(P,i)
%MMPMDER Polynomial Matrix Derivative. (MM)
% MMPMDER(P) returns a polynomial matrix containing the
% derivatives of the polynomials in the polynomial matrix P.
%
% MMPMDER(P,I) returns a polynomial matrix containing the
% derivatives of the polynomials in P indexed by the vector I.
% The (j)th polynomial in the result is the derivative of P(I(j),:).
%
% See also MMP2PM, MMPM2P, MMPMFIT, MMPMINT, MMPMSEL, MMPMEVAL.

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 7/7/96, revised 7/16/96 8/16/96, v5: 1/14/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

[rp,cp]=size(P);
if nargin==1, i=1:rp; end
ilen=length(i);
if any(i<1|i>rp)
	error('I Contains Indices Outside the Rows of P.')
end
P=P(i,:);  % keep only selected polynomials
if cp==1   % polynomials are constants
	pp=zeros(ilen,c);
else
	N=cp-1:-1:1;
	pp=N(ones(ilen,1),:).*P(:,1:cp-1);
end
pp=mmpmsel(pp); % strip common leading zeros
