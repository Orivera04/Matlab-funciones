function hFig= mledialog(mdev,Message)
% MDEV_LOCAL/MLEDIALOG dialog to run mle
%
% hFig= mledialog(mdev,Message)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.1.6.2 $  $Date: 2004/02/09 08:04:57 $



if nargin==1
	Message='';
end

h= xregfigure('name','MLE',...
	'visible','off');
xregcenterfigure(h,[450 450]);
hFig= double(h);

bgc= get(0,'DefaultUiControlBackGroundColor');


f{1}= xreguicontrol('parent',hFig,...
	'style','text',...
   'HorizontalAlignment','left',...
	'string',Message);

udh=f{1};

set(hFig,'CLoseRequestFcn',{@i_Cancel,udh});
s=which('-all','LinearisedAnalysis','mdev');
if isempty(s)
   algs= {'Quasi-Newton','Expectation-Maximization'};
   InclLin= 0;
else
   algs= {'Quasi-Newton','Expectation-Maximization','Linearized Method'};
   InclLin= 1;
end
txt{1}=xreguicontrol('parent',hFig,...
   'style','text',...
   'pos',[0 0 250 20],...
   'value',1,...
   'backgroundcolor',bgc,...
   'HorizontalAlignment','left',...
   'string','Covariance estimation algorithm:',...
   'Visible','off');
aCtrls{1}=xreguicontrol('parent',hFig,...
   'style','popup',...
   'pos',[0 0 200 20],...
   'value',2,...
   'backgroundcolor','w',...
   'HorizontalAlignment','left',...
   'string',algs,...
   'callback',{@i_ChangeAlg,udh},...
   'Visible','off');
opt= xreguicontrol('parent',hFig,...
   'style','pushbutton',...
   'HorizontalAlignment','left',...
   'string','Options...',...
   'callback',{@i_ChangeOpts,udh},...
   'Visible','off');
if InclLin
   alglyt= xreggridlayout(hFig,...
      'dimension',[1 2],...
      'elements',{aCtrls{1},opt},...
      'correctalg','on',...
      'colsizes',[-1 60],...
      'gapx',10);
else
   alglyt= aCtrls{1};
end
MLEObj.AlgOpts= opt;

txt{2}=xreguicontrol('parent',hFig,...
   'style','text',...
   'pos',[0 0 55 15],...
   'value',1,...
   'HorizontalAlignment','left',...
   'string','Tolerance:',...
   'Visible','off');
aCtrls{2}=xreguicontrol('parent',hFig,...
   'style','edit',...
   'pos',[0 0 75 20],...
   'backgroundcolor','w',...
   'HorizontalAlignment','left',...
   'string',1e-3,...
   'userdata',1e-3,...
   'callback','xregCheckIsNum',...
   'Visible','off');

txt{3}=xreguicontrol('parent',hFig,...
   'style','text',...
   'pos',[0 0 55 15],...
   'value',1,...
   'backgroundcolor',bgc,...
   'HorizontalAlignment','left',...
   'string','Initialize with previous estimate:',...
   'Visible','off');
aCtrls{3}=xreguicontrol('parent',hFig,...
   'style','checkbox',...
   'pos',[0 0 75 20],...
   'HorizontalAlignment','left',...
   'Visible','off');
txt{4}=xreguicontrol('parent',hFig,...
   'style','text',...
   'pos',[0 0 55 15],...
   'value',1,...
   'backgroundcolor',bgc,...
   'Horizon','left',...
   'string','Predict missing values:',...
   'Visible','off');
aCtrls{4}=xreguicontrol('parent',hFig,...
   'style','checkbox',...
   'pos',[0 0 75 20],...
   'HorizontalAlignment','left',...
   'Visible','off');

[MLEObj.CovAlg MLEObj.TolFun MLEObj.InitVal MLEObj.PredMode]= deal(aCtrls{:});
MLEObj.aCtrls= aCtrls;

aCtrls{1}= alglyt;
galg= xreggridlayout(hFig,...
   'elements',[txt ; aCtrls]',...
	'dimension',[4 2],...
	'correctalg','on',...
	'colsizes',[160 -1],...
	'rowsizes',[20 20 20 20],...
   'gap',10);
f{2}= xregframetitlelayout(hFig,...
	'title','Algorithm',...
	'innerborder',[10 20 10 20],...
	'center',galg);


MLEObj.ProgAxes= xregaxes('parent',hFig,...
	'box','on',...
	'units','pixels');

