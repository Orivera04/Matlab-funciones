function GAview(A)
% GAview(A): call view(A) on all subplots
%
%See also gable, view.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.
sp = get(gcf,'Children');
for j=1:length(sp)
  subplot(sp(j))
  view(A);
end
