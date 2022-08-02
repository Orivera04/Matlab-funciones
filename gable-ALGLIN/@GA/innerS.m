function C = innerS(m,n)
%innerS(m,n): Computes the inner product between two multivectors.
% innerS(m,n) = sum_r,s grade(grade(m,r)*grade(n,s), |r-s|) r,s >=0
%
%See also gable, inner.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.
     if isa(m, 'double')
        T = GA(m*n.m);
     elseif isa(n, 'double')
        T = GA(n*m.m);
     else
	 T = GAinnerS(m,n);
     end
     if GAautoscalar&isascalar(T)
	C=T.m(1);
     else
	C=T;
     end
