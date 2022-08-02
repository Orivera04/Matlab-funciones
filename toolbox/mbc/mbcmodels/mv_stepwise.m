function varargout=mv_stepwise(Action,varargin);
% MV_STEPWISE Interactive tool for stepwise regression.
% 
% Stepwise GUI tool for use with MBrowser

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.9.2.5 $  $Date: 2004/04/04 03:30:47 $


% This was based on the Statistic Toolbox stepwise function
% but has been considerably modified and enhanced

switch lower(Action)
case 'create'
   % Create Stepwise Figure
   varargout{1}=i_Create(varargin{:});
case 'update'
   i_Update(varargin{:});
case 'click'
   % Toggle term in and out of model
   % Click on Table Entry or Errorbar
   i_Step(varargin{:});
case 'auto'
   % Minimise PRESS
   % Click on 'Auto' Button
   i_MinPress(varargin{:});
case 'crit'
   % Change Significance Level for Confidence Interval
   % Change Entry in CI editbox
   i_ChangeCrit
case 'radio'
   i_Radio(varargin{:});
case 'vslider'
   i_VSlider
case 'includeall'
   % Include all terms in model
   % Click on 'Include All' Button
   i_IncludeAll(varargin{:});
case 'removeall'
   % Remove all terms from model
   % Click on 'Remove All' Button
   i_RemoveAll(varargin{:});
case 'remove'
   % Remove Statistically Insignificant Terms from model
   % Click on 'Remove' Button
   i_RemoveInsig(varargin{:});
case 'addsig'
   % Add Statistically significant Terms to model
   % Click on 'Add' Button
   i_AddSig(varargin{:});
case 'history'
   % Retrieve Model from History
   % Click on History Pints
   i_History(varargin{:})
case 'doe'
   ud= get(gcbf,'userdata');
   ptr= get(gcbf,'pointer');
   set(gcbf,'pointer','watch');
   mv_doeanalysis('create',ud.p_mdev);
   set(gcbf,'pointer',ptr);
   
case 'close'
   % Close Figure and Update Model Results
   i_Close
end


%------------------------------------------------------------------------
% SUBFUNCTION i_Create
%------------------------------------------------------------------------
function table_fig= i_Create(p_mdev,alpha)


hFig= findobj(get(0,'children'),'flat','Tag','stepwisefig');
if ~isempty(hFig)
   table_fig=[];
   hFig=hFig(1);
   if strcmp(get(hFig,'visible'),'off')
      table_fig=hFig;
      ud= get(hFig,'userdata');   
      % Model for Stepwise
      Model= p_mdev.model;
      
      if ~( strcmp(class(Model),class(ud.Model)) & size(Model,1) == size(ud.Model,1) )
         delete(hFig);
         table_fig= i_Create(p_mdev,alpha);
         return
      end
      
      Yname= p_mdev.name;
      Constant = IncludeConst(Model);
      [Model,OK,StatsRes,B]= stepwise(Model);
      % (3,2) element is the df for SST 
      Xdata= p_mdev.getdata('X');
      Nobs= size(Xdata,1);
      
      df   = 1:max(Nobs,size(Model,1)); 
      alpha= get(ud.CritVal,'userdata')/100;
      sigprob= 1-alpha/2;
      ud.crit=  i_Calctinv(sigprob,df);
      ud.Model      = Model;
      ud.OrigModel  = Model;
      ud.Constant   = Constant;
      ud.p_mdev     = p_mdev;
      
      Status= getstatus(Model);
      ud.Hand.Table(:,0).string= labels(Model);
      ud.Hand.Table(:,1)=Status(ud.TermsOrder);
      for i=1:3
         s= find(Status(ud.TermsOrder)==i);
         i_DisplayStatus(ud,i,s)
      end

      % Display Initial Results 
      i_DisplayResults(ud,StatsRes,B)

      
      delete(get(ud.Hand.HistAxes,'children'));
      set(ud.Hand.hList,'string','');
      
      histud= get(ud.Hand.HistAxes,'userdata');
      histud= rmfield(histud,'pressdothndl');
      set(ud.Hand.HistAxes,'userdata',histud,'xlim',[0 10],'ylimmode','auto');
      i_UpdateHistory(StatsRes,Model,hFig,ud.Hand.HistAxes);
      
      set(hFig,'UserData',ud,...
         'Name',['Stepwise Regression for ',Yname]);
   end
   figure(hFig);
   return
end
   
%%=========================================================
%% only come in here first time to create the UI
%%=========================================================

%% since this takes a while - give people a waitbar to look at
wb = xregGui.waitdlg('title', 'Creating Stepwise Figure', 'parent', mvf);

mdev= p_mdev.info;
% Model for Stepwise
Model= p_mdev.model;
Yname= p_mdev.name;

% Number of parameters in full model
p=size(Model,1);
colidx = 1:p;

% Data is stored in Model Object while in GR.
% Need to determine total number of observations 
Constant = IncludeConst(Model);
[StatsRes,Bint]= stats(Model,'stepwise');
% (3,2) element is the df for SST 
Xdata= p_mdev.getdata('X');
Nobs= size(Xdata,1);

