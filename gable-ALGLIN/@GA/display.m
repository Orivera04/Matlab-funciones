function display(p)
%display(p): Matlab display command for GA objects.
%
%See also gable.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.

disp(' ');
disp([inputname(1),' = '])
disp(' ');
%disp(['   ' char(p)])
disp([char(p)])
disp(' ');
