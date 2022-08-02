function View=show(nd,cgh,View)
%SHOW Reconfigure the browser display
%
%  View=SHOW(nd,cgh,View) is called when the browser display is first
%  entered for an object.  This configures the display to correctly display
%  the node.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.2.4 $  $Date: 2004/04/04 03:33:30 $

cgmod = getdata(nd);
M = cgmod.get('model');

% Check whether function editing should be enabled
if strcmp(type(M),'Function model')
    set(View.ChangeFuncModel,'enable','on');
    set(View.ChangeFuncModelBtn,'enable','on');
else
    set(View.ChangeFuncModel,'enable','off');
    set(View.ChangeFuncModelBtn,'enable','off');
end

% Check whether Load Model menu should be enabled
en = 'off';
if strcmp(type(M),'MBC model')
    INFO = getinfo(M);
    if ~isempty(INFO) && isfield(INFO, 'Parent') && exist(INFO.Parent, 'file')
        en = 'on';
    end
end
set(View.LoadMBCModel,'enable',en);

% Check whether constraints option should be available
if cgmod.concheck
    set(View.DispConstraintsMenu, 'enable', 'on');
else
    set(View.DispConstraintsMenu, 'enable', 'off');
end

% Update displays
if View.ExprView.RootExpression==cgmod
    View.ExprView.update;
    View.ModelView.setmodel;
else
    View.ExprView.RootExpression = cgmod;
    View.ModelView.Expression = cgmod;
end
View.SkipViewUpdate = true;
