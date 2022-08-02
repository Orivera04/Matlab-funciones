function ud= control(mdev,hFig,ud);
% MODELDEV/CONTROL

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:10:06 $

if nargin<3
   ud= get(hFig,'UserData');
end
PageNo= mdev.ViewIndex;

% Show 
ud.View{PageNo}= feval(ud.View{PageNo}.mfile,'Control',hFig,ud.View{PageNo},pointer(mdev));

if nargin<3
   set(hFig,'UserData',ud);
end
