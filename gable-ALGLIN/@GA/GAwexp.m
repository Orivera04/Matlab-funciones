function C = GAwexp(A)
%GAwexp(A): Gives the wedge product exponential of a GA objects.
%
%See also gable.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.
         M =[A.m(1)    0       0       0       0       0       0       0;
	     A.m(2)  A.m(1)    0       0       0       0       0       0;
	     A.m(3)    0     A.m(1)    0       0       0       0       0;
	     A.m(4)    0       0     A.m(1)    0       0       0       0;
	     A.m(5) -A.m(3)  A.m(2)    0     A.m(1)    0       0       0;
	     A.m(6)    0    -A.m(4)  A.m(3)    0     A.m(1)    0       0;
	     A.m(7)  A.m(4)    0    -A.m(2)    0       0     A.m(1)    0;
	     A.m(8)  A.m(6)  A.m(7)  A.m(5)  A.m(4)  A.m(2)  A.m(3)  A.m(1)];
	 E=expm(M);
	 C=GA(E(1:8,1));
