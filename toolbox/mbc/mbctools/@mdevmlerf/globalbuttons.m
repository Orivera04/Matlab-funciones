function newBtns= globalbuttons(mdev,View)
%GLOBALBUTTONS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.4.3 $  $Date: 2004/04/04 03:31:20 $

xregTB = get(View.toolbarBtns(1),'parent');
[null, newBtns] = xregtoolbar(xregTB, {'uipush'},...
	{'imageFile'}, {'mle.bmp'},...
	{'Tooltipstring'}, {'Recalculate MLE'},...
	{'clickedcallback'}, {@i_MLE},...
	'transparentcolor', [0 255 0]);

set(View.toolbarBtns(2:3),'enable','off');

% model menus
% setup,reset,box-cox,utils
set(View.menus.model,'enable','off');

% enable evaluate menu
hm= findobj(View.menus.model,'tag','eval');
set(hm,'enable','on');


%% set up Utilities menu
uMenu = findobj(View.menus.model,'tag','utilities');
hands= uimenu(uMenu,...
      'label','Recalculate &MLE',...
      'Callback',{@i_MLE});
set(uMenu,'enable','on');
% select
hOut= findobj(get(MBrowser,'Figure'),'type','uimenu','tag','outlier');
set(hOut,'enable','on');
set(View.menus.outliers,'enable','on');
set(View.menus.outliers(end),'enable','off');


function i_MLE(h,evt)

p= get(MBrowser,'currentnode');
p= p.Parent;

hFig=p.mledialog('Recalculate MLE');
uiwait(hFig);

ViewNode(MBrowser);
