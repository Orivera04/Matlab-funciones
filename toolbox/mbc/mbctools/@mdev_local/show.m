function View= Show(mdev,mbH,View);
% SHOW  View Initialisation
%
%  View=SHOW(TP, mbH, View)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.7.4.4 $  $Date: 2004/02/09 08:05:10 $



% Created 11/4/2001

p=address(mdev);
hFig=mbH.Figure;

% Used to indicate whether you need to refit global models
View.Update=0;

msgID=mbH.addStatusMsg('Setting up Local Models');

y= p.getdata('Y');
if View.SweepPos> size(y,3)
	View.SweepPos= 1;
end
% View.SweepPos is the index of the current sweep within TestNum(y)
View.SweepClick.list = testnum(y);
View.SweepClick.value = View.SweepClick.list(View.SweepPos);

m= model(mdev);

NameList= children(mdev,'name')';
NameList= NameList(RFstart(m)+1:end);

%% funny catch. If select multiple outliers from menubar, it needs to 
%% have gca visible...so set gca to be on this panel
ol = View.OutlierLine;
% set(mbH.Figure,'currentAxes',ol.lineParents(1));

%%------get regression info for summary table---------------
local_regstats('setup',View.Reg,p);

%% ensure all outlier menus are enabled 
%% (e.g. if we've come from global node where they were disabled)
uic =get([ol.g.axes,ol.SpecialPlotAxes],'uicontextmenu');
hOut= findobj(get(MBrowser,'Figure'),'type','uimenu','tag','outlier');
set(hOut,'enable','on');

%% monitor plots - point to the current testplan
plotAx = findobj(hFig,'tag','monitor context menu');
ud = get(plotAx,'userdata');
ud.Tp = address(mdevtestplan(mdev));
set(plotAx,'userdata',ud);

mv_MonitorPlots('createaxes',hFig,ud.Tp );

%%============= MLE panel ====================
%Show appropriate parts of the MLE frame and create mle_diagnostic plots
%% note that MLE show pretty much just calls MLE i_View
%mv_MLE('show',View.MLEObj,p); 
%%============= end MLE panel ====================

View.Children=[];

ChildTab= View.ChildTab;
PageNo= get(ChildTab,'currentcard');
set(ChildTab,'currentcard',PageNo);

%-------- Set the FORWARD & BACKWARD menus ------------
Bmenu= findobj(hFig,'type','uimenu','tag','BackwardMenu');
Fmenu= findobj(hFig,'type','uimenu','tag','ForwardMenu');
set([Bmenu;Fmenu],'enable','on');

TS= BestModel(mdev);
% enable menus
if isempty(TS) | ~ismle(TS);
	if numSubModels(mdev)>=1
		set(View.menus.model(end-3),'enable','off')
	else
		set(View.menus.model(end-3),'enable','on')
	end
end

mbH.removeStatusMsg(msgID);

if mle_NeedsUpdate(mdev)
	uiwait(mledialog(mdev,'The MLE Model has changed and needs to be updated.'));
end



