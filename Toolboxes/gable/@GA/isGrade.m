function b=isGrade(A,g)
% isGrade(A,g): return 1 if multivector A is of grade g
%
%See also gable.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.

b = 0; % assume wrong and set to 1 if right
if g==0
	if sum(abs(A.m(2:8))) == 0
		b = 1;
	end
elseif g==1
	if sum(abs([A.m(1);A.m(5:8)])) == 0
		b = 1;
	end
elseif g==2
	if sum(abs([A.m(1:4);A.m(8)])) == 0
		b = 1;
	end
elseif g==3
	if sum(abs(A.m(1:7))) == 0
		b = 1;
	end
elseif g==-1
	z = A.m == 0;
	z0 = z(1);
	z1 = sum(z(2:4))~=0;
	z2 = sum(z(5:7))~=0;
	z3 = z(8);
	% Note that the test treats 0 is a multivector!
	if z0+z1+z2+z3 ~= 1
		b = 1;
	end
else
	error('isGrade: invalid grade.');
end
