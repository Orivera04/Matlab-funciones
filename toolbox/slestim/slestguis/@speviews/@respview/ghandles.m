function h = ghandles(this)
% Returns a 3-D array of handles of respview's graphical objects
% where the first two dimensions correspond to the axes grid
% and the third to the number of objects in each axes.

%  Copyright 1986-2002 The MathWorks, Inc.
%  $Revision: 1.1.4.1 $ $Date: 2004/04/16 22:21:21 $

% Determine max number of entries
[nport,nexp] = size(this.SimPlot);
Nc = cellfun('length',this.SimPlot);
Nc = max(Nc(:)); % max number of curves
h = handle(NaN(nport*nexp,Nc));
for ct = 1:nport*nexp
   c = this.SimPlot{ct};
   nc = length(c);
   h(ct,1:nc) = reshape(c,[1 nc]);
end
h = reshape(h,[nport nexp Nc]);