alpha=0.05;
% Calculate Critical y values for all possible cases
sigprob = 1 - alpha/2;
df   = 1:max(Nobs,size(Model,1));
crit = i_Calctinv(sigprob,df);

[Model,OK,StatsRes,B]= stepwise(Model);


% Coefficient Table.
% This needs to be Axes/Text based because TeX labels are required
FontSize=8;

screen= get(0,'screensize');
fight= 20 * (p+2);
ht= 20;

% determine height of table 
set(0,'units','pixels');
screen= get(0,'ScreenSize');
Aht= min(screen(4)-180);
ht = Aht/(p+2);
fht=max(Aht+100,710);

% Horizontal spacing for columns
z = [50 300];


% Create the figure for the Stepwise GUI
table_fig = xregfigure('Visible','off',...
   'IntegerHandle','off',...
   'HandleVisibility','callback',...
   'color',get(0,'defaultuicontrolbackgroundColor'),...
   'Tag','stepwisefig',...
   'DoubleBuffer','on',...
   'DefaultUIControlInterruptible','off',...
   'DefaultUIMenuInterruptible','off',...
   'DefaultUIPushToolInterruptible','off',...
   'DefaultUIToggleToolInterruptible','off',...
   'DefaultAxesInterruptible','off',...
   'DefaultLineInterruptible','off',...
   'Units','Pixels', ...
   'Name',['Stepwise Regression for ',Yname],...
   'Resize','off', ...
   'NumberTitle','off',...
   'Interruptible', 'off',...
   'menubar','none',...
   'CloseRequestFcn',[mfilename,'(''Close'')'],...
   'Position',[2 screen(4)-fht-40 1020 fht]);

table_fig= double(table_fig);


% Table for Coefficients and Statistics
Headings = {'Term','Status','B','std B','t','Next PRESS'};
Style    = {'popup','text','text','text','text','text'};
% Table Spacing
rows    = p;
height  = ht;
TableSize = [ 65*6 , Aht+25 ];

% Extra properties
Props = {'style'};
Vals  = [Style];

axes('parent',table_fig,...
   'units','pixels',...
   'pos',[20 fht-20-TableSize(2) TableSize(1)+250 TableSize(2)+2],...
   'xtick',[],'ytick',[],'color',get(table_fig,'color'),...
   'box','on',...
   'hittest','off');

%% update  waitbar
wb.Waitbar.value = 0.1;

htmp= uicontrol('parent',table_fig,...
   'style','popup',...
   'string','test',...
   'pos',[0 0 63 18],...
   'vis','off');
hextent= get(htmp,'extent');
delete(htmp);
rowHt= hextent(4)+6;

tbl=xregtable(table_fig,...
   'position',[10 fht-20-TableSize(2) TableSize],...
   'cols.size',65,...
   'rows.size',rowHt,...
   'frame.hborder',[2 -20],...
   'frame.vborder',[2 20],...
   'frame.box','on',...
   'rows.spacing',0,...
   'cols.spacing',0,...
   'cells.defaultbackgroundcolor',[1 1 1],...
   'defaultcelltype','uiemuedit0',...
   'defaultcellformat','%p4.9',...
   'rows.number',rows+1,...
   'cols.number',6,...
   'rows.fixed',1,...
   'cols.fixed',1,...
   'zeroindex',[2 2],...
   'frame.visible','off',...
   'vslider.callback',[mfilename,'(''vslider'')'],...
   'vslider.offset',240);

%% update  waitbar
wb.Waitbar.value = 0.6;

tbl.redrawmode= 'basic';
set(tbl,...
   'cells.rowselection',[1 1],...
   'cells.colselection',[1 6],...
   'cells.type','text',...
   'cells.string',Headings,...
   'cells.rowselection',[2 rows+1],...
   'cells.colselection',[1 1],...
   'cells.type','text',...
   'cells.string',labels(Model),...
   'cells.HorizontalAlignment','left',...
   'cells.rowselection',[2 rows+1],...
   'cells.colselection',[2 2],...
   'cells.type','uipopupmenu',...
   'cells.string',repmat({'Always|Never|Step'},rows,1),...
   'cells.BackGroundColor','w',...
   'cells.HorizontalAlignment','left',...
   'cells.rowselection',[2 rows+1],...
   'cells.colselection',[2 6],...
   'cells.HorizontalAlignment','right')
   
%% update  waitbar
wb.Waitbar.value = 0.67;

ud.TermsOrder= termorder(Model)';
Status= getstatus(Model);
tbl(:,1)= Status(ud.TermsOrder);
tbl(0,end).FontWeight= 'bold';

VisRows= min(tbl.rows.onscreen-1,p);
%fix((TableSize(2)-42)/(rowHt));
% Errorbar plot
ah= fht-20-(VisRows+1)*(rowHt);
%40+TableSize(2)-VisRows*20-2;
step_axes= axes('parent',table_fig,'NextPlot','add','DrawMode','fast','Units','Pixels',  ...
   'Tag','stepaxes','Box','on','Ylim',[0.5 VisRows+0.5], ...
   'ydir','reverse',...
   'YTickLabel','','ytick',[],...
   'units','pixels',...
   'Position',[35+TableSize(1) ah 200 (VisRows)*(rowHt)], ...
   'FontSize',8);
