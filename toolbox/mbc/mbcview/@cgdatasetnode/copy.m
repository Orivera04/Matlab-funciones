function data=copy(D)
% cgdatasetnode/copy method

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 08:21:42 $
CGBH = cgbrowser;
if CGBH.GuiExists
   d=CGBH.getViewData;
   pN = CGBH.CurrentNode;
   d.pD = pN.getdata;
      
   page = d.ViewInfo(d.currentviewinfo);
   if ~isempty(page.copy)
      data = feval(page.copy,d);
   else
      % attempt to copy entire dataset
      opP=getdata(D);
      if ~isempty(opP.info)
         data = opP.get('data');
         heads = opP.get('factors');
         data={data,heads};
      end
   end
end