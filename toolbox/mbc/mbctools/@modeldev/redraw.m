function ud= redraw(mdev,hFig,ud);
% MODELDEV/REDRAW performs a hide,show and view command

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:10:48 $

if nargin<3
   ud= get(hFig,'UserData');
end

p= address(mdev);
[OK,ud]= hide(mdev,hFig,ud);
mdev= p.info;
ud= show(mdev,hFig,ud);
set(hFig,'userdata',ud);
mdev= p.info;
OK= view(mdev,hFig,ud);