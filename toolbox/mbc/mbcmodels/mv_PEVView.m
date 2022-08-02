function varargout= mv_PEVView(Action,varargin)
% MV_PEVVIEW Prediction Error Variance Graphical Viewer 
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.9.2.6 $  $Date: 2004/04/20 23:19:03 $


hFig= mvf('mvPEVView');
if ~isempty(hFig)
   ptr= get(hFig,'pointer');
   set(hFig,'pointer','watch');
   drawnow
end

switch lower(Action)
case 'create'
   varargout{1}=i_Create(varargin{:});
case 'close'
   % Figure is deleted when base model is changed or on Exit Main GR
   fh= findobj(allchild(0),'flat','Tag','mvPEVView');
   delete(fh(1));
   fh= findobj(allchild(0),'flat','tag','mvOptM');
   if ~isempty(fh)
      delete(fh(1));
   end
case 'plot'
   i_Plot(varargin{:});
%case 'export'
%   i_Export;
case 'replay'
   i_Replay;
case 'exclusive'
   i_Exclusive(varargin{:});
case 'plotstyle'
   i_PlotStyle;
case 'maxpev'
   i_MaxPEV;
case 'meanpev'
   i_MeanPEV;
case 'calcopt'
   i_Optimality(gcbf);
case 'startgopt'
   i_StartGOpt
case 'update'
   i_Update(varargin{:});
case 'envelope'
   i_Envelope;
case 'numstep'
   i_NumSteps;
case 'constraints'
   i_Plot(gcbf);
case 'surfplot'
   i_SurforCont(gcbf);
case 'resize'
   i_Resize;
case 'print'
   i_Print(gcbf);
end
if ~isempty(hFig) & ishandle(hFig)
   set(hFig,'pointer',ptr);
end

%-------------------------------------------------------------------
% SUBFUNCTION i_Create
%-------------------------------------------------------------------
function hFig=i_Create(m,X, bdryModel )

if nargin == 1 || isempty( X ),
   des= m;
   if isoptimcapable(des)
      des= InitStore(des);
   end
   m= model(des);
   X= factorsettings(des);
else
   des=[];
end

if nargin < 3,
    bdryModel = [];
end

% Find any other DialUp Figures to determine defaults
hFig= findobj(allchild(0),'flat','Tag','mvPEVView');
if ~isempty(hFig);
   hFig=hFig(1);
   ud= get(hFig,'userdata');
   if nfactors(ud.Model)== nfactors(m)
      i_Update(hFig,m,X,des);
      figure(hFig);
      return
   else
      delete(hFig)
   end
end

fPos= [50 50 850 600];
hMain= xregfigure('NumberTitle','off',...
   'Name',['Prediction Error Variance Viewer'],...
   'Position',fPos,...
   'Tag','mvPEVView',...
   'IntegerHandle','off',...
   'HandleVisibility','callback',...
   'menubar','none',...
   'resize','on',...
   'visible','off',...
	'renderer','zbuffer',...
   'PaperPositionMode','auto',...
   'Color',get(0,'DefaultUIControlBackGroundColor'),...
   'CloseRequestFcn',[mfilename,'(''close'',gcbf)'],...
   'DefaultAxesFontSize',8,...
   'DefaultTextFontSize',8); 
hMain.MinimiseResources='on';
hMain.MinimumSize = [720 510];
hFig = double(hMain);

xregpersistfigpos(hFig);
xregmoveonscreen(hFig);

bgc= get(hFig,'color');
labels= get(m,'symbol');

%% ============ set up layouts ====================
listTitle = xreguicontrol(hFig,...
   'style','text',...
   'horizontalalignment','left',...
   'fontweight','bold',...
   'string','Input factors:',...
   'visible','off');

%% listctrl
bl_listCtrl = xregborderlayout(hFig,...
   'packstatus','off',...
   'visible','off',...
   'border',[0 0 0 0]);

hnd.lhsPane = xreggridbaglayout(hFig);

%% the axis factors
hnd.factorsPane = xreggridlayout(hFig);
%% together with axis (eventually) in center
hnd.rhsPane = xregborderlayout(hFig,...
   'south',hnd.factorsPane,...
   'innerborder',[60 100 30 30]);
%% the whole dial-up display
hnd.splitPane = xregborderlayout(hFig,...
   'border',[10 10 10 10],...
   'west',hnd.lhsPane,...
   'center',hnd.rhsPane,...
   'innerborder',[280 0 0 0]);
hnd.mainPane = xregborderlayout(hFig,...
   'center',hnd.splitPane);

%% make a LISTCTRL object
hnd.listCtrl = xreglistctrl(hFig,...
   'visible','on',...
   'cellborder',2,...
   'border',4,...
   'cellheight',18);
set(bl_listCtrl,'center',hnd.listCtrl);

%% ------------------------------------- 
%%      Factor Selectors
%% ------------------------------------- 
hnd.factor(1)=xreguicontrol('style','popupmenu',...
   'parent',hFig,...
   'string',' ',...
   'backgroundcolor','w',...
   'visible','on',...
   'value',1,...
   'tag','1');
hnd.text(1)=xreguicontrol('style','text',...
   'parent',hFig,...
   'position',[0 0 90 15],...
   'string','X-axis factor:',...
   'fontweight','bold',...
   'backgroundcolor',bgc,...
   'visible','on',...
   'userdata',{});
hnd.factor(2)=xreguicontrol('style','popupmenu',...
   'parent',hFig,...
   'string',' ',...
   'value',2,...
   'backgroundcolor','w',...
   'visible','off',...
   'userdata',0,...
   'tag','2');
hnd.text(2)=xreguicontrol('style','text',...
   'parent',hFig,...
   'position',[0 0 90 15],...
   'string','Y-axis factor:',...
   'fontweight','bold',...
   'backgroundcolor',bgc,...
   'visible','off',...
   'userdata',{});
hnd.factor(3)=xreguicontrol('style','popupmenu',...
   'parent',hFig,...
   'string',' ',...
   'value',3,...
   'backgroundcolor','w',...
   'visible','off',...
   'tag','3');
hnd.text(3)=xreguicontrol('style','text',...
   'parent',hFig,...
   'position',[0 0 90 15],...
   'string','Time factor:',...
   'fontweight','bold',...
   'backgroundcolor',bgc,...
   'visible','off',...
   'userdata',{});
%% put names of Input Controls into factor lists
set(hnd.factor,'string',labels);

gl1=xreggridlayout(hFig,'dimension',[2,1],'correctalg','on',...
   'elements',{hnd.text(1),hnd.factor(1)},'rowsizes',[20 25],'gapy',3);
