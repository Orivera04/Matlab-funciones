function newBtns= globalbuttons(mdev,View);
%GLOBALBUTTONS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.6.4.2 $  $Date: 2004/02/09 08:10:23 $



m= model(mdev);
newBtns = globalbuttons(model(mdev),'toolbar',View);

newUtilitiesMenus = globalbuttons(model(mdev),'utilities',View);
%% --------- Utilities menu disable? -------------
um=findobj(View.menus.model,'label','&Utilities');
if isempty(newUtilitiesMenus)
   set(um,'enable','off');
else
   set(um,'enable','on');
end   

%% Box Cox if there is a Ytrans, turn menu on
hYTM= findobj(View.menus.model(:),'tag','Ytranstool');
if (~islinear(m) & ~isa(m,'xregUnispline')) | numChildren(mdev)
	set(hYTM,'enable','off');
	set(View.toolbarBtns(2),'enable','off');
else
	set(hYTM,'enable','on');
	set(View.toolbarBtns(2),'enable','on');
end

% enable evaluate menu
hok= findobj(View.menus.model,'tag','eval');
if status(mdev);
	set(hok,'enable','on');
else
	set(hok,'enable','off');
end
hok= findobj(View.menus.model,'tag','build');
set(hok,'enable','on');

% model menus
hOut= findobj(get(MBrowser,'Figure'),'type','uimenu','tag','outlier');
if numChildren(mdev)
	set(hOut,'enable','off');
	set(View.menus.outliers,'enable','off');
	% setup,reset,box-cox,utils
    hm= findobj(View.menus.model,'tag','setup');
    hm(2)= findobj(View.menus.model,'tag','reset');
    hm(3)= findobj(View.menus.model,'tag','Ytranstool');
    hm(4)= findobj(View.menus.model,'tag','utilities');
    set(hm,'enable','off');
	set(View.toolbarBtns(2),'enable','off');
	set(newBtns,'enable','off');
    
    % select
    hm= findobj(View.menus.model,'tag','select');
    hm(2)= findobj(View.menus.model,'tag','template');
    set(hm,'enable','on');
    
 else
	set(hOut,'enable','on');
	set(View.menus.outliers,'enable','on');
	% setup,reset,box-cox,utils
    hm= findobj(View.menus.model,'tag','setup');
    hm(2)= findobj(View.menus.model,'tag','reset');
    hm(3)= findobj(View.menus.model,'tag','stats');
	set(hm,'enable','on');
    
	% make template & select
    hm= findobj(View.menus.model,'tag','template');
    hm(2)= findobj(View.menus.model,'tag','select');
	set(hm,'enable','off');

    % model specific
    set(newUtilitiesMenus,'enable','on');
    set(newBtns,'enable','on');
end

%build models on
hm= findobj(View.menus.model,'tag','build');
set(hm,'enable','on');
set(View.toolbarBtns(3),'enable','on');

