function varargout=mmpm2p(P,i)
%MMPM2P Polynomial Matrix to Polynomial Conversion. (MM)
% MMPM2P(P,i) extracts the polynomial in the (i)th row of
% the polynomial matrix P.
%
% [P1,P2,P3,...] = MMPM2P(P,I) extracts the polynomials
% in the rows indexed by the array I. P1=P(I(1),:), etc.
%
% [P1,P2,P3,...] = MMPM2P(P) extracts all polynomials from P.
%
% See also MMP2PM, MMPMDER, MMPMFIT, MMPMINT, MMPMSEL, MMPMEVAL

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 7/7/96, revised 9/9/96, v5: 1/14/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

r=size(P,1);
if nargin==1, i=1:r; end
if any(i<1) | any(i>r)
	error('Index I Contains Out of Range Values.')
end

i=i(:)';
for j=1:min(length(i),nargout)
	varargout{j}=mmpsim(P(i(j),:));
end
