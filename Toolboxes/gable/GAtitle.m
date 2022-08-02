function h=GAtitle(s,c)
%
%See also gable.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.
if nargin==1
	h=title(s,'FontSize',18);
else
	h=title(s,'Color',c,'FontSize',18);
end
