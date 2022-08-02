function varargout= mv_LocalReg(Action,varargin)
% MV_LOCALREG local regression view on Model Browser
% 
% varargout= mv_LocalReg(Action,varargin)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.2.6 $  $Date: 2004/04/04 03:30:45 $

hFig= mvf;
if ~isempty(hFig)
   PR=xregGui.PointerRepository;
   ptrID=PR.stackSetPointer(hFig,'watch');
end

switch lower(Action)
case 'sweepchange',
	% sweep navigation
	i_SweepChange(varargin{:});
case 'units'
	% natural/transformed units
	i_units;
case 'fitoptions'
	i_FitOptions;
case 'showbd'
	% show bad data
	i_showbd;
case 'notes'
	% Sweep Notes
	i_Notes
case 'color'
	% Sweep Notes
	i_Color
case 'rmseplot'
	i_RMSEPlot;
case 'tabcallback'
	% changes local view tab 
	i_tabcallback(varargin{:});
case 'badsweep'
	i_badSweep;
case 'applyoutliers'
	i_applyoutliers(varargin{:});
case 'restoreoutliers'
	i_RestoreOutliers;
case 'print'
	i_Print(varargin{:});
case 'monitordlg'
	i_monitordlg(varargin{:});
end

if ~isempty(hFig)
   PR.stackRemovePointer(hFig,ptrID);
end


%---------------------------------------------------------------------------
% SUBFUNCTION i_SweepChange
%---------------------------------------------------------------------------
function i_SweepChange(nullA,nullB,source)
%% source = SweepClick, SelectBtn, Fwd & Back menus

mbH= MBrowser;
p= mbH.CurrentNode;
View= mbH.GetViewData;
[X,Y]= getdata(p.info);

switch source
case 'SweepClick'
   OK=1;
   NewS = find(View.SweepClick.list==View.SweepClick.value);

case 'increment'
   OK=1;
   View.SweepClick.increment(1);
   NewS = find(View.SweepClick.list==View.SweepClick.value);
   
case 'decrement'
   OK=1;
   View.SweepClick.decrement(1);
   NewS = find(View.SweepClick.list==View.SweepClick.value);
   
case 'SelectBtn'
    NewS= p.TestChooser;
    OK= NewS~=0;
end

if OK
   View.SweepPos=NewS;
   % set SweepClick to new Sweep Num (if change not called from SweepClick)
   View.SweepClick.value = View.SweepClick.list(NewS);
	mbH.SetViewData(View);
	mbH.ViewNode;

   % do we need to disable menus??
   Bmenu= findobj(mvf,'type','uimenu','tag','BackwardMenu');
   Fmenu= findobj(mvf,'type','uimenu','tag','ForwardMenu');
   set([Bmenu;Fmenu],'enable','on');
   if View.SweepPos==1
      set(Bmenu,'enable','off');
   end
   if View.SweepPos==size(Y,3)
      set(Fmenu,'enable','off');
   end
   % Send the sweep change to anyone who's listening
   eventData = xregGui.xregEventData(mbH, 'LocalSweepIndexChanged', NewS);
   send(mbH, 'LocalSweepIndexChanged', eventData);
end

%---------------------------------------------------------------------------
% SUBFUNCTION i_StringSpace;
%---------------------------------------------------------------------------
function i_StringSpace(source, null, View, p)

mbH= MBrowser;
if nargin <4
	p= mbH.CurrentNode;
	View= mbH.GetViewData;
end
%% might need to make more room for long model name
%% infoGrid has gapx = 5 hence room for text needs to be textLength+button+15
%% infoGrid takes in viewmodel from local_regstats and this needs the extra room aswell
visState = get(View.Reg.hStrf,'visible');
set(View.Reg.viewmodel,'visible','off');

%% horiz room for whole of viewmodel grid is 
%% (210 = sweepClick panel + view button + gaps)
space = get(View.infoGrid,'position'); space = space(3) - 210 - 60;
%% find length of string we WANT to display
set(View.Reg.hStrf,'string',str_func(p.model,1));
textLength = get(View.Reg.hStrf,'extent'); textLength = textLength(3);

if textLength < space
   set(View.Reg.viewmodel,'colsizes',[-1, max(100,textLength), 40, -1]);
   set(View.infoGrid, 'colsizes',[180,-1, max(100,textLength)+70]);
else
   set(View.Reg.hStrf,'string',p.name);
   set(View.Reg.viewmodel,'colsizes',[-1, 100, 40, -1]);   
   set(View.infoGrid, 'colsizes',[180,-1, 170]);
end
%% set layout vis on if it was on before!
%% will leave it off if we are on MLE tab for example
set(View.Reg.viewmodel,'visible',visState);
return
%---------------------------------------------------------------------------
% SUBFUNCTION i_Assignbad;
%---------------------------------------------------------------------------
function i_assignbad(index,varargin)

