function varargout = mv_MonitorPlots(action,varargin)
% MV_MOONITORPLOTS This function will set up the monitor plots for a figure.
% 
% handles = mv_MonitorPlots(action,fH,Area)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.6.2.5 $  $Date: 2004/02/09 08:02:04 $

% New version created 30/6/2000

% This version is fully layout-ised


switch lower(action)
case 'create'
	handles=i_Create(varargin{:});
	varargout={handles};
case 'createaxes'
	i_createaxes(varargin{:});
case 'plot'
	i_plot(varargin{:});
case 'update'
	i_update(varargin{:});
case 'monitordlg'
	i_monitordlg(varargin{:});
case 'canceloutliers'
	i_canceloutliers(varargin{:});
case 'click'
	i_click(varargin{:});
case 'applyoutliers'
	i_applyoutliers;
case 'restoreoutliers'
	i_restoreoutliers;
case 'getgridlayout'
	varargout{1} = i_getgridlayout(varargin{:});
case 'setoutliers'
		   i_setOutliers(varargin{:});
case 'getoutliers'
	varargout{1} = i_getOutliers(varargin{:});
end

%--------------------------------------------
% SUBFUNCTION Create
%--------------------------------------------
function lyout = i_Create(fH,Tp,data,Flag)
% FLAG will be noOL from mv_automatch

% Check to see if we have a tab object 
% rather than a figure handle
if ~ishandle(fH)
	fH=get(fH,'parent');
end

%%--------------------------------------------------
%% context menu for the expand and restore options
%%--------------------------------------------------
ux=uicontextmenu('parent',fH,...
	'tag','monitor context menu');
Labels={'Set Up Plot Variables'};
CallBacks={'mv_automatch(''monitordlg'',gcbf)'};

Tags={'monitor setup'};
hf=xregmenutool('create',ux,'Label',Labels,'Callback',CallBacks,'Tag',Tags);
ud.contmenu=ux;
ud.contmenusetup = hf;
ud.SNo = NaN; % Current Sweep
ud.p_md = xregpointer;

if nargin <4, Flag=0; end;

ud.OutliersValid=0;
   
if ~isstr(Flag) | ~strcmp(Flag,'noOL');
	ud.OutliersValid=1;

	oL = Flag;
	ud.oL=oL;
	
	xregmenutool('set',hf,'separator','on');
	Labels={'Select &Multiple Outliers',...
			'Remove &Outliers',...
			'&Restore Removed Data',...
			'&Clear Outliers'};
	CallBacks={{@i_Multiselect, oL},...
			[mfilename,'(''applyoutliers'')'],...
			[mfilename,'(''restoreoutliers'')'],...
			[mfilename,'(''canceloutliers'',gcbf)']};
	Tags={'outlier','outlier','outlier','outlier'};
	xregmenutool('create',ux,'Label',Labels,'Callback',CallBacks,'Tag',Tags);
    set(ud.contmenusetup,'Callback','mv_LocalReg(''monitordlg'',mvf)');
end

%%--------------------------------------------------
%% The GRIDLAYOUT
%%--------------------------------------------------

text = uicontrol('Parent', fH,...
    'Style', 'text',...
    'HitTest', 'off',...
    'String', 'Goto to View > Data Plots... to choose which variables to plot');
sc = xregGui.SystemColorsDbl;
blank = xregGui.oblong('Parent', fH,...
    'Color', sc.CTRL_BACK,...
    'uicontextmenu', ux);

promptcard = xreggridbaglayout(fH,...
	'visible','off',...
    'dimension', [3 3],...
    'elements', {blank,[],[],[],text,[],[],[],[]},...
    'mergeblock', {[1 3], [1 3]});

ud.grd = xreglistctrl(fH,...
    'visible','off');

% This layout holds the grid of axes
Brdr=xregborderlayout(fH,...
	'visible','off',...
	'center',ud.grd,...
	'border',[10 10 10 10],...
	'position',[1 1 100 100]);

% create a set of cards - one holds a prompt for the user, the other the
% axes that we plot on
ud.cardlayout = xregcardlayout(fH,...
    'visible', 'off',...
    'currentcard', 1,...
    'numcards', 2);   
attach( ud.cardlayout, promptcard, 1);
attach( ud.cardlayout, Brdr, 2);

ud.Tp= Tp;
ud.data = [];
% Data is empty if called from mv_localreg, in which case data 
% should be extracted from the testplan. If called in mv_automatch
% then data is passed in at the beginning
if ~isempty(data)
	if isa(data,'xregpointer');
		data= info(data);
	end
	ud.data= data;
end
%% all info contained in gridlayout
set(ux,'userdata',ud);

Monitor=getMonitor(Tp.info);
if ~isfield(Monitor,'values')
	Monitor.values=[];
	Monitor.Xdata=[];
	setMonitor(Tp.info,Monitor);
end

% create blank axes in gridlayout
i_createaxes(fH,Tp);
lyout = ud.cardlayout;
return