set(get(step_axes,'title'),'string','Coefficients with Errorbars',...
   'FontSize',9);

% Make Lines and handles
% Vertical line at zero
plot([0 0],[0.5,p+0.5],'k-', 'Parent', step_axes);
for k = 1:p,
   % Interval Estimate
   bhandles(k,1)=line('Parent',step_axes,...
      'Xdata',[0 0]','YData',[k k],...
      'ButtonDownFcn',[mfilename,'(''click'',',int2str(k),')'],'LineWidth',2);
   % Point Estimate
   phandle(k,1)= line('Parent',step_axes,...
      'Xdata',0,'YData',k,...
      'Marker','.','MarkerSize',20,...
      'ButtonDownFcn',[mfilename,'(''click'',',int2str(k),')']);
end

TableSize(1)= TableSize(1)+250;
if isconstant(Model)
   % Don't display errorbar for constant term as it is usually too large.
   set(phandle(1),'visible','off');
   set(bhandles(1),'visible','off');
end
StepAxPos= get(step_axes,'pos');
% Anova Table and other Stats
Stats= gui_diagstats(Model, 'create',table_fig);
set(Stats.layout,'position', [40+TableSize(1) 100 330 170],'packstatus','on','visible','on');
set(Stats.layout,'packstatus','on');
apos= [40+TableSize(1) 100 360 170];

%% update  waitbar
wb.Waitbar.value = 0.88;

% Confidence Interval label and edit box 
uicontrol('parent',table_fig,...
   'Style','text','Units','Pixels',...
   'FontName','Symbol',...
   'String','a (%)', ...
   'HorizontalAlign','left',...
   'Position',[40+TableSize(1) 70 39 15]);
ud.CritVal= uicontrol('parent',table_fig,...
   'Style','edit','Units','Pixels',...
   'String',alpha*100,'UserData',alpha*100, ...
   'BackGroundColor','w',...
   'Position',[80+TableSize(1) 70 69 18],'Callback',[mfilename,'(''crit'')']);
ud.CritVal1= uicontrol('parent',table_fig,...
   'Style','text','Units','Pixels',...
   'String','a (%)', ...
   'BackGroundColor','w',...
   'ForeGroundColor','k',...
   'Position',[160+TableSize(1) 70 100 15]);
ud.CritVal2= uicontrol('parent',table_fig,...
   'Style','text','Units','Pixels',...
   'String','a (%)', ...
   'BackGroundColor','w',...
   'ForeGroundColor','r',...
   'Position',[270+TableSize(1) 70 100 15]);

% Set up Figure Properties here
set(table_fig,'Units','Pixels', 'Tag','stepwisefig',...
   'Name',['Stepwise Regression for ',Yname],'Resize','off', ...
   'NumberTitle','off',...
   'Interruptible', 'off',...
   'menubar','none',...
   'CloseRequestFcn',[mfilename,'(''Close'')'],...
   'HandleVisibility','callback',...
   'Position',[1 screen(4)-fht-40 min(apos(1)+apos(3)+10,1020) fht]);

ud.UpdateHistory = @i_UpdateHistory;
% History display
fpos= get(table_fig,'pos');
HistAxes= axes('Parent',table_fig,...
   'units','pixels',...
   'pos',[fpos(3)-310 fpos(4)-230 300  200],...
   'Tag','HistoryAxes',...
   'box','on',...
   'NextPlot','add',...
   'FontSize',8);
fight = fpos(4);
% Critical Values for PRESS CI's
trm  = Nobs:-1:Nobs-p-1;
trml = length(trm);
low  = 0.025;
hi   = 0.975;
histud.chi2crit = chi2inv([low(ones(trml,1),1) hi(ones(trml,1),1)],[trm' trm']); 
set(HistAxes,'UserData',histud);
set(get(HistAxes,'xlabel'),'string','Model Number','FontSize',9);
set(get(HistAxes,'title'),'string','Stepwise PRESS History','FontSize',9);					

str=p_mdev.colhead;
%% truncate these strings so cols line up okay
maxLength = [3 5 7 9 9];
numHeaders = min(length(str),5);
for i = 1:numHeaders
   thisLength = min(length(str{i}),maxLength(i));
   str{i} = str{i}(1:thisLength);
end

uicontrol('Parent',table_fig,...
   'units','pixels',...
   'style','text',...
   'string',sprintf('%5s %6s %8s %10s %10s',str{:}),...
	'fontsize',9,...
   'fontname','courier new',...
   'horizontalAlign','left',...
   'BackGroundColor',get(table_fig,'color'),...
   'pos',[44+TableSize(1) fpos(4)-430+150 330  13]);
