function r = sLog(spinor)
% Takes logarithm of spinor
%See also gable.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.

plane = unit(grade(spinor,2));
r = log(norm(spinor))+plane*atan2(grade(spinor/plane,0),grade(spinor,0));