% get the pointer and View from the main 'Tree' figure;
fH=gcbf;
mbH= MBrowser;
p_mdev= mbH.CurrentNode;
View= mbH.GetViewData;
SweepPos=View.SweepPos;

% Pass the index to the outlier routine.
p_mdev.addoutliers(SweepPos,index);
if nargin<2
	% Add the indices for the bad data to the View.LocalBadData index
    % in case of 'undo'
	View.LocalBadData{SweepPos}=index;
else
	% Remove outliers from sweep
	View.LocalBadData{SweepPos}=[];
end
View.Update=3;

mbH.SetViewData(View);
mbH.ViewNode;


%---------------------------------------------------------------------------
% SUBFUNCTION i_units
%---------------------------------------------------------------------------
function i_units

tag=get(gcbo,'tag');
n=findobj(gcbf,'tag','ytrans_units');
ch=get(n(1),'checked');
switch ch
case 'on'
	set(n(:),'checked','off');
case 'off'
	set(n(:),'checked','on');
end

ViewNode(MBrowser);

%---------------------------------------------------------------------------
% SUBFUNCTION i_showbd
%---------------------------------------------------------------------------
function i_showbd

tag=get(gcbo,'tag');
SBD=findobj(gcbf,'tag','showBD1');
ch=get(SBD(1),'checked');
switch ch
case 'on'
	set(SBD(:),'checked','off');
case 'off'
	set(SBD(:),'checked','on');
end

ViewNode(MBrowser);


%---------------------------------------------------------------------------
% SUBFUNCTION i_tabcallback
%---------------------------------------------------------------------------
function i_tabcallback(CurTab)

mbH= MBrowser;

p= mbH.CurrentNode;
View= mbH.GetViewData;

%% if called from menus rather than clicking tabs
if CurTab~= get(View.ChildTab,'currentcard')
    set(View.ChildTab,'currentcard',CurTab)
end

ol=diagnosticPlots(p.info,'getoutlierline');

%% turn off tools/view menuitems
badMenuH = findobj(mvf,'type','uimenu','tag','BadTest');
OlMenuH = findobj(mvf,'type','uimenu','tag','outlier');
fwdMenu = findobj(mvf,'type','uimenu','tag','ForwardMenu');
selMenu = findobj(mvf,'type','uimenu','tag','SelectMenu');
backMenu = findobj(mvf,'type','uimenu','tag','BackwardMenu');

if CurTab==3 %% mle
   set([badMenuH;OlMenuH;fwdMenu;selMenu;backMenu],'enable','off');
   if  View.Update 
      %% if outliers applied on other tabs, need to redo MLE
      %% as happens when changing local node on model tree
      p.UpdateLinks(View.Update);
		mbH.doDrawTree(p);
		View.Update=0; 
		mbH.SetViewData(View);
	end
    mv_MLE('view',View.MLEObj,p);  
else
    set([badMenuH;OlMenuH;fwdMenu;selMenu;backMenu],'enable','on');
end

mvH = mvf('mvModelView');
%% need to change the model displayed in the model view window
%% plots show local model for this sweep, MLE shows twostage model
if ~isempty(mvH)
    close(mvH);
    if CurTab==3
       if p.hasBest
          mvH= view(p.BestModel);
       else
          return
       end
    else 
        [L,OK]= LocalModel(p.info,View.SweepPos);
        X= getdata(p.info);
        X= X(:,:,View.SweepPos);
        if OK
            % summary stats
            ms= p.mle_stats;
            Pooled_RMSE= sqrt(ms.Pooled_MSE);
            mvH = view(L,p.fullname,testnum(X),Pooled_RMSE);
        end     
    end
	 mbH.RegisterSubFigure(mvH);
end

%% enable/disable monitor plot set up menu
setup = findobj(mvf,'type','uimenu','tag','setupMonitorplots');
if CurTab==2
    set(setup,'enable','on');
else
    set(setup,'enable','off');
end

%% need to turn the legend visible on/off as appropriate
%% can do this via the listeners already set up
%% by setting axes visibility off then on again

ax=View.OutlierLine.SpecialPlotAxes;
state = get(ax,'visible');
if strcmp(state,'on')
    set(ax,'visible','off');
    set(ax,'visible',state);
end


%---------------------------------------------------------------------------
% SUBFUNCTION i_testnums
%---------------------------------------------------------------------------
function i_TestNums
if strcmp(get(gcbo,'check'),'on')
	set(gcbo,'check','off')
else
	set(gcbo,'check','on')
end

ViewNode(MBrowser);


%---------------------------------------------------------------------------
% SUBFUNCTION i_RMSEPlot
%---------------------------------------------------------------------------
function i_RMSEPlot

mbH= MBrowser;
p= mbH.CurrentNode;
fh= p.rmse_explorer;
mbH.RegisterSubFigure(fh);

%---------------------------------------------------------------------------
% SUBFUNCTION i_RMSEPlot
%---------------------------------------------------------------------------
function i_Notes