hList=uicontrol('Parent',table_fig,...
   'units','pixels',...
   'style','listbox',...
   'string','',...
	'fontsize',9,...
   'fontname','courier new',...
   'BackGroundColor','w',...
   'callback',[mfilename,'(''history'')'],...
   'pos',[40+TableSize(1) fpos(4)-430 330  150]);

% Stepwise Buttons (at bottom of Figure)
ToolTipString = {   'Minimize PRESS',...
   'Include all terms in model',...
   'Remove all terms from model',...
   'Forward addition of significant terms to model',...
   'Backwards removal of insignificant terms from model'};
String= {'Min. PRESS',...
      'Include All',...
      'Remove All',...
      'Forward',...
      'Backwards'};

CallBack= {[mfilename,'(''Auto'')'],...
      [mfilename,'(''IncludeAll'')'],...
      [mfilename,'(''RemoveAll'')'],...
      [mfilename,'(''AddSig'')'],...
      [mfilename,'(''Remove'')']};

for i=1:length(String)
   uicontrol('parent',table_fig,...
      'Style','Pushbutton','Units','Pixels',...
      'String',String{i},...
		'BusyAction','cancel',...
      'ToolTipString',ToolTipString{i},...
      'Position',[30+(i-1)*120 20 100 25],...
      'Callback',CallBack{i});
end


MainMenu= {'&Figure','&Regression'};
mmh= xregmenutool('create',table_fig,'Label',MainMenu);

% Figure Menu
hf=xregmenutool('create',mmh(1),'Label',{'&Close'},'Callback',{[mfilename,'(''Close'')']});
set(hf,'accelerator','W');

Label= {'Minimize &PRESS',...
      '&Include All',...
      '&Remove All',...
      '&Forward',...
      '&Backwards'};

hf= xregmenutool('create',mmh(2),'Label',Label,'CallBack',CallBack);

xregwinlist(table_fig); % initialize Window Menu

%HELP MENU
mv_helpmenu(table_fig,{'&Stepwise Help','xreg_stepwise'});

%% update  waitbar
wb.Waitbar.value = 0.91;

% Figure UserData Structure
ud.crit       = crit;
ud.Nobs       = Nobs;
ud.Model      = Model;
ud.OrigModel  = Model;
ud.Constant   = Constant;
ud.p_mdev     = p_mdev;
ud.ParentFig  = get(MBrowser,'Figure');
ud.Stats      = Stats;
ud.TermsOrder= termorder(Model)';

ud.Hand.Labels = zeros(p,1);
ud.Hand.Table = tbl;
ud.Hand.CIAxes= step_axes;
ud.Hand.Point= phandle;
ud.Hand.Bar  = bhandles;
ud.Hand.HistAxes= HistAxes;
ud.Hand.hList= hList;

% Make Table Text Handles
labs= labels(Model);
Status = getstatus(Model);

% Variable Names
tbl(:,end).Enable= 'inactive';

for i=1:3
   s= find(Status(ud.TermsOrder)==i);
   i_DisplayStatus(ud,i,s)
   tbl(s,[0 end]).ButtonDownFcn = [mfilename,'(''click'')'];
   tbl(s,1).CallBack= [mfilename,'(''radio'')'];
end
% Display Initial Results 
set(table_fig,'UserData',ud);


i_DisplayResults(ud,StatsRes,B)

i_UpdateHistory(StatsRes,Model,table_fig,HistAxes);

%% update  waitbar
wb.Waitbar.value = 1.0;

set(table_fig,'visible','on');
tbl.visible='on';

%% kill the waitbar
delete(wb);

return


%%-------------------------------------------
%%  SUBFUNCTION  i_Update
%%-------------------------------------------
function i_Update(hFig);

ud= get(hFig,'UserData');

m= ud.p_mdev.model;

Status= getstatus(m);
if size(m,1)~=size(ud.Model) | ~all(Status~=getstatus(ud.Model))
   ud.TermsOrder= termorder(m);
   ud.Hand.Table(:,0).string= labels(m);
   ud.Hand.Table(:,1)=Status(ud.TermsOrder);
   for i=1:3
      s= find(Status(ud.TermsOrder)==i);
      i_DisplayStatus(ud,i,s)
   end
end

% Recalcuate old model
[ud.Model,OK,NewStats,B]= stepwise(m);

% Update Displays
i_DisplayResults(ud,NewStats,B)
i_UpdateHistory(NewStats,ud.Model,hFig,ud.Hand.HistAxes);
set(hFig,'userdata',ud);


%%-------------------------------------------
%%  SUBFUNCTION  i_CIntervals
%%-------------------------------------------
function [Bint,crit]= i_CIntervals(B,CritVals)

beta= B(:,1);
crit= zeros(size(beta));
df= B(:,3);
intdf= df==fix(df);
crit(df(intdf)>1)= CritVals(df(intdf)>1);
if ~all(intdf) & ~any(df(~intdf)<10)
	% use linear interpolation for non-integer
	fdf= floor(df(~intdf));
	cdf= ceil(df(~intdf));
	crit(~intdf)= CritVals(fdf)+ (df(~intdf)-fdf)./(cdf-fdf).*(CritVals(cdf)-CritVals(fdf));
