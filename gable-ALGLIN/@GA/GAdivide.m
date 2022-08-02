function c = GAdivide(a,b)
%GAdivide: return a/b = a*inverse(b), where a,b are GA objects.
%
%See also gable.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.
    c = GAproduct(a,inverse(b));
