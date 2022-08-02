function G = GAExpand(m)
%GAEXpand(m): Expands a Multivector to a matrix representation.
%
%See also gable.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.
S=GAsignature;
	  G = [m.m(1)  S(1)*m.m(2)  S(2)*m.m(3)  S(3)*m.m(4) -S(1)*S(2)*m.m(5) -S(2)*S(3)*m.m(6) -S(1)*S(3)*m.m(7) -S(1)*S(2)*S(3)*m.m(8);
	       m.m(2)     m.m(1)    S(2)*m.m(5) -S(3)*m.m(7)   -S(2)*m.m(3)    -S(2)*S(3)*m.m(8)    S(3)*m.m(4)     -S(2)*S(3)*m.m(6);
	       m.m(3) -S(1)*m.m(5)     m.m(1)    S(3)*m.m(6)    S(1)*m.m(2)      -S(3)*m.m(4)    -S(3)*S(1)*m.m(8)  -S(1)*S(3)*m.m(7);
	       m.m(4)  S(1)*m.m(7) -S(2)*m.m(6)     m.m(1)   -S(1)*S(2)*m.m(8)    S(2)*m.m(3)      -S(1)*m.m(2)     -S(1)*S(2)*m.m(5);
	       m.m(5)    -m.m(3)       m.m(2)    S(3)*m.m(8)       m.m(1)         S(3)*m.m(7)      -S(3)*m.m(6)         S(3)*m.m(4);
	       m.m(6)  S(1)*m.m(8)    -m.m(4)       m.m(3)     -S(1)*m.m(7)          m.m(1)         S(1)*m.m(5)         S(1)*m.m(2);
	       m.m(7)     m.m(4)    S(2)*m.m(8)    -m.m(2)      S(2)*m.m(6)      -S(2)*m.m(5)          m.m(1)           S(2)*m.m(3);
	       m.m(8)     m.m(6)       m.m(7)       m.m(5)         m.m(4)            m.m(2)            m.m(3)              m.m(1)];