elseif ~all(intdf) & any(df(~intdf)<10)
   % except if df <10, when you should recalculate tinv
   hFig= findobj(get(0,'children'),'flat','Tag','stepwisefig');
   ud= get(hFig,'userdata');   
   alpha= get(ud.CritVal,'userdata')/100;
   sigprob= 1-alpha/2;
   crit(~intdf)=  i_Calctinv(sigprob,df(~intdf));
end
% calculate confidence intervals and tcrit values
Bint= [B(:,1)-crit.*B(:,2) B(:,1)+crit.*B(:,2)];


%------------------------------------------------------------------------
% SUBFUNCTION i_DisplayResults
%------------------------------------------------------------------------
function i_DisplayResults(ud,StatsRes,B)
% Local function for writing out all the entries in the Parameter Data Table.

[Bint,crit]= i_CIntervals(B,ud.crit);

beta= B(:,1);
% crit= zeros(size(beta));
% df= B(:,3);
% intdf= df==fix(df);
% crit(df(intdf)>1)= ud.crit(df(df(intdf)>1));
% if ~all(intdf)
% 	% use linear interpolation for non-integer
% 	fdf= floor(df(~intdf));
% 	cdf= ceil(df(~intdf));
% 	crit(~intdf)= ud.crit(fdf)+ (df(~intdf)-fdf)./(cdf-fdf).*(ud.crit(cdf)-ud.crit(fdf));
% end
% % calculate confidence intervals and tcrit values
% Bint= [B(:,1)-crit.*B(:,2) B(:,1)+crit.*B(:,2)];

% round this for the moment
df1=ceil(max(B(:,3)));
df2=floor(min(B(:,3)));

sig= get(ud.CritVal,'userdata');
if df1>0
   t1= ud.crit(df1);
   set(ud.CritVal1,'string',sprintf('t(%.2g,%1d) = %.3f',sig/200,df1,t1))
else
   set(ud.CritVal1,'string','')
end   
if df2>0
   t2= ud.crit(df2);
   set(ud.CritVal2,'string',sprintf('t(%.2g,%1d) = %.3f',sig/200,df2,t2))
else
   set(ud.CritVal2,'string','')
end   

NextPress= B(:,end);

p= size(ud.Model,1);
inmodel= Terms(ud.Model);
for i= 1:p
   params = ud.TermsOrder(i);
   % update table entries
   % Update errorbars
   set(ud.Hand.Point(i),'XData',beta(params));
   set(ud.Hand.Bar(i),'XData',Bint(params,:));
   if inmodel(params)
      % Terms in model
      set(ud.Hand.Point(i),'Color','k');
      set(ud.Hand.Bar(i),'Color','k');
   else
      % Terms out of model
      set(ud.Hand.Point(i),'Color','r');
      set(ud.Hand.Bar(i),'Color','r');
   end
end

inmodel= inmodel(ud.TermsOrder);
t= zeros(size(beta));
if ~all(B(:,2)==0)
   t(B(:,2)~=0)=beta(B(:,2)~=0)./B((B(:,2)~=0),2);
else
   t= zeros(size(beta));
end
Nums= [beta B(:,2) t NextPress];




% Find Minimum Press for next step
[MinPress,MinInd]=nanmin(NextPress(ud.TermsOrder));
ud.Hand.Table(:,end).backgroundcolor='w';
if MinPress<StatsRes(1,end)
   ud.Hand.Table(0,end).color='y'; 
   ud.Hand.Table([MinInd],end).backgroundcolor='y';
   % Highlight minimum press yellow
else
   ud.Hand.Table(0,end).color='k';
end

Nums(getstatus(ud.Model)==2,2:4)=NaN;
ud.Hand.Table(:,2:end)= Nums(ud.TermsOrder,:);

ud.Hand.Table(inmodel,0:end).ForeGroundColor  = 'k';
ud.Hand.Table(~inmodel,0:end).ForeGroundColor = 'r';

% X Axes Limits for ErrorBar Plot
% Don't include constant coeff in this calculation
xmax = nanmax(Bint(1+ud.Constant:end,2));
xmin = nanmin(Bint(1+ud.Constant:end,1));
xrange = max(xmax-xmin,1);
%set(get(ud.Hand.Bar(1),'parent'),...
%   'XLim',[xmin-0.05*xrange xmax+0.05*xrange]);
set(get(ud.Hand.Bar(1),'parent'),...
   'XLimMode','auto');

% Colour Insignicant intervals and errorbars purple
insig = Bint(:,1)<0 & Bint(:,2)>0;
insig = insig(ud.TermsOrder);

ud.Hand.Table(insig,end-1).foregroundcolor= 'b';
ud.Hand.Table(~insig,end-1).foregroundcolor= 'k';

set(ud.Hand.Bar(insig),'color','b')
% set(ud.Hand.Bar(~insig),'color','k')

ud.Hand.Table.redraw;



gui_diagstats(ud.Model,'display',ud.Stats);