%---------------------------------------------------------------------------
% SUBFUNCTION i_createaxes
%---------------------------------------------------------------------------
function i_createaxes(fH,Tp)
% create the n by m grid of axes, and leave bare ready for plotting

plotAxes= findobj(fH,'tag','monitor context menu');
udAx= get(plotAxes,'userdata');
Monitor=getMonitor(Tp.info);
if isempty(Monitor)
	return
end
% create the new Axes
num = length(Monitor.values);

% show the correct card
if (num==0)
    % No monitor variables - show the promot card
    set(udAx.cardlayout, 'CurrentCard', 1);
else
    % Show the monitor plots card
    set(udAx.cardlayout, 'CurrentCard', 2);
end

NewAx={};
for i=1:num
	ax = axes('parent',fH,...
		'visible','off',...
		'units','pixels',...
		'xgrid','on','ygrid','on',...
		'uicontextmenu',udAx.contmenu,...
		'Box','on',...
		'NextPlot','ReplaceChildren',...
		'userdata',i,...
        'buttondownfcn','mv_zoom',...
		'tag','MonitorAxes',...
		'defaultlinehittest','off');
	NewAx{i} = ax;
end

%% put axes in pairs into xregaxesinput
el={}; ind=1;
if num==1
        el{1} = xregaxesinput(fH,NewAx{1},'visible','off');
        set(el{1},'gapx',30);
        set(el{1},'NUMCELLS',1);
else
    for i = 1:2:num-1
        el{ind} = xregaxesinput(fH,[NewAx{i}, NewAx{i+1}],'visible','off');
        set(el{ind},'gapx',30);
        ind=ind+1;
    end
    if rem(num,2)
        el{ind} = xregaxesinput(fH,NewAx{i+2},'visible','off');
        set(el{ind},'gapx',30);
        set(el{ind},'NUMCELLS',2);
    end
end
%% setting new controls also deletes old ones (inside xreglistctrl\set)
set(udAx.grd,'elements',el);

% set(udAx.grd,'visible','on');



return


%---------------------------------------------------------------------------
% SUBFUNCTION i_plot
%---------------------------------------------------------------------------
function i_plot(fH,Tp,SNo,p_md)

% Assume i_plot is always called with a valid Sweep no. SNo
% get the monitor settings
Monitor=getMonitor(Tp.info);
plotAxes= findobj(fH,'tag','monitor context menu');
udAx= get(plotAxes,'userdata');

data = udAx.data;

% Does the data need to be got from the testplan? This happens in mv_localreg
if isempty(data)
    data = getdata(p_md.info,'ALLDATA');
end

% Get the test lognos for printing
testn=testnum(data);

num= length(Monitor.values);

% Do we need to plot anything?
if num~=0 & ~isempty(SNo)
	el=get(udAx.grd,'elements');
	if ~isempty(el)
        ah=[];
		for i=1:length(el)
            %% get the handles of the axes from the xregaxesinput objects
            ah = [ah(:);get(el{i},'axes')]; 
		end
	else
		ah=[];
	end
	% plot the data
	if udAx.OutliersValid
		i_specialoutliersplot(Tp.info,ah,SNo,data,p_md);
	else
		plot(Tp.info,ah,SNo,data);
	end
	
	% update the titles
	for i=1:num
		tH= get(ah(i),'title');
		str= get(tH,'string');
		if length(Tp.designdev)>1
			set(tH,'string',['Test ',sprintf('%d',testn(SNo)),' - ',str]);
		end
	end
    set(udAx.grd,'numcells',min(ceil(num/2),2));
    set(udAx.grd,'fixnumcells',min(ceil(num/2),2));
end

%---------------------------------------------------------------------------
% SUBFUNCTION i_specialoutliersplot
%---------------------------------------------------------------------------
function i_specialoutliersplot(TpInfo, ah, SNo, data, p_md)

% Get outlier userdata and handles to each monitor plot outlier line
oL = i_getOutlierLine;
delete(i_Cell2Mat(get(ah,{'children'})));
% Make sure each axes is in hold mode
set(ah,'nextplot','add');
% Reduce full sweepset to sweep being plotted
data = data(:,:,SNo);


% Find bad points for model m (note this gets both outliers and points
% which are complex owing to some y transform)
[X,Y,DataOK]= FitData(p_md.info,SNo);
badind= ~DataOK;
goodindex= find(DataOK);
% if no points are good the line drawing below will fail, so give it one
% point to draw. Failure occurs because num2cell returns {} not {[]}
if isempty(goodindex)
	goodindex = 1;
end

% Remove bad points from all data in sweepset
data(badind) = NaN;
% plot the data
plot(TpInfo,ah,1,data);
% Now need to totally remove bad points from lines to get point indicies
% the same as diagnostic plots. So first find all sweeplines plotted
lines = findobj(ah,'Tag','SweepLines');

