function vw_import(nd)
%VW_IMPORT  From-View import route
%
%  vw_import(nd)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.6.2.2 $  $Date: 2004/02/09 08:23:02 $


[ok,op]=import(nd);
h=cgbrowser;
d=h.getViewData;
if ok == 1
   % PKD - Fix to allow import of datasets (from Excel etc) when 
   % there are no expressions in the project
   if isempty(d.Exprs.Eptrs)
      d.Dlg.Wizard = 0;        
   else
      d.Dlg.Wizard = 1;
   end
   d.Dlg.tmp = op;
   d = pr_ChangeView(d,'importdlg');
   pr_SetViewData(d);
elseif ok == 2
   op = eval_fill(op);
   d.pD.info = op;   
   pr_SetViewData(d);
   h.doDrawTree(address(d.nd), 'update');
   h.ViewNode;
end