%------------------------------------------------------------------------
% SUBFUNCTION i_Radio
%------------------------------------------------------------------------
function i_Radio(StepTerm)

ud= get(gcbf,'UserData');

tbl= ud.Hand.Table;
rud= get(gcbo,'userdata');
if strcmp(tbl.vslider.visible,'on')
   StepTerm=rud.row+tbl.vslider.value-1;
else
   StepTerm=rud.row;
end   


TermStatus= get(gcbo,'value');
OldStatus= getstatus(ud.Model);
if TermStatus~=OldStatus(ud.TermsOrder(StepTerm))
   
   i_DisplayStatus(ud,TermStatus,StepTerm)
   
   StepTerm= ud.TermsOrder(StepTerm);
   ud.Model=setstatus(ud.Model,StepTerm,TermStatus);
   % Do step
   [ud.Model,OK,NewStats,B]= stepwise(ud.Model,~Terms(ud.Model));
   if ~OK;
      % Step couldn't be taken
      errordlg('There is insufficient data to add this term to the model',...
         'Stepwise','modal'); 
      return
   end
   % Update display
   i_DisplayResults(ud,NewStats,B)
   i_UpdateHistory(NewStats,ud.Model,gcbf,ud.Hand.HistAxes);
   
   set(gcbf,'UserData',ud);
   
   % update browser view and other windows;
   ud.p_mdev.setmodel(ud.Model,OK);
	ViewNode(MBrowser);
   figure(gcbf);
   
end 

function i_DisplayStatus(ud,TermStatus,StepTerm)

switch TermStatus
case 1 
   % Term always incuded in Model
   
   % Display Confidence Intervals
   set(ud.Hand.Bar(StepTerm),'visible','on')
   set(ud.Hand.Point(StepTerm),'visible','on')
   if (ismember(1,StepTerm) & isconstant(ud.Model))
      % StepTerm= setdiff(StepTerm,1);
      set(ud.Hand.Bar(1),'visible','off')
      set(ud.Hand.Point(1),'visible','off')
   end
   
   ud.Hand.Table(StepTerm,3:end-1).Visible= 'on';
   % Hide Next PRESS text 
   % Disable ButtonDownFcn
   ud.Hand.Table(StepTerm,[0 end]).HitTest= 'off';
case 2
   % Term never incuded in Model
   
   % Hide Confidence Intervals and Next PRESS
   set(ud.Hand.Bar(StepTerm),'visible','off')
   set(ud.Hand.Point(StepTerm),'visible','off')
   
   % Disable ButtonDownFcn
   ud.Hand.Table(StepTerm,[0 end]).HitTest= 'off';
case 3
   % Term can be stepped in and out
   
   % Show Confidence Intervals and Next PRESS
   set(ud.Hand.Bar(StepTerm),'visible','on')
   set(ud.Hand.Point(StepTerm),'visible','on')
   if (ismember(1,StepTerm) & isconstant(ud.Model))
      % StepTerm= setdiff(StepTerm,1);
      set(ud.Hand.Bar(1),'visible','off')
      set(ud.Hand.Point(1),'visible','off')
   end
   
   % Enable ButtonDownFcn
   ud.Hand.Table(StepTerm,[0 end]).HitTest= 'on';
end


%------------------------------------------------------------------------
% SUBFUNCTION i_VSilder
%------------------------------------------------------------------------
function i_VSlider

ud= get(gcbf,'userdata');
OldYlim= get(ud.Hand.CIAxes,'ylim');

Top=get(ud.Hand.Table,'vslider.value');
set(ud.Hand.CIAxes,'ylim',Top-0.5+[0 diff(OldYlim)])

%------------------------------------------------------------------------
% SUBFUNCTION i_Step
%------------------------------------------------------------------------
function i_Step(StepTerm)
% Toggle single term (based on click in table or errorbar)
hFig=gcbf;
ud = get(hFig,'UserData');

tbl= ud.Hand.Table;
rud= get(gcbo,'userdata');
if ~isempty(rud)
   % click on table
   if strcmp(rud.type,'fixed')
      StepTerm= rud.row-tbl.rows.fixed;
   else
      % convert to index
      StepTerm=scrollindex(tbl,rud.row,rud.col);
   end
else
   % click on CI plot
   StepTerm= get(gcbo,'ydata');
   StepTerm= StepTerm(1);
end
% Do step
StepTerm= ud.TermsOrder(StepTerm);
[ud.Model,OK,NewStats,B]= stepwise(ud.Model,StepTerm);
if ~OK;
   % Step couldn't be taken
   errordlg('There is insufficient data to add this term to the model',...
      'Stepwise','modal'); 
   return
end
set(hFig,'pointer','watch');
% Update display
i_DisplayResults(ud,NewStats,B)
i_UpdateHistory(NewStats,ud.Model,hFig,ud.Hand.HistAxes);

set(hFig,'UserData',ud);

% update browser view and other windows;
ud.p_mdev.setmodel(ud.Model,OK);
ViewNode(MBrowser);
figure(hFig);
set(hFig,'pointer','arrow');

