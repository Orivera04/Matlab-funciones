function View=view(TP, mbH, View)
% VIEW Update current view
%
%  view(TP, mbH)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 08:08:26 $



% Create 5/12/2000

View.hHSM= draw(TP.DesignDev,double(View.HSM),0,TP);
DisplaySizes(TP,View);

EnableMenus(TP,View);

set(View.StageClick,'value',length(TP.DesignDev));
set(View.Notes,'string',TP.Notes);

return