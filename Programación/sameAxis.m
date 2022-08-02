function a = sameAxis
%sameAxis: return an array of subplot axes.
%
%See also gable.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.
sp = get(gcf,'Children');
for j=1:length(sp)
  subplot(sp(j))
  a[j,1:6] = axis;
end
