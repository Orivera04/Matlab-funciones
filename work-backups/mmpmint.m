function pp=mmpmint(P,c,i)
%MMPMINT Polynomial Matrix Integration. (MM)
% MMPMINT(P,C) returns a polynomial matrix containing the
% integrals of the polynomials in the polynomial matrix P.
% C contains the constants of integration:
% If C is scalar, it is used for every polynomial.
% If C is a vector, C(i) is used for the (i)th polynomial, P(i,:).
% By default C is zero.
%
% MMPMINT(P,C,I) returns a polynomial matrix containing the
% integrals of the polynomials in P indexed by the vector I.
% The (j)th polynomial in the result is the integral of P(I(j),:).
%
% See also MMP2PM, MMPM2P, MMPMDER, MMPMFIT, MMPMSEL, MMPMEVAL.

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 7/7/96, revised 8/16/96, v5: 1/14/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

[rp,cp]=size(P);
if nargin<2 | isempty(c), c=0; i=1:rp; end
clen=length(c);
if nargin==2, i=1:rp; end
ilen=length(i);
if any(i<1|i>rp)
	error('I Contains Indices Outside the Rows of P.')
end
P=P(i,:);  % keep only selected polynomials
if clen==1
	c=c(ones(ilen,1),1);
elseif clen~=ilen
	error('Incorrect Number of Integration Constants.')
end
N=repmat(cp:-1:1,ilen,1);
pp=[P./N(ones(ilen,1),:) c(:)];
pp=mmpmsel(pp); % strip common leading zeros
