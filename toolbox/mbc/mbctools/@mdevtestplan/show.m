function View=Show(TP, mbH, View)
% SHOW  View Initialisation
%
%  View=SHOW(TP, mbH, View)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.6.4.2 $  $Date: 2004/02/09 08:08:21 $



% Created 5/12/2000

mp = project(TP);
dp= mp.dataptrs;
dok=0;
for i=1:prod(size(dp))
   dok=dok | ~dp(i).isempty;
end
if isempty(dp) | ~dok;
   % must have more variables available in the data set than number of testplan factors
   nodata = 1;
	set(View.menus.toolschild(3),'enable','off')
	set(View.toolbarBtns(2),'enable','off')
else
   nodata = 0;
	set(View.menus.toolschild(3),'enable','on')
	set(View.toolbarBtns(2),'enable','on')
end
set(View.Notes,'string',TP.Notes);

return;