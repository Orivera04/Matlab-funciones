function C = mtimes(m,n)
%mtimes(m,n): multiply two multivectors.
%
%See also gable.

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
	 T = GAproduct(m,n);
     end
     if GAautoscalar&isascalar(T)
	C=T.m(1);
     else
	C=T;
     end