btns{1}= xreguicontrol('parent',hFig,...
	'style','pushbutton',...
	'string','Start',...
	'Visible','off',...
	'interruptible','on',...
	'callback',{@i_Start,udh});
btns{2}= xreguicontrol('parent',hFig,...
	'style','pushbutton',...
	'string','Stop',...
	'enable','off',...
	'Visible','off',...
	'callback',@i_Stop);
MLEObj.Ctrls= btns;

fs= xreggridlayout(hFig,...
   'elements',[btns {[]}],...
	'dimension',[3 1],...
	'correctalg','on',...
	'rowsizes',[25 25 -1],...
   'gapy',10);

txt= xreguicontrol('parent',hFig,...
	'style','text',...
   'HorizontalAlignment','left',...
	'string','MLE progress message');
MLEObj.info= txt;

gProg= xreggridlayout(hFig,...
	'dimension',[2 2],...
	'elements',{axiswrapper(MLEObj.ProgAxes),txt,fs,[]},...
	'correctalg','on',...
	'gap',20,...
	'rowsizes',[-1 40],...
	'colsizes',[-1 80]);

f{3}= xregframetitlelayout(hFig,...
	'title','Progress',...
	'innerborder',[20 10 10 40],...
	'center',gProg);

btns{1}= xreguicontrol('parent',hFig,...
	'style','pushbutton',...
	'string','OK',...
	'enable','off',...
	'callback',{@i_OK,udh});
btns{2}= xreguicontrol('parent',hFig,...
	'style','pushbutton',...
	'string','Cancel',...
	'callback',{@i_Cancel,udh});
btns{3}= mv_helpbutton(hFig,'xreg_MLEsetup');
MLEObj.MainBtns= btns;

f{4}= xreggridlayout(hFig,...
   'elements',[{[]} btns ],...
	'dimension',[1 4],...
	'correctalg','on',...
	'colsizes',[-1 80 80 80 ],...
	'border',[0 0 0 0],...
   'gap',10);



fmain= xreggridlayout(hFig,...
   'elements',f,...
	'dimension',[4 1],...
	'correctalg','on',...
	'rowsizes',[30 140 -1 25 ],...
	'border',[10 10 10 10],...
   'gap',10);
set(fmain,'visible','on');
h.LayoutManager=fmain;

MLEObj.OldMdev= mdev;
MLEObj.node= address(mdev);
MLEObj.hasRun=0;
set(udh,'userdata',MLEObj);

set(hFig,'windowstyle','modal','visible','on');
setValues(mdev,MLEObj);


function setValues(mdev,MLEObj);

TS= BestModel(mdev);
modes= mle_modes(mdev);
if isempty(modes) | length(modes)==2
	
	modes(2)= 1;
	Y= getdata(mdev,'Y');
	if ngfactors(TS)>5 | size(Y,3)>100
		% Expectation Maximimisation
		modes(3)= 2;
		modes(4)= 1e-3;
	else
		% Quasi Newton
		modes(3)= 1;
		modes(4)= 1e-6;
	end

	mdev.MLE.Modes= modes;
	pointer(mdev);
end
% Initial Value
if ismle(TS)
	set(MLEObj.InitVal,'value',1);
else
	set(MLEObj.InitVal,'value',0,'enable','off');
end
set(MLEObj.PredMode,'value',modes(2));
set(MLEObj.CovAlg,'value',modes(3));
set(MLEObj.TolFun,'string',modes(4),'userdata',modes(4));
if modes(3)>=2
	set(MLEObj.ProgAxes,'visible','on')
else
	set(MLEObj.ProgAxes,'visible','off')
end
if modes(3)>=3
	set(MLEObj.AlgOpts,'enable','on')
else
	set(MLEObj.AlgOpts,'enable','off')
end


function i_Start(h,evt,udh)

MLEObj= get(udh,'userdata');
fh= get(udh,'parent');
set(fh,'pointer','custom','pointershapecdata',backbusyptr);


global status
status=0;

p= MLEObj.node;
mdev= p.info;

set(MLEObj.info,'string','Calculating MLE');

CovAlg= get(MLEObj.CovAlg,'value');
TolFun= get(MLEObj.TolFun,'userdata');
PredMode= get(MLEObj.PredMode,'value');
InitVal= get(MLEObj.InitVal,'value');

mdev.MLE.Modes= [InitVal PredMode CovAlg TolFun];


delete(get(MLEObj.ProgAxes,'children'))