gl2=xreggridlayout(hFig,'dimension',[2,1],'correctalg','on',...
   'elements',{hnd.text(2),hnd.factor(2)},'rowsizes',[20 25],'gapy',3);
gl3=xreggridlayout(hFig,'dimension',[2,1],'correctalg','on',...
   'elements',{hnd.text(3),hnd.factor(3)},'rowsizes',[20 25],'gapy',3);

set(hnd.factorsPane,'correctalg','on','dimension',[3 5],'gapx',20,...
   'colsizes',[-1 90 90 90 -1],...
   'rowsizes',[55 45,-1],...
   'elements',{[],[],[],[],gl1,[],[],gl2,[],[],gl3,[],[],[],[]});

nf= nfactors(m);
set(hnd.factor(1),'callback',[mfilename,'(''exclusive'',gcbf,1)']);
if nf>=2
   set(hnd.factor(2),'callback',[mfilename,'(''exclusive'',gcbf,2)']);
end
if nf>=3
   set(hnd.factor(3),'callback',[mfilename,'(''exclusive'',gcbf,3)']);
end
%% ------------------------------------- 
%%      END Factor Selectors
%% ------------------------------------- 

%% SEE WHICH PLOTS WILL BE POSSIBLE
if nf<2
   DisplayTypes= {'2-D plot'};
   PlotVal=1;
elseif nf<3
   DisplayTypes= {'2-D plot','Surface','Contour plot'};
   PlotVal=2;
else
   DisplayTypes= {'2-D plot','Surface','Contour plot','Movie'};
   PlotVal=2;
end

%% GENERAL PLOT CONTROLS
hnd.envText=xreguicontrol('parent',hFig,...
   'pos',[1 1 60 15],...
   'style','text',...
   'horizon','left',...
   'value',0,...
   'string','Clipping envelope = ',...
   'BackgroundColor',bgc);
hnd.Envelope=xreguicontrol('parent',hFig,...
   'pos',[1 1 30 18],...
   'style','edit',...
   'horizon','left',...
   'value',0,...
   'string','1',...
   'userdata',1,...
   'callback',[mfilename,'(''envelope'')'],...
   'BackgroundColor','w');
hnd.Clip=xreguicontrol('parent',hFig,...
   'pos',[1 1 70 15],...
   'style','check',...
   'horizon','left',...
   'value',0,...
   'string','Clip plot',...
   'callback',[mfilename,'(''plot'')'],...
   'BackgroundColor',bgc);
hnd.Constraints=xreguicontrol('parent',hFig,...
   'pos',[1 1 70 15],...
   'style','check',...
   'horizon','left',...
   'value',0,...
   'string','Apply constraints',...
   'callback',[mfilename,'(''Constraints'')'],...
   'BackgroundColor',bgc);
hnd.BoundaryModel=xreguicontrol('parent',hFig,...
   'pos',[1 1 70 15],...
   'style','check',...
   'horizon','left',...
   'value',0,...
   'string','Apply boundary model',...
   'callback',[mfilename,'(''constraints'')'],...
   'BackgroundColor',bgc);

%       [],hnd.Clip,hnd.Constraints,[],...
%       [],[],[],[],...
%       [],hnd.envText,[],[],...
%       [],hnd.Envelope,[],[]},...
      
hnd.genControls = xreggridbaglayout(hFig,...
   'dimension',[5,4],...
   'mergeblock', {[3, 3], [1, 4]}, ...
   'mergeblock', {[4, 4], [1, 4]}, ...
   'elements',{ ...
      [], [], [], []; ...
      hnd.Clip, [], hnd.envText, hnd.Envelope; ...
      hnd.Constraints, [], [], []; ...
      hnd.BoundaryModel, [], [], []; ...
      [], [], [], []}, ...
   'correctalg','on',...
   'gap',5,...
   'rowsizes',[-1 18 18 18 -1],...
   'colsizes',[100 -1 100 30]);

%% LISTBOX FOR DISPLAYTYPE
hnd.dispType = xreguicontrol('parent',hFig,...
   'pos',[1 1 300 80],...
   'style','listbox',...
   'visible','on',...
   'string',DisplayTypes,...
   'BackgroundColor','w',....
   'value',PlotVal,...
   'callback',[mfilename,'(''PlotStyle'')']);

%% SPECIFIC BUTTONS IN CARD LAYOUT
udv.V=[];
udv.labels=1;
udv.fill=0;