%------------------------------------------------------------------------
% SUBFUNCTION i_MinPress
%------------------------------------------------------------------------
function i_MinPress(hFig)
% Take all steps to mininise PRESS

if ~nargin
   hFig=gcbf;
end

set(hFig,'pointer','watch');
ud = get(hFig,'UserData');

om= minpress(ud.Model);
set(om,'isInitialised',true);
set(om,'guidisp',true)
[ud.Model,MinPress,OK,NewStats,B]= run(om,ud.Model,ud);

% Update Coeff Table and ErrorBar Plots
i_DisplayResults(ud,NewStats,B)
set(gcbf,'userdata',ud);

% update modeldev's model
ud.p_mdev.setmodel(ud.Model,OK);
% update browser view and other windows;
ViewNode(MBrowser);
figure(hFig);
set(hFig,'pointer','arrow');


%------------------------------------------------------------------------
% SUBFUNCTION i_ChangeCrit
%------------------------------------------------------------------------
function i_ChangeCrit
% Change significance level for CI's

% Check entry is a valid %
if xregCheckIsNum('range',0,100);
   
   ud = get(gcbf,'UserData');
   
   % Calculate new critical values
   alpha   = get(gcbo,'userdata')/100;
   sigprob = 1 - alpha/2;
   % Set up critical values so df(SSR)+1 gives index to crit values
   df      = 1:ud.Nobs;  %:-1:ud.Nobs-size(ud.Model,1);
   ud.crit = i_Calctinv(sigprob,df);
   % recalculate all stats
   [Model,OK,NewStats,B]= stepwise(ud.Model);
   % update displays
   i_DisplayResults(ud,NewStats,B)
   % Don't update history because model hasn't changed
   
   set(gcbf,'userdata',ud);
   
   % update browser view and other windows;
   ud.p_mdev.setmodel(ud.Model,OK);
   ViewNode(MBrowser);
   figure(gcbf);
   
end

%------------------------------------------------------------------------
% SUBFUNCTION i_RemoveInsig
%------------------------------------------------------------------------
function i_RemoveInsig(hFig)

if ~nargin
   hFig=gcbf;
end

ud = get(hFig,'UserData');

om= backwardselect(ud.Model);
set(om,'isInitialised',true);
set(om,'guidisp',true)
% turn off include all option
set(om,'includeall',false)
% run optimMgr
[ud.Model,MinPress,OK,NewStats,B]= run(om,ud.Model,ud);

% Update Coeff Table and ErrorBar Plots
i_DisplayResults(ud,NewStats,B)
set(gcbf,'userdata',ud);



% Update displays
i_DisplayResults(ud,NewStats,B)
i_UpdateHistory(NewStats,ud.Model,hFig,ud.Hand.HistAxes);

set(gcbf,'userdata',ud);

% update modeldev's model
ud.p_mdev.setmodel(ud.Model,OK);
% update browser view and other windows;
ViewNode(MBrowser);
figure(hFig);

%------------------------------------------------------------------------
% SUBFUNCTION i_AddSig
%------------------------------------------------------------------------
function i_AddSig(hFig)

if ~nargin
   hFig=gcbf;
end

ud = get(hFig,'UserData');

om= forwardselect(ud.Model);
set(om,'isInitialised',true);
set(om,'guidisplay',true)
% turn off include all option
set(om,'removeall',false)
% run optimMgr
[ud.Model,MinPress,OK,NewStats,B]= run(om,ud.Model,ud);


% Update displays
i_DisplayResults(ud,NewStats,B)
i_UpdateHistory(NewStats,ud.Model,hFig,ud.Hand.HistAxes);

set(hFig,'userdata',ud);

% update browser view and other windows;
% update modeldev's model
ud.p_mdev.setmodel(ud.Model,OK);
% update browser view and other windows;
ViewNode(MBrowser);
figure(hFig);

%------------------------------------------------------------------------
% SUBFUNCTION i_IncludeAll
%------------------------------------------------------------------------
function i_IncludeAll(hFig)
% Include all terms in model

if ~nargin
   hFig=gcbf;
end

ud = get(hFig,'UserData');
% No Terms left out of model
OutModel = false(size(ud.Model));
% calculate new model
[ud.Model,OK,NewStats,B]= stepwise(ud.Model,OutModel);
if ~OK;
   % check that it is possible to include all terms in model
   errordlg('There is insufficient data to include all terms in this model',...
      'Stepwise','modal'); 
   return
end
% update displays
i_DisplayResults(ud,NewStats,B)
i_UpdateHistory(NewStats,ud.Model,hFig,ud.Hand.HistAxes);
set(gcbf,'userdata',ud);

% update browser view and other windows;
ud.p_mdev.setmodel(ud.Model,OK);
ViewNode(MBrowser);
figure(hFig);


%------------------------------------------------------------------------
% SUBFUNCTION i_RemoveAll
%------------------------------------------------------------------------
function i_RemoveAll(hFig)
% Remove all terms for model (e.g. for Forward Selection)

if ~nargin
   hFig=gcbf;
end

