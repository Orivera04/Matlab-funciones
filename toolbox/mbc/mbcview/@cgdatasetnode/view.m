function d=view(nd,cgh,d,varargin)
%VIEW
%
%  d=view(nd,cgh,d)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 08:23:01 $

%disp('cgdatasetnode/view');
PR=xregGui.PointerRepository;
ID=PR.stackSetPointer(d.Handles.Figure, 'watch');

if any(d.Exprs.recalc)
    if any(d.Exprs.recalc(1:2))
        pr_Message(d,'Checking project...');
    end

    d.Exprs = pr_makeProjectDisplay(d.Exprs,d.pD,nd,d.ILmanager);
end

% Check for empty dataset - change enable status of toolbar.
pr_SetViewData(d);
d = pr_EnableToolbar(d);

if nargin>3
    d = feval(d.CB.View,d,varargin{:});
else
    d = feval(d.CB.View,d);
end
PR.stackRemovePointer(d.Handles.Figure, ID);
return


