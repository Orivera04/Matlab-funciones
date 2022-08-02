function con=connection(e,A,B)
% connection(e,A,B): Compute the translational moment from A to B.
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

% this is the scalar case
    con = 0;