mbH= MBrowser;
p= mbH.CurrentNode;
View= mbH.GetViewData;

NewNote= get(gcbo,'string');
p.SweepNotes(View.SweepPos,NewNote);
[sno,col]= SweepNotes(p.info,View.SweepPos);
set(View.Color,'backgroundcolor',col);


%---------------------------------------------------------------------------
% SUBFUNCTION i_Color
%---------------------------------------------------------------------------
function i_Color

mbH= MBrowser;
p= mbH.CurrentNode;
View= mbH.GetViewData;

NewNote= get(View.Notes,'string');
NewColor= uisetcolor(get(View.Color,'backgroundcolor'),'Set Test Number Color');
if all(size(NewColor)==[1 3])
	p.SweepNotes(View.SweepPos,NewNote,NewColor);
	set(View.Color,'backgroundcolor',NewColor);
end


%---------------------------------------------------------------------------
% SUBFUNCTION i_FitOptions
%---------------------------------------------------------------------------
function i_FitOptions

mbH= MBrowser;
p= mbH.CurrentNode;
View= mbH.GetViewData;

gui_fitsetup(localmod,'create',p);


%----------------------------------------------
% Function i_badSweep
%----------------------------------------------
function i_badSweep
%% find data length and call applyoutliers with on points
mbH= MBrowser;
p= mbH.CurrentNode;
View= mbH.GetViewData;

ol=View.OutlierLine;
clear(ol);
i_applyoutliers([1:size(ol.g.data,1)])

%----------------------------------------------
% Function i_applyoutliers
%----------------------------------------------
function i_applyoutliers(index)

%% catches if bad sweep called when model not fitted at this sweep
mbH= MBrowser;
p= mbH.CurrentNode;
View= mbH.GetViewData;

SNo = View.SweepPos;
L= model(p.info);
[X,Y]= getdata(p.info);
[Xs,Ys,ok,badIndex]= checkdata(L,X(:,:,SNo),Y(:,:,SNo));
if ok
   p.addoutliers(SNo,index);
   % Force global model re-fit on exit
   View.Update = 3;
	mbH.SetViewData(View);
	mbH.ViewNode;
		
else
   return
end

%---------------------------------------------------------------------------
% SUBFUNCTION i_restoreoutliers
%---------------------------------------------------------------------------
function i_RestoreOutliers
%%called by mdev_local/diagnosticPlots
%% note that we still do all the work if "restore" called with no outliers to restore

% get the pointer and View from the main 'Tree' figure;
mbH= MBrowser;
p= mbH.CurrentNode;
View= mbH.GetViewData;
fmv = double(mbH.Figure);

olIndex=restoreoutlierdlg('create',info(p));
if ~isempty(olIndex)
    % Force global model re-fit on exit
    View.Update=3;
    mbH.SetViewData(View);
    mbH.ViewNode;
end

%---------------------------------------------------------
% SUBFUNCTION i_Print
%---------------------------------------------------------
function i_Print(hFig,View,p)

CurTab = get(View.ChildTab,'currentcard');
% Will I have to delete the ModelView window I create
DELETE_MV = 0;

mvH = mvf('mvModelView');
if isempty(mvH)
    if CurTab==3
       if ~isempty(p.BestModel) & p.mle_isrun
          %% we have some MLE plots
          mvH= view(p.BestModel);
       else %% don't do anything
          return
       end
    else
        [L,OK]= LocalModel(p.info,View.SweepPos);
        X= p.getdata;
        X= X(:,:,View.SweepPos);
        if OK
            % summary stats
            ms= p.mle_stats;
            Pooled_RMSE= sqrt(ms.Pooled_MSE);
            mvH = view(L,p.fullname,testnum(X),Pooled_RMSE);
        end     
    end
    set(mvH,'visible','off');
    DELETE_MV = 1;
end

tH = findobj(mvH,'type','axes');

switch CurTab
case 1	
    aH = diagnosticPlots(p.info,'getcurrentaxes',hFig);
    %% returns all axes of the outleir line = diagnostic plots AND current monitor plots
    %% only want to print the axes visible in current view.
    aH = aH(strcmp(get(aH,'vis'),'on'));
case 2
    aH = mv_MonitorPlots('getgridlayout',hFig);
case 3 
    if isempty(findobj(hFig,'type','axes','visible','on'))
        %% when come on this tab we may have graphs
        %% but gca might be invisible (on a different card!)
        return
    else
        aH = View.MLEObj.regLyt;
    end
end

printlayout1(aH,tH,p.fullname);

if DELETE_MV
	close(mvH);
end
% SUBFUNCTION i_monitordlg 
%
% Internal function to call mv_monitorplots setup dialog
%---------------------------------------------------------
function i_monitordlg(fH)

mbH= MBrowser;
p= mbH.CurrentNode;
View= mbH.GetViewData;
mv_MonitorPlots('monitordlg',fH, View.SweepPos, p);

