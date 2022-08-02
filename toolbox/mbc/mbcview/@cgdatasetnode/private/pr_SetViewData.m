function pr_SetViewData(d)
%PR_SETVIEWDATA

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:22:32 $

CGBH = cgbrowser;
if CGBH.GuiExists
    setViewData(CGBH,d);
else
    %set(i_GetHandle , 'UserData' , d);
end
