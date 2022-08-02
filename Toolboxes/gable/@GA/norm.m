function C = norm(m)
%norm(m): Returns the norm of a multivector.
%
%See also gable.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.
        B=GAbilinear(m,m);
        if B>0
           C=sqrt(B);
        else
           C=sqrt(-B);
        end
