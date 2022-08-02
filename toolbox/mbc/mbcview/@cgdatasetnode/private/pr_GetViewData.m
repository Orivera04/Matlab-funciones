function d=i_GetViewData

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:22:26 $
CGBH = cgbrowser;
if CGBH.GuiExists
    d=CGBH.getViewData;
    d.CGBH = CGBH;
    nd = CGBH.CurrentNode;
    d.nd = nd.info;
    d.pD = nd.getdata;
else
    d=[];
end
