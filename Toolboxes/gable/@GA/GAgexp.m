function C = GAgexp(m)
%GAgexp(m): Computes the geometric product exponential of a multivector.
% m should be a GA objects.
%
%See also gable.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.
	M = GAExpand(m);
	E=expm(M);
	C=GA(E(1:8,1));
