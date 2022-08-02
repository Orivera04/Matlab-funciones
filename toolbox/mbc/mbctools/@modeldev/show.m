function [View]= show(mdev,mbH,View);
%SHOW

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.9.4.4 $  $Date: 2004/02/09 08:10:57 $




switch mdev.ViewIndex
case 'global'
	[View]= showGlobal(mdev,mbH,View);
case 'twostage'
	[View]= showTS(mdev,mbH,View);
end


%---------------------------------------------------------
% SUBFUNCTION showTS
%---------------------------------------------------------
function [View]= showTS(mdev,mbH,View);

X= getdata(mdev,'X');
View.NumSweeps= size(X,3);
View.NumPages = floor((View.NumSweeps-1)/View.SperPage)+1;
View.SweepClick.Max=View.NumPages;
if View.PageNo > View.NumPages
	View.PageNo= 1;
end

p=mbH.CurrentNode;

if p.hasBest
    set(View.toolbarBtns(1),'enable','on');
else
    set(View.toolbarBtns(1),'enable','off');
end


%---------------------------------------------------------
% SUBFUNCTION showGlobal
%---------------------------------------------------------
function [View]= showGlobal(mdev,mbH,View);

p= address(mdev);
OK= InitModel(mdev);
mdev= info(mdev);
hFig= double(mbH.Figure);

% summary stats 
c= colhead(mdev);
set(View.SummaryStats,...
   'rows.number',length(c))
set(View.SummaryStats,...
   'cells.colselection',[1 1],...
   'cells.rowselection',[1 length(c)],...
   'cells.type','uitext',...
   'cells.horizontalalignment','left',...
   'cells.fontsize',8,...
   'cells.string',c,...
   'cells.colselection',[2 2],...
   'cells.rowselection',[1 length(c)],...
   'cells.horizontalalignment','right',...
   'cells.fontsize',8);

% model dependent show

% get id of diagstats for this model and search for it in list.
% if it doesn't exist then create a new card page for it.
m= model(mdev);
if strcmp(class(mdev),'modeldev')
	id= gui_diagstats(m,'id');
else
	id= 'model';
end
ind= strmatch(id,View.Diagnosticsinfo.ids,'exact');
if isempty(ind)
   ind=length(View.Diagnosticsinfo.ids)+1;
   % make a new card
   set(View.Diagnosticsinfo.cards,'numcards',ind);
   % create layout etc for it
	if strcmp(id,'model')
		View.Diagnosticsinfo.structs{ind}= gui_diagstats(xregmodel,'create',hFig);
	else
		View.Diagnosticsinfo.structs{ind}= gui_diagstats(m,'create',hFig);
	end
   View.Diagnosticsinfo.ids(ind)={id};
   attach(View.Diagnosticsinfo.cards,View.Diagnosticsinfo.structs{ind}.layout,ind);
   set(View.Diagnosticsinfo.cards,'packstatus','on');
end
% set diagnostic info to current
set(View.Diagnosticsinfo.cards,'currentcard',ind);
View.Diagnostics= View.Diagnosticsinfo.structs{ind};

%% set outlierListbox callback to show sweepPlot
if mdev.ModelStage==1
    set(View.OutlierList,'tooltipstring','');    
else
    set(View.OutlierList,'tooltipstring','double-click to see test data',...
        'callback',{@i_plotsweep,p});
end
%% --------- set up global-model-dependent toolbar buttons and utilities menu -------------
numGenBtns=4;

hTB= get(View.toolbarBtns(1),'parent');
hTB.setRedraw(false);

delete(View.toolbarBtns(numGenBtns+1:end));
%% 5th submenu is Utilities
um=findobj(View.menus.model,'label','&Utilities');
%% delete old stuff
subMenus = setdiff(findobj(um),um);
if ~isempty(subMenus)
   delete(subMenus(ishandle(subMenus)));
end


par= Parent(mdev);
hb= findobj(View.menus.model,'tag','best');
if strcmp(par.class,'modeldev') & hasBest(mdev) & status(mdev)
   % assign best menu
   set(hb,'enable','on');
else
   set(hb,'enable','off');
end


set(View.toolbarBtns([1 3 4]),'enable','on');
newBtns = globalbuttons(mdev,View);

hTB.setRedraw(true);
hTB.drawToolBar;


View.toolbarBtns = [View.toolbarBtns(1:numGenBtns); newBtns(:)];


vm= get(View.menus.view,'children');
hm= findobj(View.menus.model,'tag','Ytranstool');
hm(2)= findobj(View.menus.model,'tag','stats');
if ~mdev.Status
   % box-cox menu bye-bye

   set(hm,'enable','off')
   set(um,'enable','off')
   % view menus
   set(View.toolbarBtns,'enable','off');
   set(vm,'enable','off')
else
   % enable view model
   set(vm,'enable','on')
end



%---------------------------------------------------------
% SUBFUNCTION i_plotsweep
%---------------------------------------------------------
function i_plotsweep(src,null,p)

seltype=get(gcbf,'SelectionType');

switch seltype
case 'open'
    diagnosticPlots(p.info,'plotsweep',src,[]);
end