% Get their x and y data as a matrix
xdata = i_Cell2Mat(get(lines,{'xdata'}));
ydata = i_Cell2Mat(get(lines,{'ydata'}));

% Plot without bad data points
set(lines,...
	'hittest','on',...
	{'xdata'},num2cell(xdata(:,goodindex),2),...
	{'ydata'},num2cell(ydata(:,goodindex),2));

% Are the axis invisible? If so make the lines invisible. This is
% required because diagnosticplots and monitorplots are created at the
% same time. If the visibility of the lines isn't set then
% the plots can show on the wrong card
state = get(ah(1),'visible');
allLines = findobj(ah,'type','line');
set(allLines, 'visible', state);

%% check lines are being managed by outlierline
add(oL,lines);

% ------------------------------------------
% function i_update
% ------------------------------------------
function i_update(fH,Tp,SNo,p_md)

plotAxes = findobj(fH,'tag','monitor context menu');
ud = get(plotAxes,'userdata');

% mdev_local calculates potential outliers, so don't need to worry about it here
Monitor = getMonitor(Tp.info);

el = get(ud.grd,'elements');
ah=[];
if ~isempty(el)
    for i=1:length(el)
        ah = [ah(:);get(el{i},'axes')]; 
    end
end    
% If there is nothing to plot then delete axes and return
if isempty(Monitor) | isempty(Monitor.values)
    set(findobj(ah),'visible','off');
    return
else
    set(ah,'visible','on');
end
% Make sure that the number of axes matches the number of plots requested
if (length(ah) ~= length(Monitor.values))
	i_createaxes(fH,Tp);
end

% Has the current sweep changed - if so update the userdata with new sweep and modeldev
% SNo is used to detect if the sweep has changed and md is used in monitordlg updates
ud.SNo = SNo;
ud.p_md = p_md;

% Note if monitorPlots didn't need to work in mv_auotmatch we could use the 
% outlier line copies of SNo and p_md, but we cannot create an outlierline
% in mv_automatch, so must maintain our own copies of these variables

i_plot(fH,Tp,SNo,p_md);

% And update outliers if they are valid
if ud.OutliersValid
 	oL = i_getOutlierLine(fH);
	redraw(oL)
end

set(plotAxes,'userdata',ud);


% -------------------------------------------
% function i_canceloutliers
% -------------------------------------------
function i_canceloutliers(fH)

oL = i_getOutlierLine;
clear(oL);



% ------------------------------------------
% function i_monitordlg
% ------------------------------------------
function i_monitordlg(fH, SNo, p_md)
% If called from mv_localreg varargin is SNo, View. If called from mv_automatch just SNo
plotAx = findobj(fH,'tag','monitor context menu');
ud = get(plotAx,'userdata');

% run the file monitordlg
data = ud.data;
if isempty(data)
	data = getdata(p_md.info,'ALLDATA');
end

ok = monitordlg('create',ud.Tp,data);

% SNo and p_md inputs exists when called from mv_automatch or mv_localReg
% If it doesn't we have been called from mv_monitorplots and need to get the current
% Sweep and modeldev object
if nargin < 2
	SNo = ud.SNo;
	p_md = ud.p_md;
end

% Now redraw all the plots
if ok
	i_createaxes(fH,ud.Tp);
	i_plot(fH, ud.Tp, SNo, p_md);
end

% ------------------------------------------
% function i_applyoutliers
% ------------------------------------------
function i_applyoutliers

oL = i_getOutlierLine;
index = oL.outlierIndices;
clear(oL);
mv_LocalReg('applyoutliers', index);

% ------------------------------------------
% function i_restoreoutliers
% ------------------------------------------
function i_restoreoutliers

oL= i_getOutlierLine;
clear(oL);
mv_LocalReg('restoreoutliers');

%---------------------------------------------------------------------------
% SUBFUNCTION i_GetGridLayout
%---------------------------------------------------------------------------
function grid = i_getgridlayout(fH)

plotAxes = findobj(fH,'tag','monitor context menu');
ud = get(plotAxes,'userdata');
list = ud.grd;
top = get(list, 'top');
numCells = get(list, 'numvisible');
controls = get(list, 'controls');
grid = [];
for i = top:top + numCells - 1
	grid = [grid get(controls{i}, 'axes')'];
end
grid = grid';

% ------------------------------------------
% function i_Cell2Mat
% ------------------------------------------
function mat = i_Cell2Mat(cell,varargin)

dim = 1;
if length(varargin) > 0 
	dim = varargin{1};
end

mat = cat(dim,cell{:});

% ===========================================
% Function i_getOutlierLine
% ===========================================
function ol = i_getOutlierLine(hFig)

if ~nargin
	hFig = mvf;
end
plotAxes= findobj(hFig,'tag','monitor context menu');
udAx= get(plotAxes,'userdata');
ol = [];
if udAx.OutliersValid
	ol = udAx.oL;
end

% ===========================================
% Function i_Multiselect
% ===========================================
function i_Multiselect(caller, null, oL)
multiselect(oL);