ud = get(hFig,'UserData');
% All Terms left out of model
OutModel = true(size(ud.Model));
% calculate new model
[ud.Model,OK,NewStats,B]= stepwise(ud.Model,OutModel);
% update displays
i_DisplayResults(ud,NewStats,B)
i_UpdateHistory(NewStats,ud.Model,hFig,ud.Hand.HistAxes);
set(gcbf,'userdata',ud);

% update browser view and other windows;
ud.p_mdev.setmodel(ud.Model,OK);
ViewNode(MBrowser);
figure(hFig);

%------------------------------------------------------------------------
% SUBFUNCTION i_History
%------------------------------------------------------------------------
function i_History(flag)
% Return to previous model (from History plot click)


if strcmp(get(gcbo,'type'),'uicontrol');
   if strcmp(get(gcbf,'selectionType'),'open')
      return
   end
   flag= get(gcbo,'value');
end
ud= get(gcbf,'UserData');
% histud stored in HistAxes UserData
histud= get(ud.Hand.HistAxes,'UserData');
in = histud.instore;
Terms = in(:,flag);
% Recalcuate old model
[ud.Model,OK,NewStats,B]= stepwise(ud.Model,Terms);
% Update Displays
i_DisplayResults(ud,NewStats,B)
i_UpdateHistory(NewStats,ud.Model,gcbf,ud.Hand.HistAxes);
set(gcbf,'userdata',ud);

% update browser view and other windows;
ud.p_mdev.setmodel(ud.Model,OK);
ViewNode(MBrowser);
figure(gcbf);

%------------------------------------------------------------------------
% SUBFUNCTION i_UpdateHistory
%------------------------------------------------------------------------
function i_UpdateHistory(StatsRes,Model,hFig,HistAxes)
% Local function for adding new press error bar to History Plot.

set(hFig,'CurrentAxes',HistAxes)
histud = get(HistAxes,'UserData');

press = StatsRes(1,end); % PRESS statistic						
df    = StatsRes(2,2);   % df(SSE)
dfInd = StatsRes(1,2)+1; % df(SSR)+1 gives index to crit values


tmp = ~Terms(Model);

if ~isfield(histud,'pressdothndl')   % No History
   histud.pressdothndl(1)=-1;
   histud.instore = tmp(:);
   num_mod = 1;
else  
   % Add New Model to history store
   in = histud.instore;
   in = [in tmp(:)];
   histud.instore = in;
   num_mod = length(histud.pressdothndl)+1;   
end
% plot CI bar

yl = get(HistAxes,'Ylim');
yhi = max(press*1.05,yl(2));
ylo = min(press*0.95,yl(1));
set(HistAxes,'Xlim',[max(0.5,num_mod-19.5),num_mod+0.5],'Xtick',(1:num_mod) );
% plot PRESS point
histud.pressdothndl(num_mod) = plot(num_mod,press,'.k','parent',HistAxes);

% Set ButtonDwn callbacks
bdf = [mfilename,'(''history'',',int2str(num_mod),')'];
% set(histud.presshandle(num_mod),'ButtonDownFcn',bdf);
set(histud.pressdothndl(num_mod),'MarkerSize',20,'ButtonDownFcn',bdf);

% Save history UserData
set(HistAxes,'UserData',histud);

s=stats(Model,'summary');
ud= get(hFig,'userdata');
str= [get(ud.Hand.hList,'string') 
   sprintf('%5d %6d %8.2g %10.4g %10.4g',s)];
set(ud.Hand.hList,'string',str,...
   'value',size(str,1),...
   'ListBoxTop',max(1,size(str,1)-8));
%------------------------------------------------------------------------
% SUBFUNCTION i_Close
%------------------------------------------------------------------------
function i_Close;


hFig= findobj(get(0,'children'),'flat','Tag','stepwisefig','visible','on');

if ~isempty(hFig);
   figure(hFig(1));
   ud= get(hFig(1),'UserData');
   confirm=questdlg('Do you want to update Regression Results?',...
      'Confirm Stepwise Exit',...
      'Yes',...
      'No',...
		'Cancel',...
      'Yes');
	if ~strcmp(confirm,'Cancel')
		if strcmp(confirm,'No') & size(get(ud.Hand.hList,'string'),1)>1  
			% Call main GR MFile to save old model 
			% (don't do this if there is only one entry in history)
			ud.p_mdev.setmodel(ud.OrigModel,1);
			ViewNode(MBrowser);
		end
		% close DOE evaluation figure
		hDOE= findobj(get(0,'children'),'flat','Tag','DOEtool','visible','on');
		close(hDOE);
		set(hFig(1),'visible','off');
		% Bring main GR figure to foreground
		figure(ud.ParentFig)
	end
end   


%------------------------------------------------------------------------
% SUBFUNCTION i_Calctinv
%------------------------------------------------------------------------

function crit= i_Calctinv(sigprob,df);

df= df(:);
crit= zeros(size(df));
if max(df)>100
   crit(df<100)=  tinv(sigprob,df(df<100));
   crit(df>=100)=  norminv(sigprob);
else
   crit=  tinv(sigprob,df);
end
