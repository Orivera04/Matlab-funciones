function C = GAdual(A)
%GAdual(A): Computes the dual, A/I3
%
%See also gable.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.
    C=GAdual(GA([A;0;0;0;0;0;0;0]));