btns= [MLEObj.Ctrls{1} MLEObj.aCtrls{:} MLEObj.MainBtns{:}];
set(btns,'enable','off');
set(MLEObj.Ctrls{2},'enable','on');
%Start MLE process
warn_status=warning;
warning off;

if CovAlg<=2
   switch CovAlg
   case 1
      CovAlg= 'mlelin';
   case 2
      CovAlg= 'mle_ExpMaxim';
   end
   if InitVal
      InitVal= 'mle';
   else
      InitVal= 'univariate';
   end	
   
   
   try
      mdev=mle(mdev,InitVal,CovAlg,TolFun,{MLEObj.ProgAxes,MLEObj.info},PredMode);
      MLEObj.hasRun=1;
   end
else
   [mdev,OK]= LinearisedAnalysis(mdev,MLEObj);
   MLEObj.hasRun= MLEObj.hasRun | OK;
end

if MLEObj.hasRun
   s=statistics(mdev);
   set(MLEObj.info,'string',sprintf('Two-Stage RMSE= %g',s(2)));
   % enable the OK button
   set(MLEObj.MainBtns{1},'enable','on');
end
set(udh,'userdata',MLEObj)
warning(warn_status);
% MLE has now stopped
set(btns,'enable','on');
set(MLEObj.Ctrls{2},'enable','off');
set(fh,'pointer',get(0,'DefaultFigurePointer'));


%--------------------------------------------------------------
% Stop MLE Optimisation half way through
%--------------------------------------------------------------
function i_Stop(src,null)

global status OPT_STOP
status=1;
OPT_STOP=1;

%--------------------------------------------------------------
% i_TolFun - changes default tolerances when algorihms change
%--------------------------------------------------------------
function i_ChangeAlg(h,evt,udh)

MLEObj= get(udh,'userdata');


switch get(MLEObj.CovAlg,'value')
case 1
   % QN 
	set(MLEObj.ProgAxes,'visible','off')
   set(MLEObj.TolFun,'string',1e-6,'userdata',1e-6);
   set(MLEObj.AlgOpts,'enable','off');
case 2
   % Expectation Maximisation
	set(MLEObj.ProgAxes,'visible','on')
   set(MLEObj.TolFun,'string',1e-3,'userdata',1e-3);
   set(MLEObj.AlgOpts,'enable','off');
case 3
	set(MLEObj.ProgAxes,'visible','on')
   set(MLEObj.TolFun,'string',1e-3,'userdata',1e-3);
   set(MLEObj.AlgOpts,'enable','on');
   
   mdev= MLEObj.node.info;
   
   TS= BestModel(mdev);

   [om,OK] = GLSfit(TS);
   if OK
      set(TS,'fitalg',om);
      bind= BMIndex(mdev);
      mdev.TwoStage{bind}= TS;
      xregpointer(mdev);
   end
   
 
end


function i_OK(h,evt,udh)

MLEObj= get(udh,'userdata');
mbH= MBrowser;
p= MLEObj.node;
if MLEObj.hasRun
	if p==mbH.CurrentNode;
		mbH.ViewNode;
		mbH.doEnableStatus;
		mbH.listview;
	end
	mbH.doDrawTree(p);
	mbH.doDrawText;
	mbH.doDrawIcons;
end
delete(get(udh,'parent'));
figure(mbH.Figure);


function i_Cancel(h,evt,udh)

MLEObj= get(udh,'userdata');
mbH= MBrowser;
p= MLEObj.node;


if MLEObj.hasRun
	mdev= MLEObj.OldMdev;
	BestModelIndex = BMIndex(mdev);
	[mdev,msg]= mle_best(mdev,BestModelIndex==2);
    if ~isempty(msg)
        hFig= msgbox(msg,...
            'Model Selection','modal');
        uiwait(hFig);
    end
	mdev= makemlerf(mdev);
	mbH.doDrawIcons;
end
if p==mbH.CurrentNode;
	mbH.ViewNode;
	mbH.doEnableStatus;
	mbH.listview;
end
delete(get(udh,'parent'));
if mbH.GUIExists
	figure(mbH.Figure);
end



function i_ChangeOpts(h,evt,udh)

MLEObj= get(udh,'userdata');
mdev= info(MLEObj.node);

TS= BestModel(mdev);
[TS,OK]= gui_fitoptions(TS);
if OK
   mdev.TwoStage{BMIndex(mdev)}= TS;
   xregpointer(mdev);
end
