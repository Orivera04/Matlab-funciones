function View=show(nd,cgh,View)
%SHOW
%
%  View=show(nd,cgh,View)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.3 $  $Date: 2004/02/09 08:22:58 $

if cgh.GuiExists
    d=View;
    d.pD = getdata(nd);
    d.CGBH = cgh;
end

d.Exprs.recalc = [1 1 1 0];

pr_Message(d,'');
d.Handles.ExprList.ListItems.Clear;

% Need to do some units checking - may have converted
%  an expression to a different unit; need to convert data to match.
d.pD.info = d.pD.CheckDataset(project(nd));

View = d;