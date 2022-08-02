function C = minus(m,n)
%minus(m,n): subtract two multivectors.
%
%See also gable.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.
    if isa(m,'double')
       m = GA([m;0;0;0;0;0;0;0]);
    end
    if isa(n,'double')
       n = GA([n;0;0;0;0;0;0;0]);
    end
    T = GAminus(m,n);
    if GAautoscalar&isascalar(T)
	C=T.m(1);
    else
	C=T;
    end
