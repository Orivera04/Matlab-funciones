function drawall(S)
%drawall(S): Draw the geometric relationships created by geoall
%
%See also gable.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.
       clf;
       draw(S.obj1,'b'); draw(S.obj2,'g');
       draw(S.comp,'r'); draw(S.proj,'c'); draw(S.rej,'m');
       draw(S.meet,'k'); draw(S.join,'y');
