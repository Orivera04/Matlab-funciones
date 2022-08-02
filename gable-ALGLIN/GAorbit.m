function GAorbit(degaz, degel)
% GAorbit(az,el): Rotate by steps the views in all subwindows simultaneously
%  The arguments are optional.
%   az: the number of degree to rotate the az view arg (defaults is 180)
%   el: The elevation to use for the rotation
%
%See also gable.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.

% Note: This code is based on code that appeared in the Math Works
%  book, Matlab: The Language of Technical Computing.  

if nargin==0
  degaz = 180;
end
[az el] = view;
if nargin == 2
  el = degel;
end
rotvec = 0:degaz/10:degaz;
sp = get(gcf,'Children');
for j=1:length(sp)
  subplot(sp(j))
  axis vis3d
end
for i=1:length(rotvec)
  for j=1:length(sp)
    subplot(sp(j))
    view([az+rotvec(i) el])
  end
  drawnow
end
