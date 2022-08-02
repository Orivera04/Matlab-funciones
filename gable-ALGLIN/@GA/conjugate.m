function c=conjugate(m)
%conjugate(m): compute the Clifford conjugate of a multivector.
%
%See also gable.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.
c = GA([m.m(1); -m.m(2); -m.m(3); -m.m(4); - m.m(5); -m.m(6);  -m.m(7);  m.m(8)]);
