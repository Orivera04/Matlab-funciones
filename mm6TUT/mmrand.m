function y=mmrand(a,tol,m,n)
%MMRAND Uniformly Distributed Random Arrays. (MM)
% MMRAND(AVG,TOL,N) returns an N-by-N array of uniformly
% distributed numbers between AVG-TOL and AVG+TOL.
%
% MMRAND(AVG,TOL,M,N) and MMRAND(AVG,TOL,[M N]) return
% an M-by-N array.
%
% MMRAND(AVG,TOL,[M N P ...]) generates multidimensional arrays.
%
% MMRAND(AVG,TOL,SIZE(A)) returns an array the same size as A.
%
% MMRAND calls the MATLAB function RAND.
%
% See also RAND, MMRANDN, RANDN

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 5/21/96, v5: 1/14/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin==4                     % MMRAND(AVG,TOL,M,N)
	m=[m(1) n(1)];
end

y=2*tol*rand(m)+(a-tol);
