function y=mmrandn(M,V,m,n)
%MMRANDN Normally Distributed Random Arrays. (MM)
% MMRANDN(M,V,N) returns an N-by-N array of normally
% distributed numbers having mean M and variance V.
%
% MMRANDN(M,V,M,N) and MMRAND(M,V,[M N]) return
% an M-by-N array.
%
% MMRANDN(M,V,[M N P ...]) returns a multidimensional array.
%
% MMRAND(M,V,SIZE(A)) returns an array the same size as A.
%
% MMRANDN calls the MATLAB function RANDN.
%
% See also RANDN, MMRAND, RAND

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 5/21/96, v5: 1/14/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin==4                     % MMRANDN(M,V,M,N)
	m=[m(1) n(1)];
end
if V<=0,error('Variance Must be Positive.'),end

y=V*randn(m)+M;
