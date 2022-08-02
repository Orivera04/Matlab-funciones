function C = GAouter(m,n)
%GAouter(m,n): Computes the outer product of two GA objects.
%
%See also gable.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.
     	   M = [m.m(1)    0       0       0       0       0       0       0;
	        m.m(2)  m.m(1)    0       0       0       0       0       0;
	        m.m(3)    0     m.m(1)    0       0       0       0       0;
	        m.m(4)    0       0     m.m(1)    0       0       0       0;
	        m.m(5) -m.m(3)  m.m(2)    0     m.m(1)    0       0       0;
	        m.m(6)    0    -m.m(4)  m.m(3)    0     m.m(1)    0       0;
                m.m(7)  m.m(4)    0    -m.m(2)    0       0     m.m(1)    0;
	        m.m(8)  m.m(6)  m.m(7)  m.m(5)  m.m(4)  m.m(2)  m.m(3)  m.m(1)];
	   C = GA(M*n.m);
