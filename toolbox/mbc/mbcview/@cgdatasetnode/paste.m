function paste(D,data)
% cgdatasetnode/paste method

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.5.2.2 $  $Date: 2004/02/09 08:21:51 $
if isnumeric(data)
   CGBH = cgbrowser;
   if CGBH.GuiExists
      d=CGBH.getViewData;
      pN = CGBH.CurrentNode;
      d.pD = pN.getdata;
      
      page = d.ViewInfo(d.currentviewinfo);
      if ~isempty(page.paste)
         feval(page.paste,d,data);
      end
   end
end