function str = rcinfo(this,wf,Row,Col,HostLine)
% Constructs data tip text localizing plot in axes grid.

%   Author(s): Pascal Gahinet
%   Copyright 1986-2002 The MathWorks, Inc.
%   $Revision $  $Date: 2004/04/16 22:21:24 $
[RowNames,ColNames] = getrcname(wf);
rName = utGetPortName(RowNames(Row));
cName = ColNames{Col};
str = strvcat(...
   sprintf('Experiment: %s',cName),...
   sprintf('Output: %s',rName{1}));

% If port width is >1, add info about which signal was selected
PortSize = this.PortSize{Row};
if prod(PortSize)>1
   idxSel = find(HostLine==handle(this.SimPlot{Row,Col}));
   if length(PortSize)==1
      % vector-valued port
      str = strvcat(str,sprintf('Channel: %d',idxSel));
   else
      [i,j] = ind2sub(PortSize,idxSel);
      str = strvcat(str,sprintf('Channel: (%d,%d)',i,j));
   end
end
   