hnd.Contour= xreguicontrol('parent',hFig,...
   'pos',[1 1 70 25],...
   'visible','off',...
   'style','push',...
   'userdata',udv,...
   'string','Contours...',...
   'callback',['mv_ContourValues(''create'',gcbf,''',mfilename,''')']);

if ~isempty(des) & numConstraints(des)>0
   set(hnd.Constraints,'value',1);
   if PlotVal==2
      udv.V=[];
      udv.labels=0;
      udv.fill=1;
      set(hnd.Contour,'userdata',udv,'visible','on');
%      set(hnd.GridSize,'string',100,'userdata',100);
   end
else
   set(hnd.Constraints,'enable','off');
end

% Check for a boundary model and enable or disable check box for clipping
% to the boundary model
if isempty( bdryModel ),
    set(hnd.BoundaryModel,'enable','off');
else
    set(hnd.BoundaryModel,'enable','on');
end

hnd.Replay= xreguicontrol('parent',hFig,...
   'pos',[1 1 70 25],...
   'visible','off',...
   'style','push',...
   'string','Replay',...
   'callback',[mfilename,'(''Replay'')']);

frameps.text = xreguicontrol('style','text',...
   'string','Frame/sec',...
   'visible','off',...
   'horizontalalignment','left',...
   'parent',hFig);
hnd.framePS=xregGui.clickedit(hFig,...
   'visible','off',...
   'position',[1 1 50 25],...
   'min',1,...
   'max',20,...
   'value',2,...
   'dragging','off',...
   'clickincrement',1);


%% card layout for contour, movie replay
hnd.controlsCard = xregcardlayout(hFig,...
   'numcards',4,...
   'currentcard',PlotVal);

%% FRAME FOR LISTBOX & CARDS
hnd.plotType = xregborderlayout(hFig,...
   'center',hnd.dispType,...
   'south',hnd.controlsCard,...
   'innerborder',[0 50 0 0]);
%% frame round all of this
hnd.choiceFrame=xregframetitlelayout(hFig,...
   'title','Display type',...
   'center',hnd.plotType);

%% frame for Optimality controls
hnd.optimalityFrame = xregframetitlelayout(hFig,...
   'title','Optimality criteria');

set(hnd.lhsPane,...
   'dimension',[8,1],...
   'elements',{...
      listTitle,bl_listCtrl,[],...
      hnd.genControls,[],...
      hnd.choiceFrame,[],hnd.optimalityFrame},...
   'rowsizes',[17,-1,5,83,5,-1,10,150]); % [17,-1,5,60,5,-1,10,150]);
   


card3=xreggridlayout(hFig,...
   'correctalg','on',...
   'dimension',[3,3],...
   'colsizes',[-1 75 -1],...
   'rowsizes',[-1 25 -1],...
   'elements',{[],[],[],[],hnd.Contour,[],[],[],[]});
tempcard=xreggridlayout(hFig,...
   'correctalg','on',...
   'dimension',[3,2],...
   'rowsizes',[-1 20 -1],...
   'elements',{[],frameps.text,[],[],hnd.framePS,[]});
card4=xreggridlayout(hFig,...
   'correctalg','on',...
   'dimension',[3,5],...
   'colsizes',[-1 65 -1 110 -1],...
   'rowsizes',[-1 25 -1],...
   'elements',{[],[],[],...
      [],hnd.Replay,[],...
      [],[],[],...
      [],tempcard,[],...
      [],[],[]});

attach(hnd.controlsCard, card3, 3);
attach(hnd.controlsCard, card4, 4);

%%------------------OPTIMALITY---------------------------
hnd.Gmax = xreglistctrl(hFig,...
   'visible','on',...
   'cellborder',2,...
   'border',4,...
   'cellheight',18);
Input={xregtextinput(hFig,...
      'varname',sprintf('Factors\tGmax'),...
      'fontweight','bold',...
      'fontname','courier new',...
      'fontsize',10)};
for j=1:nf
   control = xregtextinput(hFig,...
      'varname',labels{j},...
      'fontname','courier new',...
      'fontsize',10);
   Input={Input{:}, control};
end
set(hnd.Gmax,'controls',Input);

hnd.optimality=xreguicontrol('parent',hFig,...
   'pos',[1 1 65 25],...
   'style','push',...
   'string','Calculate...',...
   'BackgroundColor',bgc,....
   'callback',[mfilename,'(''CalcOpt'')']);
buttonGrid = xreggridlayout(hFig,...
   'dimension',[1,3],...
   'elements',{[],hnd.optimality,[]},...
   'correctalg','on',...
   'colsizes',[-1 65 -1]);

hnd.DOpt=xreguicontrol('parent',hFig,...
   'pos',[1 1 100 15],...
   'style','text',...
   'horizon','left',...
   'value',0,...
   'string','D',...
   'FontName','Lucida Console',...
   'BackgroundColor',bgc);
hnd.MeanPEV=xreguicontrol('parent',hFig,...
   'pos',[1 1 100 15],...
   'style','text',...
   'horizon','left',...
   'value',0,...
   'FontName','Lucida Console',...
   'string','V',...
   'BackgroundColor',bgc);
hnd.MaxPEV=xreguicontrol('parent',hFig,...
   'pos',[1 1 100 15],...
   'style','text',...
   'FontName','Lucida Console',...
   'horizon','left',...
   'value',0,...
   'string','G',...
   'BackgroundColor',bgc);

hnd.optimGridR = xreggridlayout(hFig,...
   'dimension',[4,1],...
   'elements',{hnd.DOpt,hnd.MeanPEV,hnd.MaxPEV,buttonGrid});

hnd.optimGrid= xreggridlayout(hFig,...
   'dimension',[1,2],...
   'colratios',[3 2],...
   'gapx',10,...
   'border',[-10 0 0 0],...
   'elements',{hnd.Gmax,hnd.optimGridR});

set(hnd.optimalityFrame,'center',hnd.optimGrid);

%%------------------------- AXES ----------------------------
hnd.Axes=axes('parent',hFig,...
	'units','pixels',...
   'pos',[1 1 100 100],...
   'box','on',...
   'nextplot','replacechildren');

set(hnd.rhsPane,'center',hnd.Axes);

hnd.DispTable=[];
ud.Hand = hnd;

%% OTHER USERDATA FIELDS
ud.Movie=[];
ud.Design= des;
ud.Model=  m;
ud.BdryModel = bdryModel;
ud.DesignX= X;
ud.OldValues = invcode(m,zeros(1,nf))';
ud.OldG=[];
set(hFig,'UserData',ud)

xreg3dmenu('init')
xregwinlist(hFig);
% add help menu
mv_helpmenu(hFig,{'&PEV Viewer Help','xreg_PEVview'});

hMain.LayoutManager =  hnd.mainPane;
set(hnd.mainPane,'packstatus','on');
set(hFig,'vis','on');

%% vis on/off the factor controls then populate the listCtrl and the axes
i_PlotStyle(hFig,1);

return

%-------------------------------------------------------------------
% SUBFUNCTION i_GetValues
%-------------------------------------------------------------------
function [x,XVar,YVar,TVar]=i_GetValues(hFig)
ud = get(hFig,'userdata');
h=ud.Hand;

x= get(h.listCtrl,'Values');
%% returns cell array, each celement is the Input factor vector
XVar = get(h.factor(1),'Value');
YVar = get(h.factor(2),'Value');
TVar = get(h.factor(3),'Value');

return

%-------------------------------------------------------------------
% SUBFUNCTION i_Controls (making/re-making the input controls)
%-------------------------------------------------------------------
function i_Controls(hFig,Start)

ud = get(hFig,'userdata');
h = ud.Hand;
m = ud.Model;

DispType= get(h.dispType,'value');

[x,XVar,YVar,TVar]=i_GetValues(hFig);

% at startup
if nargin>1 & Start
   x = cell(nfactors(m),1);
end

switch DispType
case 1
   % 2-D plot
   YVar=[];
   TVar=[];
case {2,3}
   % surface, contour
   TVar=[];
end

%% CHECK if factor selectors have come visible ON
%% maybe they have same vals as other selectors
numActive = length([XVar,YVar,TVar]);
factors = get(h.factor,'Value');
if length(factors)>1, factors = [factors{:}]; end;
factors = factors(1:numActive);
if length(factors)~= length(unique(factors))
   i_Exclusive(hFig,3);
   [x,XVar,YVar,TVar]=i_GetValues(hFig);
   factors = [XVar YVar TVar]; factors = factors(1:numActive);
end

% work out default values
c= get(m,'code');
if ~isempty(c)
   L= [c.min];
   U= [c.max];
else
   L= -ones(size(x));
   U= ones(size(x));
end

%[L,U]= range(m);

%% =============================================================
%%                MAKING NEW CONTROLS
%% =============================================================
labels= get(m,'symbol');
%NewVal ={};
NewControls = {};
for inputNum = 1:nfactors(m)
    if ~any(inputNum==factors) %% if inputNum NOT any of the factors
        if length(x{inputNum})~=1
            %        NewVal= {NewVal{:},(L(inputNum)+U(inputNum))/2};
            tmp = xregclickinput(hFig,...
                'name',labels{inputNum},...
                'min',L(inputNum),'max',U(inputNum),...
                'clickincrement',10^(floor(log10(abs(U(inputNum) - L(inputNum))))-1));
            set(tmp,'value',(L(inputNum)+U(inputNum))/2);
            NewControls = [NewControls, {tmp}];
        else
            %         NewVal= {NewVal{:},x{inputNum}};
            tmp = xregclickinput(hFig,...
                'name',labels{inputNum},...
                'min',L(inputNum),'max',U(inputNum),...
                'clickincrement',10^(floor(log10(abs(U(inputNum) - L(inputNum))))-1));
            set(tmp,'value',x{inputNum});
            NewControls = [NewControls,{tmp}];
        end
    elseif isempty(x{inputNum}) |  length(x{inputNum})==1
        %% DispType=2=table can have size of 1
        if ~isempty(TVar) & inputNum==TVar
            N= 5; %%num movie frames
        else
            N=21;
        end
        tmp = xregrangeinput(hFig,'name',labels{inputNum},...
            'value',linspace(L(inputNum),U(inputNum),N));
        NewControls = [NewControls,{tmp}];
    else %%everything is okay!
        tmp = xregrangeinput(hFig,'name',labels{inputNum},...
            'value',x{inputNum});
        NewControls = [NewControls,{tmp}];
    end
end
set(h.listCtrl,'controls',NewControls);
set(h.listCtrl,'callback',@i_CheckVal);

% now display the plot
i_Plot(hFig);

%-------------------------------------------------------------------
% SUBFUNCTION i_Export
%-------------------------------------------------------------------
%function i_Export%%

%ud = get(gcbf,'UserData');
%if ishandle(ud.Hand.Axes)
%   sh= findobj(ud.Hand.Axes,'type','surface');
%%   if isempty(sh)
%      % This is a 2D plot
%      Y=get(ud.Hand.Axes,'UserData');
%   else
%      % Table is in surface plot 
%      Y= get(sh,'ZData');
%   end
%elseif ~isempty(ud.Hand.DispTable)
%   % get values from table
%   Y= ud.Hand.DispTable.Numbers;
%else
%   errordlg('There is no table defined','Export','modal');
%   return
%%end

%assignin('base','Y',Y);
%msgbox('Table written to base workspace as Y','Export','modal');


%-------------------------------------------------------------------
% SUBFUNCTION i_Exclusive (exclusivity for factor controls)
%-------------------------------------------------------------------
function i_Exclusive(hFig,factorNum);
%% exclusive factor choice from popupmenu selectors
ud= get(hFig,'UserData');
h = ud.Hand;

facs = get(h.factor,'Value');
if length(facs)>1, facs = [facs{:}]; end;
%% what if < 3 inputs??
numControls = size(h.listCtrl);
if numControls < length(facs)
   facs = facs(1:numControls);
end

if nargin ==2 & length(unique(facs))~=length(facs)
   %% h.factor(factorNum) is the one just changed
   %% keep this the same and change another factor
   change = setdiff(find(facs==facs(factorNum)),factorNum);
   numEls = length(get(h.factor(change(1)),'string'));
   freeEls = setdiff([1:numEls],facs);
   if ~isempty(freeEls)
      set(h.factor(change),'value',freeEls(1));
   end
elseif length(unique(facs))~=length(facs)
   %% If visible on has brought into play a control...must be YVar or TVar
   if facs(2)==facs(1)
      numEls = length(get(h.factor(2),'string'));
      freeEls = setdiff([1:numEls],facs);
      if ~isempty(freeEls)
         set(h.factor(2),'value',freeEls(1));
      end
   elseif length(unique(facs))~=length(facs) %% change TVar
      numEls = length(get(h.factor(3),'string'));
      freeEls = setdiff([1:numEls],facs);
      if ~isempty(freeEls)
         set(h.factor(3),'value',freeEls(1));
      end
   end
end

%% now redraw input controls
i_Controls(hFig);

return

%-------------------------------------------------------------------
% SUBFUNCTION i_PlotStyle (called by listBox: vis on/off for factor controls)
%-------------------------------------------------------------------
function i_PlotStyle(hFig,Start)
%% set factors vis on vis off, then go make new controls i_Controls

if ~nargin
   hFig= gcbf;
end

ud= get(hFig,'UserData');
h = ud.Hand;

NewType= get(h.dispType,'value');
set(h.controlsCard,'currentcard',NewType);

set([h.factor(1),h.text(1)],'visible','on');   

%% switch on/off print menu (off for movie)
printMenuH = findobj(ud.Hand.File,'tag','printmenu');

switch NewType
case 1
   set([h.factor(2),h.text(2)],'visible','off');   
   set([h.factor(3),h.text(3)],'visible','off');
   set(printMenuH,'enable','on');
   xreg3dmenu('2dmenus');
case {2,3}
   set([h.factor(2),h.text(2)],'visible','on');   
   set([h.factor(3),h.text(3)],'visible','off');   
   set(printMenuH,'enable','on');
   if NewType==2
      xreg3dmenu('3dmenus');
   else
      xreg3dmenu('2dmenus');
   end
case 4
   set([h.factor(2),h.text(2)],'visible','on');   
   set([h.factor(3),h.text(3)],'visible','on');
   %% switch off print menu
   set(printMenuH,'enable','off');
   xreg3dmenu('3dmenus');
end
set(hFig,'UserData',ud);

%% now set up correct input controls
%% this will call i_Plot
if nargin>1
   i_Controls(hFig,Start);
else
   i_Controls(hFig);
end

return

%-------------------------------------------------------------------
% SUBFUNCTION i_Plot
%-------------------------------------------------------------------
function i_Plot(hFig);

if nargin==0
   hFig= gcbf;
end
ud= get(hFig,'UserData');
h = ud.Hand;

PlotStyle= get(h.dispType,'value');

[Values,XVar,YVar,TVar] = i_GetValues(hFig);

c= get(ud.Model,'code');
if ~isempty(c)
   MinVals= [c.min];
   MaxVals= [c.max];
else
   MinVals= -ones(size(Values));
   MaxVals= ones(size(Values));
end

labels = get(h.listCtrl,'name');
Xlab= labels{XVar};

mv_rotate3d(ud.Hand.Axes,'off')
xregorbit3d(hFig,'off');
set(ud.Hand.Axes,'xlimmode','auto','ylimmode','auto')

%% contour for clipping and clip yes/no
EnvVal= get(h.Envelope,'userdata');
Clip= get(h.Clip,'value');

if ishandle(h.Light)
   [ud.Setup.viewaz,ud.Setup.viewel]=view(h.Axes);
end
ud.Setup.CurView= get(h.Axes,'view');

if ~isempty(ud.Design)
   ok=rankcheck(ud.Design) & isoptimcapable(ud.Design);
else
   ok=1;
end

if ok
   switch PlotStyle
   case 1
      if ishandle(h.Light)
         ud.Setup.lightpos=get(h.Light,'pos');
      end
      [PEV,X,Xg] = pevgrid(ud.Design,Values,1);
      if Clip
         PEV(PEV>EnvVal)=NaN;
      end
      delete(get(h.Axes,'children'));
      reset(h.Axes);
      Constr= get(h.Constraints,'value');
      if Constr & ~isempty(constraints(ud.Design));
         c= reset(constraints(ud.Design));
         [c,in]= eval(c,Xg);
         PEV(~in)=NaN;
      end
      
      plot(Values{XVar},squeeze(PEV),'parent',h.Axes);
      set(h.Axes,'xgrid','on','ygrid','on');
		set(get(h.Axes,'xlabel'),'string',Xlab,'interpreter','none')
		set(get(h.Axes,'ylabel'),'string','Predicted Error Variance')
      ud.Movie = [];
      set(h.Axes,'box','on');
      if ud.Setup.viewaz~=0 | ud.Setup.viewel~=90
         view(h.Axes,2);
         [ud.Setup.viewaz,ud.Setup.viewel]=view(h.Axes);
         ud.Setup.CurView= get(h.Axes,'view');
      end
      
   case {2,3}
      Ylab= labels{YVar};
      
      [PEV,X,Xg] = pevgrid(ud.Design,Values,1);
      Col= 'w';
      PEV2=PEV;

      % Compute the boundary (if required)
      designCon = constraints( ud.Design );
      useDesignCon = get( h.Constraints,   'value')  && ~isempty( designCon );
      useBdryModel = get( h.BoundaryModel, 'value' ) && ~isempty( ud.BdryModel );
      if useDesignCon && useBdryModel,
          % Both constraints
          designCon = reset( designCon );
          b1 = constraindist( designCon, Xg );
          b2 = constraindist( ud.BdryModel, Xg );
          bdry = max( b1, b2 );
          bdry = reshape( bdry, size( PEV2 ) );
      elseif useDesignCon,
          % Design constraint
          designCon = reset( designCon );
          bdry = constraindist( designCon, Xg );
          bdry = reshape( bdry, size( PEV2 ) );
      elseif useBdryModel,
          % Boundary constraint
          bdry = constraindist( ud.BdryModel, Xg );
          bdry = reshape( bdry, size( PEV2 ) );
      else
          % NO constraints
          bdry = [];
      end

      if ishandle(h.Light)
         ud.Setup.lightpos=get(ud.Hand.Light,'pos');
      end
      if PlotStyle==2
         set(h.Axes,'zlimmode','auto')
         ud=i_SurfacePlot(X{XVar},X{YVar},PEV2,ud,EnvVal,Clip,bdry);
			set(get(h.Axes,'xlabel'),'string',Xlab,'interpreter','none')
			set(get(h.Axes,'ylabel'),'string',Ylab,'interpreter','none')
			set(get(h.Axes,'zlabel'),'string','Predicted Error Variance')

         if ud.Setup.viewaz==0 & ud.Setup.viewel==90
            view(h.Axes,3);
            [ud.Setup.viewaz,ud.Setup.viewel]=view(h.Axes);
            ud.Setup.CurView= get(h.Axes,'view');
         end
         
         set(hFig,'userdata',ud);
      else
         if ishandle(h.Light)
            ud.Setup.lightpos=get(h.Light,'pos');
         end
         delete(get(h.Axes,'children'));
         reset(h.Axes);
         repack(ud.Hand.mainPane)
         
         udv= get(h.Contour,'userdata');
         V= udv.V;
         if isempty(V)
            hp=plot(squeeze(PEV2),'parent',h.Axes);
            V= get(h.Axes,'YTick');
            if length(V)<10;
               Vd=V(2)-V(1);
               V= V(1):Vd/5:V(end);
            end
            delete(hp);
         end
         if Clip & length(V)>1
            V(V>EnvVal)=[];
         end
         if ~isempty(V) & any(isfinite(PEV2(:)));
            
            set(hFig,'currentaxes',h.Axes);
            EnvCol= 'k-';
            if udv.fill
               if ~useDesignCon & ~Clip
                  EnvCol= 'w-';
               end
               set(hFig,'handlevisibility','on');
               axes(h.Axes);
               [c,hc]=contourf(squeeze(X{XVar}),squeeze(X{YVar}),squeeze(PEV2),V);
               set(hFig,'handlevisibility','off');
            else
               set(hFig,'handlevisibility','on');
               axes(h.Axes);
               [c,hc]=contour(squeeze(X{XVar}),squeeze(X{YVar}),squeeze(PEV2),V);
               set(hFig,'handlevisibility','off');
            end
            set(ud.Hand.Axes,'xgrid','on','ygrid','on');
            
            % label contours (inline labels)
            if ~isempty(c) & udv.labels
               set(hFig,'handlevisibility','on');
               set(hFig,'currentaxes',h.Axes);
               clabel(c,hc,'color','k');
               set(hFig,'handlevisibility','off');
            else
               hvis= get(hFig,'handlevisibility');
               set(hFig,'handlevisibility','on')
               colorbar('vert','peer',h.Axes)
					set(hFig,'handlevisibility',hvis)
            end
            
         else
            EnvCol= 'k-';
            set(h.Axes,...
               'box','on',...
               'xlim',Values{XVar}([1 end]),'ylim',Values{YVar}([1 end]))
         end
         if isfinite(EnvVal) & EnvVal>0
            np=get(h.Axes,'nextplot');
            set(h.Axes,'nextplot','add');
            set(hFig,'currentaxes',h.Axes);
            set(hFig,'handlevisibility','on');
            axes(h.Axes);
            [c,hc]=contour(squeeze(X{XVar}),squeeze(X{YVar}),squeeze(PEV),[EnvVal EnvVal],EnvCol);
            set(hFig,'handlevisibility','off');
            set(hc,'linewidth',2)
            set(h.Axes,'nextplot',np,'box','on');
         end
         set(get(h.Axes,'xlabel'),'string',Xlab,'interpreter','none');
         set(get(h.Axes,'ylabel'),'string',Ylab,'interpreter','none');
         set(get(h.Axes,'title'),'string','Prediction Error Variance');
         if ud.Setup.viewaz~=0 | ud.Setup.viewel~=90
            view(h.Axes,2);
            [ud.Setup.viewaz,ud.Setup.viewel]=view(h.Axes);
            ud.Setup.CurView= get(h.Axes,'view');
         end
      end
      ud.Movie = [];
   case 4
      Ylab= labels{YVar};
      Tlab= labels{TVar};
      
      
      if ishandle(h.Light)
         ud.Setup.lightpos=get(h.Light,'pos');
      end
      % Area for Movie GetFrame
      AxesPos= get(ud.Hand.Axes,'pos');
      AxesPos(4)= AxesPos(4)*1.2;
      AxesPos(3)= AxesPos(4)*1.2;
      
      [PEV,X] = pevgrid(ud.Design,Values,1);
      PEV2=PEV;
      if Clip
         PEV2(PEV>EnvVal)=NaN;
      end
      
      s= struct('type','()','subs',{repmat({':'},length(Values),1)});
      s.subs{TVar}= 1;
      X{XVar}= subsref(X{XVar},s);
      X{YVar}= subsref(X{YVar},s);
      allh= findobj(get(h.Axes,'children'));
      lh= ud.Hand.Light;
      if ~isempty(lh)
         allh=allh(allh~=lh);
      end
      delete(allh);
      set(h.Axes,'ylimmode','auto')
      hnd= plot(PEV2(:),'parent',h.Axes);
      zlim=get(h.Axes,'ylim');
      set(h.Axes,'zlimmode','manual','zlim',zlim)
      delete(hnd);
      if ud.Setup.viewaz==0 & ud.Setup.viewel==90
         view(ud.Hand.Axes,3);
         [ud.Setup.viewaz,ud.Setup.viewel]=view(ud.Hand.Axes);
         ud.Setup.CurView= get(h.Axes,'view');
      end
      
      for i=1:length(Values{TVar})
         s.subs{TVar}= i;
         PEVt= subsref(PEV,s);
         [ud,hs]=i_SurfacePlot(X{XVar},X{YVar},PEVt,ud,EnvVal,Clip);
			set(get(ud.Hand.Axes,'xlabel'),'string',Xlab,'interpreter','none')
			set(get(ud.Hand.Axes,'ylabel'),'string',Ylab,'interpreter','none')
			set(get(ud.Hand.Axes,'zlabel'),'string','Predicted Error Variance')
			
			tstr= sprintf('%s=%4.2f',Tlab,Values{TVar}(i));
			set(get(ud.Hand.Axes,'title'),'string',tstr)

         set(h.Axes,'zlim',zlim)
         drawnow
         % Grab frame for movie
         M(i)= getframe(hFig,AxesPos);
      end
      
      % Save Movie if more than one time value
      ud.Movie = M;
   end
   view(ud.Hand.Axes,ud.Setup.CurView);
else
   delete(get(h.Axes,'children'));
   reset(h.Axes);
   % add a text item explaining reason for display problem
   text(0.5,0.5,{'PEV is unavailable; either the design matrix is rank-deficient,';...
         'or the current model does not support PEV calculations.'},...
      'parent',h.Axes,'horizontalalignment','center')  
end

set(hFig,'UserData',ud);





%-------------------------------------------------------------------
% SUBFUNCTION i_SurfacePlot
%-------------------------------------------------------------------
function [ud,hs]=i_SurfacePlot(X,Y,PEV,ud,EnvVal,PevClip,Bdry)
lh= ud.Hand.Light;
%if ~isempty(lh)
%   Lprops= set(lh);
%   Lprops= [fieldnames(Lprops)';get(lh(1),fieldnames(Lprops))];
%   [az,el]=;
%end

Col= 'w';
if PevClip,
    Col = 'k';
end

BdryClip = nargin >= 7 && ~isempty( Bdry );

Clip = BdryClip | PevClip;

if BdryClip && PevClip,
    pevBdry = PEV - EnvVal;
    bdryRange = max( Bdry(:) ) - min( Bdry(:) );
    pevRange = max( pevBdry(:) ) - min( pevBdry(:) );
    Bdry = max( Bdry/bdryRange, pevBdry/pevRange );
elseif PevClip,
    Bdry = PEV - EnvVal;
elseif BdryClip
    Bdry = Bdry;
end

PEV2 = PEV;
if Clip,
    PEV2(Bdry>0) = NaN;
end

hFig= get(ud.Hand.Axes,'parent');
np=get(ud.Hand.Axes,'nextplot');
delete(get(ud.Hand.Axes,'child'));

if Clip,
    hs = xregsurfaceb( squeeze( X ), squeeze( Y ), squeeze( PEV ), ...
       squeeze( Bdry ), squeeze( PEV ), ...
       'FaceColor','interp',...
       'EdgeColor','none',...
       'FaceLighting','phong','BackFaceLighting','reverselit',...
       'clip','on',...
       'parent',ud.Hand.Axes);
else
    hs=surf(squeeze(X),squeeze(Y),squeeze(PEV),squeeze(PEV),...
       'FaceColor','interp',...
       'EdgeColor','none',...
       'FaceLighting','phong','BackFaceLighting','reverselit',...
       'clip','on',...
       'parent',ud.Hand.Axes);
end

set(ud.Hand.Axes,'nextplot','add');
set(hFig,'currentaxes',ud.Hand.Axes);
if any(isfinite(PEV2(:)))
   set(hFig,'handlevisibility','on');
   axes(ud.Hand.Axes);
   [c,hc]=contour3(squeeze(X),squeeze(Y),squeeze(PEV2),[EnvVal EnvVal],'w-');
   set(hc,'linewidth',2,'color',Col);
   set(hFig,'handlevisibility','off');
end
set(ud.Hand.Axes,'nextplot',np);
if isempty(lh)
   % try to guess some positions for a light
   lims= get(ud.Hand.Axes,{'xlim','ylim','zlim'});
   ud.Setup.lightpos=[lims{1}(1),mean([lims{2}(1),lims{2}(2)]),lims{3}(2)];
   ud.Hand.Light=light('parent',ud.Hand.Axes,'pos',ud.Setup.lightpos,'col','w','style','local');
else
   % Use Previous light properties
   ud.Hand.Light=light('parent',ud.Hand.Axes,'pos',ud.Setup.lightpos,'col','w','style','local');
end
set(hFig,'UserData',ud);
xreg3dmenu('updateplot')




%-------------------------------------------------------------------
% SUBFUNCTION i_CheckVal (call back on input controls)
%-------------------------------------------------------------------
function i_CheckVal(src, evt)
%% check if too many points requested
[x,XVar,YVar,TVar]=i_GetValues(gcbf);
numPoints = prod(cellfun('length',x));
if numPoints > 50000
    errordlg('Too many plot points requested. Please input a smaller number.',...
        'Plot error','modal');
    drawnow;
    return
end

i_Plot(gcbf);

return

%-------------------------------------------------------------------
% SUBFUNCTION i_Replay
%-------------------------------------------------------------------
function i_Replay

ud= get(gcbf,'UserData');
% replay the movie if it exists
fps = get(ud.Hand.framePS,'value');
if ~isempty(ud.Movie);
   movie(ud.Hand.Axes,ud.Movie,1,fps);
end

%-------------------------------------------------------------------
% SUBFUNCTION i_MaxPEV
%-------------------------------------------------------------------
function [X,Y]= i_MaxPEV(hFig,ud,NumPts)

ptr= get(hFig,'pointer');
set(hFig,'pointer','watch');
h = ud.Hand;

Nx= size(h.listCtrl);
ymax=0;
x0= zeros(1,Nx);
n= fix(10^(4/Nx));
x= repmat( {linspace(-1,1,n)} , 1,Nx );
[P,X,Xg]= pevgrid(ud.Design,x,0);
[dum,ind]= sort(P(:));
X= Xg(ind(end:-1:end-NumPts+1),:);
Y= P(ind(end:-1:end-NumPts+1));

for i=1:size(X,1)
   x0= X(i,:);
   
   fopts= optimset('fmincon');
   fopts= optimset(fopts,'largescale','off','display','none');
   Ub= ones(size(x0));
   [xopt,f,exitflag]=fmincon('evalpev',x0,[],[],[],[],-Ub,Ub,[],fopts,ud.Model,1);
   y=evalpev(xopt,ud.Model);
   X(i,:)= xopt(:)';
   Y(i)=y;
end
[X,ind]=unique(X,'rows');
Y= Y(ind);
[Y,ind]= sort(Y);
Y= Y(end:-1:1);
X= X(ind(end:-1:1),:);


set(hFig,'pointer',ptr);

%-------------------------------------------------------------------
% SUBFUNCTION i_MeanPEV
%-------------------------------------------------------------------
function i_MeanPEV

ud= get(gcbf,'userdata');

if get(gcbo,'value')
   mvp= MeanPredVar(ud.Model,ud.DesignX);
   set(gcbo,'string',sprintf('Mean= %5.2f',mvp));
else
   set(gcbo,'string','Mean PEV');
end   

%-------------------------------------------------------------------
% SUBFUNCTION i_Optimality
%-------------------------------------------------------------------
function hFig=i_Optimality(ParFig)

if nargin == 0
   ParFig= gcbf;
end

ud= get(ParFig,'userdata');

if ~isempty(ud.Design)
   ok=rankcheck(ud.Design) & isoptimcapable(ud.Design);
else
   ok=1;
end
if ~ok
   hFig=[];
   return
end


hFig= findobj(allchild(0),'flat','tag','mvOptM');
if isempty(hFig)
   ht= 300;
   figWidth = 290;
   hOpt= xregfigure('pos',[10 200 figWidth ht],...
      'NumberTitle','off',...
      'visible','off',...
      'name','Optimality Calculations',...
      'tag','mvOptM',...
      'IntegerHandle','off',...
      'HandleVisibility','callback',...
      'resize','off',...
      'DefaultUIControlFontName','Lucida Console',...
      'color',get(0,'DefaultUIControlBackGroundColor'),...
      'menu','none');
	hFig= double(hOpt);
    ht= ht-30;
    %% centre optimality dialog in PEV figure
    xregcenterfigure(hFig,[figWidth,ht],ParFig);

   xreguicontrol('style','text',...
      'Parent',hFig,...
      'pos',[10 ht,200 15],...
      'FontWeight','bold',...
      'String','Optimality criteria:',...
      'Horizontal','left');
   ht= ht-20;
   h(1)= xreguicontrol('style','text',...
      'Parent',hFig,...
      'string','D',...
      'pos',[20 ht,100 15],...
      'Horizontal','left');
   ht= ht-20;
   h(2)= xreguicontrol('style','text',...
      'Parent',hFig,...
      'pos',[20 ht,100 15],...
      'string','V',...
      'Horizontal','left');
   ht= ht-20;
   h(3)=xreguicontrol('style','text',...
      'Parent',hFig,...
      'pos',[20 ht,100 15],...
      'Horizontal','left',...
      'string','G');
   ht= ht-20;
   xreguicontrol('style','text',...
      'Parent',hFig,...
      'pos',[20 ht,200 15],...
      'Horizontal','left',...
      'string','Number of starting points:');
   h(4)=xreguicontrol('style','edit',...
      'Parent',hFig,...
      'pos',[210 ht,50 20],...
      'backGroundColor','w',...
      'Horizontal','left',...
      'userdata',4,'string','4',...
      'callback',[mfilename,'(''startgopt'')']);
   ht= ht-20;
   s= get(ud.Model,'symbol');
   xreguicontrol('style','text',...
      'Parent',hFig,...
      'pos',[20 ht,250 15],...
      'Horizontal','left',...
      'string',sprintf(repmat('%-6s',1,length(s)+1),'PEV',s{:}));
   ht= ht-100;
   h(5)=xreguicontrol('style','listbox',...
      'Parent',hFig,...
      'pos',[20 ht,250 100],...
      'backGroundColor','w',...
      'Horizontal','left');
   closeBtn = xreguicontrol('style','push',...
      'Parent',hFig,...
      'fontname', get(0,'defaultuicontrolfontname'),...
      'pos',[0 0 65 25],...
      'string','Close',...
      'callback','delete(gcbf)');
   helpBtn = mv_helpbutton(hFig,'xreg_pev_optimality',...
      'fontname',get(0,'defaultuicontrolfontname'));

   btnGrid = xreggridlayout(hFig,...
      'dimension',[1,4],...
      'correctalg','on',...
      'colsizes',[-1,65,65,10],...
      'gapx',7,...
      'elements',{[],closeBtn,helpBtn,[]},...
      'position',[0 10 figWidth 25]);

   set(hFig,'userdata',h,'visible','on')
else
   figure(hFig); 
   h= get(hFig,'userdata');
end

oldPtr = get(hFig,'pointer');
set(hFig,'pointer','watch');

drawnow
NumPts= get(h(4),'userdata');
if isempty(ud.Design)
   d=log(det_xtx(ud.Model))/NumTerms(ud.Model);
   mvp= MeanPredVar(ud.Model);
   [X,G]= i_MaxPEV(gcbf,ud,NumPts);
else
   d= dcalc(ud.Design);
   [mvp,tmp]= vcalc(ud.Design,1);
   [psi,tmp,X]= gcalc(ud.Design,1,'sample',NumPts);
   G=X(:,1);
   X=X(:,2:end);
end
set([h(1);ud.Hand.DOpt],'string',sprintf('D = %10.3g',d))
set([h(2);ud.Hand.MeanPEV],'string',sprintf('V = %10.3g',mvp))
set([h(3);ud.Hand.MaxPEV],'string',sprintf('G = %10.3g',G(1)))
str=num2str([G,X],'%6.2f');
set(h(5),'string',str)
X(1,:)= invcode(ud.Model,X(1,:));

%% set display of GMAX
ud.Gmax= X(1,:)'; 
labels = get(ud.Model,'symbol');
controls = get(ud.Hand.Gmax,'controls');
for i = 1:length(labels)
   set(controls{i+1},...
      'varname', [labels{i} sprintf('\t %4.1f',ud.Gmax(i)) ],...
      'fontname','courier new');
end

set(hFig,'pointer',oldPtr);
set(ParFig,'userdata',ud);

%-------------------------------------------------------------------
% SUBFUNCTION i_StartGOpt
%-------------------------------------------------------------------
function i_StartGOpt

if xregCheckIsNum('int','on','range',[1 20]);
   fh= findobj(allchild(0),'flat','tag','mvPEVView');
   ud= get(fh(1),'userdata');
   h= get(gcbf,'userdata');
   NumPts= get(h(4),'userdata');
   if isempty(ud.Design)
      [X,G]= i_MaxPEV(gcbf,ud,NumPts);
   else
      [psi,tmp,G]= gcalc(ud.Design,1,'sample',NumPts);
      X=G(:,2:end);
      G=G(:,1);
   end
   set([h(3);ud.Hand.MaxPEV],'string',sprintf('G = %10.3g',G(1)))
   str=num2str([G,X],'%6.2f');
   set(h(5),'string',str)
   X(1,:)= invcode(ud.Model,X(1,:));
   
   %% set display of GMAX
   ud.Gmax= X(1,:)'; 
   labels = get(ud.Model,'symbol');
   controls = get(ud.Hand.Gmax,'controls');
   for i = 1:length(labels)
      set(controls{i+1},...
         'varname', [labels{i} sprintf('\t %4.1f',ud.Gmax(i))],...
         'fontname','courier new');
   end
end


%-------------------------------------------------------------------
% SUBFUNCTION i_Envelope
%-------------------------------------------------------------------
function i_Envelope

if xregCheckIsNum(gcbo,'range',[0 inf]);
   i_Plot(gcbf);
end

%-------------------------------------------------------------------
% SUBFUNCTION i_Envelope
%-------------------------------------------------------------------
function  i_NumSteps

ud = get(gcbf,'userdata');
controls = get(ud.Hand.listCtrl,'controls');

str = get(ud.Hand.Step,'string');
if ~isempty(str2num(str)) & str2num(str)>=2
   val = round(str2num(str))+1;
   set(ud.Hand.Step,'userdata',num2str(val-1),'string',num2str(val -1));
   for i = 1:length(controls)
      if isa(controls{i},'xregstepinput')
         tmp=get(controls{i},'range');
         tmp2 = get(controls{i},'value');
         set(controls{i},'range',{tmp,val},'value',tmp2);
      end
   end
   i_Plot(gcbf);
else
   str = get(ud.Hand.Step,'userdata');
   set(ud.Hand.Step,'string',str);
   errordlg('Number of steps must be greater than 2','Step size error');
end
%-------------------------------------------------------------------
% SUBFUNCTION i_Update
%-------------------------------------------------------------------
function i_Update(hFig,m,x,des, bdryModel );
ud= get(hFig,'userdata');

if nargin < 5,
    bdryModel = [];
end

if nargin >= 4
   if isoptimcapable(des)
      des= InitStore(des);
   end
   ud.Design= des;
   ud.Model= model(des);
   ud.DesignX= factorsettings(des);
else
   ud.Design= [];
   ud.Model= InitStore(m,x);
   ud.DesignX= x;
end   
ud.Movie=[];
ud.BdryModel = bdryModel;

if isfield(ud,'Constraints')
   if ~isempty(des) & numConstraints(des)>0
      set(ud.Constraints,'enable','on');
   else
      set(ud.Constraints,'enable','off','value',0);
   end
end
if isfield(ud,'BoundaryModel')
   if ~isempty( bdryModel )
      set(ud.BoundaryModel,'enable','on');
   else
      set(ud.BoundaryModel,'enable','off','value',0);
   end
end
set(hFig,'userdata',ud,'currentaxes',ud.Hand.Axes);
i_Plot(hFig);

drawnow
% update optimality criteria
f=i_Optimality(hFig);
close(f);

%-------------------------------------------------------------------
% SUBFUNCTION i_Print
%-------------------------------------------------------------------
function i_Print(hFig,TitleStr)

if nargin<2
   TitleStr = 'Prediction Error Variance';
end

ud= get(hFig,'userdata');

DispType= get(ud.Hand.dispType,'value');

switch DispType
case {4}
   %% currently not printing movie
   return
otherwise
   
   inputs = char(ud.Hand.listCtrl);
   inputs = {'Input Factors','',inputs{:}};
   
   fh = figure('visible','off');
   lay = xreglayerlayout(fh,'border',[80 20 20 50]);
   font=get(0,'fixedWidth');
   tH = axestext(fh,'units','pixels',...
      'fontweight','demi',...
      'fontName',font,...
      'interpreter','none',...
      'string',inputs);
   set(lay,'elements',{tH},'position',get(tH,'extent'));
   printlayout1(ud.Hand.Axes,lay,TitleStr);
   
   close(fh);
   
end
