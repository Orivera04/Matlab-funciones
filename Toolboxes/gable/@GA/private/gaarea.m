function a = gaarea(px,py)
%gaarea(px,py): compute the area of a polygon.
%
%See also gable.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.
a = 0;
for i=1:length(px)-1
	a = a+px(i)*py(i+1)-px(i+1)*py(i);
end
a = a+px(length(px))*py(1)-px(1)*py(length(py));
a = a/2;
