function con=connection(e,A,B)
%connection(e,A,B): Compute the translational moment from A to B.
%  Both A and B must be in homogeneous form.
%  This is what you need to add to A to make its meet with B non-trivial.
%
%See also gable.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.
tA = inner(e,A);
tB = inner(e,B);
ejAB = e^(join(tA,tB)*meet(tA,tB));
Ato0 = GAZ((A-contraction(A,ejAB)/ejAB)/inner(e,A));
Bto0 = GAZ((B-contraction(B,ejAB)/ejAB)/inner(e,B));
con = GAZ(GA(Bto0-Ato0))^tA;
