function b=isGrade(A,g)
% isGrade(A,g): return 1 if A is of grade g
%
%See also gable.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.

if g==0 | A==0
	b = 1;
elseif g==1 | g==2 | g==3 | g==-1
	b = 0;
else
	error('isGrade: invalid grade.');
end
