function varargout = plot(varargin)
% plot(oppoint,output,[input],[opt]) plots the given outputs against inputs
%  output may be: vector of xregpointers to expressions,
%                 expression object
%                 factor name
%                 factor index
%                  or cell array of any or all of these
%  input may be:  factor name (or cell array of names)
%                 factor index (or vector of indices)
%                 blank - plot all inputs
%  opt:           'combine' plots all outputs on single axis
%
% plot(oppoint) generates standalone figure with dataset output viewer,
%               allowing all expressions in the cg_front exprlist to be viewed.
% plot(oppoint,exprlist) generates standalone figure, allowing suitable
%     expressions in exprlist to be evaluated and viewed at the data points
%
% fig = plot(...) returns figure handle
%
% [ud] = plot(cgoppoint,'create',fig,lyt,ud) creates viewer in a layout 
%   (outline layout already defined in lyt, with userdata ud), with visible off.
%     Use plot('view',opptr) to view a particular dataset.
%     This uses the cg_front exprlist.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.11.2.6 $  $Date: 2004/04/12 23:35:02 $

if nargin==0
    error('cgoppoint::plot: insufficient arguments.');
elseif isa(varargin{1},'cgdatasetnode')
    if nargin>1 & ischar(varargin{2})
        switch lower(varargin{2})
        case 'get_callbacks'
            varargout{1} = i_GetCallbacks;
        end
    end
end

%-----------------------------------------------------------------------
function cb = i_GetCallbacks
%-----------------------------------------------------------------------
cb = [];
cb.View = @i_View;
cb.Show = @i_Show;
cb.Copy = @i_Copy;
cb.ExprClick = @i_ExprClick;
cb.Draw = @i_DrawPlotPage;
cb.CreateMenus = @i_CreateMenus;
cb.ShowIndex = @i_ShowIndex;
cb.ChangeView = @cb_ChangeView;
cb.ColorSelector = @cb_ColorSelector;
   
%------------------------------------------------------------------
function d = i_CreateMenus(d,cb)
%------------------------------------------------------------------
Handles = d.Handles;
% ------- menu 
Handles.tm.Plot = uimenu(d.ToolsMenu,'label','&Plot','callback',@cb_SetupMenu);
m = Handles.tm.Plot;
plm = [];
plm.View(1) = uimenu(m,'label','&Data Set',...
    'callback',{@cb_ChangeView,'dataset'});
plm.View(2) = uimenu(m,'label','&Surface',...
    'callback',{@cb_ChangeView,'surface'});
plm.View(3) = uimenu(m,'label','&Line',...
    'callback',{@cb_ChangeView,'line'});
plm.ErrorView = uimenu(m,'label','Show &Error',...
    'callback',{@cb_ShowError,'switch'},...
    'separator','on');
plm.SwapAxes = uimenu(m,'label','S&wap Axes',...
    'callback',@cb_SwapAxes);
plm.DoColor = uimenu(m,'label','&Color by Value',...
    'callback',{@cb_ColorSelector,'switch'}, ...
    'separator', 'on');
plm.LimitColor = uimenu(m,'label','Limit Color &Range',...
    'callback',{@cb_PlotStyle,'switchcolor'});
plm.PlotStyleM(1) = uimenu(m,'label','E&xclude',...
    'callback',{@cb_PlotStyle,'exclude'},...
    'separator','on');
plm.PlotStyleM(2) = uimenu(m,'label','&No Color Outside Limits',...
    'callback',{@cb_PlotStyle,'blank'});
plm.PlotStyleM(3) = uimenu(m,'label','Color &Outside Limits',...
    'callback',{@cb_PlotStyle,'color'});
Handles.tm.h = [Handles.tm.h m];

% ------ context menu to go over color bar
m = uicontextmenu('parent',Handles.Figure,'callback',@cb_SetupMenu);
Handles.ColorBarMenu = m;
plm.View(4) = uimenu(m,'label','&Data Set',...
    'callback',{@cb_ChangeView,'dataset'});
plm.View(5) = uimenu(m,'label','&Surface',...
    'callback',{@cb_ChangeView,'surface'});
plm.View(6) = uimenu(m,'label','&Line',...
    'callback',{@cb_ChangeView,'line'});
plm.ErrorView(2) = uimenu(m,'label','Show &Error',...
    'callback',{@cb_ShowError,'switch'},...
    'separator','on');
plm.SwapAxes(2) = uimenu(m,'label','S&wap Axes',...
    'callback',@cb_SwapAxes);
plm.DoColor(2) = uimenu(m,'label','&Color by Value',...
    'callback',{@cb_ColorSelector,'switch'},...
    'separator','on');
plm.LimitColor(2) = uimenu(m,'label','Limit Color &Range',...
    'callback',{@cb_PlotStyle,'switchcolor'});
plm.PlotStyleM(4) = uimenu(m,'label','E&xclude',...
    'callback',{@cb_PlotStyle,'exclude'},...
    'separator','on');
plm.PlotStyleM(5) = uimenu(m,'label','&No Color Outside Limits',...
    'callback',{@cb_PlotStyle,'blank'});
plm.PlotStyleM(6) = uimenu(m,'label','Color &Outside Limits',...
    'callback',{@cb_PlotStyle,'color'});
Handles.plm = plm;

d.Handles = Handles;

%------------------------------------------------------------------
function [d,lyt] = i_DrawPlotPage(d);
%------------------------------------------------------------------
fig = d.Handles.Figure;
bgCol = get(fig,'color');
Handles = d.Handles;

%------------ viewer

Handles.DataDisplay = xregmultigraph2d(fig,'type','single',...
    'backgroundcolor',bgCol,'visible','off','frame','off',...
    'colorlimitstyle','limit',...
    'colorexcludestyle','blank',...
    'grid','on','uicontextmenu',Handles.ColorBarMenu);

% Do this now, otherwise it may get triggered during creation.
set(Handles.DataDisplay,'singleplotcallback',{@cb_SetLegend,'off'},...
    'multiplotcallback',{@cb_SetLegend,'on'} ,'callback', @cb_CheckShowError);

plotpanel = xregpanellayout(fig, ...
    'packstatus', 'off', ...
    'visible', 'off', ...
    'center', Handles.DataDisplay);

% legend axes
Handles.Legend = xreglegend(fig, ....
    'visible','off', ...
    'backgroundcolor', bgCol);

Handles.LegendFrame=xregframetitlelayout(fig,...
    'visible','off',...
    'center',Handles.Legend,...
    'innerborder', [5 5 5 5]);

Handles.LegendSplit = xregsplitlayout(Handles.Figure , ...
    'visible','off',...
    'top' , Handles.LegendFrame ,...
    'bottom', plotpanel ,...
    'orientation' , 'ud',...
    'dividerstyle','flat',...
    'dividerwidth',4,...
    'split',[0.2 0.8]);

% This card switches the legend on and off
Handles.LegendDisplayCard = xregcardlayout(fig, ...
    'visible', 'off', ...
    'numcards', 2, ...
    'drawonselect', 'on');
attach(Handles.LegendDisplayCard, plotpanel, 1);
attach(Handles.LegendDisplayCard, Handles.LegendSplit, 2);

Handles.PlotCard = xregcardlayout(Handles.Figure,'numcards',1,'visible','off');
attach(Handles.PlotCard, Handles.LegendDisplayCard, 1);

d.Handles = Handles;
d.Plot.DoColor = 0;
d.Plot.DoPE = 0;
d.Plot.Style = 'blank';
d.Plot.LimitColor = 0;
d.Plot.SetupCB = @i_SetupPlot;
d.Plot.PlotCB = @i_MultiPlot;
d.Plot.TableCB = @i_TablePlot;
d.Plot.ColorSelectorCB = @i_ColorSelector;
% Show Error now has three values 
% -1    : Not active (i.e. number of things being plotted ~= 2)
% 0     : Active but not wanting to show error
% 1     : Active and showing error
d.Plot.ShowError = -1;
d.Plot.SwapAxes = 0;
d.Plot.ListType = 'outputs';

lyt = Handles.PlotCard;


%-------------------------------------------------------------------------
% Equation Page
% ~~~~~~~~ ~~~~
% 
% Export datadisplay
%
%-------------------------------------------------------------------------




%------------------------------------------------------------------------
function Fig = i_TempFig(d)
%------------------------------------------------------------------------
% Copy display to temporary figure
%  for export

% set to same size as card
pos = get(d.Handles.TopCard,'position');
pos(3:4) = pos(3:4) + 10; % account for border
% NB: Fig color is taken as transparent.
Fig=figure('visible' , 'off' , 'menubar' , 'none' , 'numbertitle' , 'off',...
    'position',pos);
temp = copyobj(d.Handles.DataDisplay,Fig);

% check whether this is a multiplot
set(temp,'backgroundcolor',get(Fig,'color'));
legendpatch = [];
vis ={temp}; grid = temp;
if strcmp(get(d.Handles.DataDisplay,'showlegend'),'on')
    % copy legend
    Legend = copyobj(d.Handles.Legend,Fig);

    split = get(d.Handles.LegendSplit,'split');
    botheight = pos(4)*split(1);
    legendpatch=xregrectangle('parent',getbgaxes(xregGui.figureaxes,Fig),...
        'edgecolor','k',...
        'facecolor','none',...
        'visible','off',...
        'hittest','off');
    grid = xreggridlayout(Fig,'packstatus','off',...
        'correctalg','on',...
        'dimension',[2 1],...
        'gapy',10,...
        'elements',{temp Legend},...
        'rowsizes',[-1 botheight]);
    vis = {Legend temp legendpatch};
end

%---copy obj end
bl = xregborderlayout(Fig, 'center', grid,...
   'packstatus','on',...
    'border',[5 5 5 5],...
    'container',Fig);

for i = 1:length(vis)
    set(vis{i},'visible','on');
end
if ~isempty(legendpatch)
    % sort out positions
    pos = get(Legend,'position');
    set(Legend,'position',[pos(1)+5 pos(2)+5 pos(3)-10 pos(4)-10]);
    % printing uses correct fontsize; 
    %  figure rendering uses approximation. Positioning is done
    %  using extent of font on screen, so this may give overlapping
    %  labels when correct fontsize is used. Select small font to 
    %  avoid this (figure rendering uses larger font)
    set(Legend,'fontsize',6);
    ax = get(Legend,'axes');
    bgc = get(Fig,'color');
    % set transparencies
    set(ax,'color',bgc,'Xcolor',bgc,'ycolor',bgc);
    set(legendpatch,'position',pos);
end
% get rid of axes selectors (don't want to print them - same info is on axes labels)
cb = get(temp,'colorbar');
del = [get(temp,'xpopup') get(temp,'ypopup') get(temp,'xtext') get(temp,'ytext') ...
        get(cb,'colorbarpopup') get(cb,'colorbartext') get(cb,'userangehandles')];
set(del,'visible','off');
set(Fig,'visible','on');

%-------------------------------------------------------------------------
function i_PrintPrinter
%-------------------------------------------------------------------------
Fig=i_TempFig(d);
print(Fig);
delete(Fig);


%-------------------------------------------------------------------------
function data = i_Copy(d)
%-------------------------------------------------------------------------
Fig=i_TempFig(d);
set(Fig,'PaperPositionMode','auto');
print(Fig , '-dmeta')
delete(Fig);
data=[];


%-------------------------------------------------------------------------
function i_PrintFile;
%-------------------------------------------------------------------------
d=pr_GetViewData;

[fname,pname] = uiputfile('*.jpg' , 'Save As');

if isnumeric(fname) | isnumeric(pname)
   return;
end

Fig=i_TempFig(d);

%Now, infer from the filename extension what sort of file to save as.
indx=find(fname=='.');

if isempty(indx)
   ftype='jpg';
else
   ftype=fname(indx+1:end);
end

switch ftype
case {'jpg','jpeg'}
   print(Fig , '-djpeg' , '-r0' ,  [pname fname]);
case 'ps'
   print(Fig , '-dps' , [pname fname]);
case 'psc'
   print(Fig , '-dpsc' , [pname fname]);
case {'tif','tiff'}
   indx=find(fname=='.');
   fname = [fname(1:indx) 'tif'];
   print(Fig , '-dtiffnocompression' , '-r0' , [pname fname]);
otherwise
   h=errordlg(['File type ' ftype ' is not supported in Cage.' , 'Cage' , 'modal']);
   uiwait(h);
end

delete(Fig);

%-----------------------------------------------------------------------
function d = i_Show(d)
%-----------------------------------------------------------------------
pr_ConfigureExprList(d.Handles.ExprList,d.Handles.BottomList);

[state,key] = i_ButtonState(d.Plot.ListType);

d.Handles.fm.BmVis = d.Handles.fm.PlotVis;
set(d.Handles.ExprList,'sortorder',0);
set(d.Handles.ExprList,'sortkey',key);
d.Plot.ViewEnable = {'on','off','off'};
d.Table.TopMode = 'dataset';
set(d.Handles.PlotCard,'currentcard',1);
set(d.Handles.DataDisplay,'uicontextmenu',d.Handles.ColorBarMenu);
d.CB.Replot = @i_ExprClick;

%-----------------------------------------------------------------------
function d = i_View(d,sel_name)
%-----------------------------------------------------------------------
if nargin<2
    sel_name = -1;
end
% Ensure that multi graph has correct callback and buttondownfcn
ax = get(d.Handles.DataDisplay,'axes');
set(ax,'buttondownfcn','mv_zoom');
set(d.Handles.DataDisplay,'callback', @cb_CheckShowError);
d = pr_RefreshExprList(d,sel_name,d.Plot.ListType);
d = i_ExprClick(d);



%-----------------------------------------------------------------------
function [state,sortkey] = i_ButtonState(opt)
%-----------------------------------------------------------------------
state = [0 0 0];
sortkey = 0;
switch opt
case 'outputs'
    state(1) = 1;
case 'feature'
    state(2) = 1;
case 'dataset'
    state(3) = 1;
    sortkey = 3;
end

%-----------------------------------------------------------------------
function d = i_ShowIndex(d,index)
%-----------------------------------------------------------------------
if all(ismember(index,d.Exprs.BottomShown))
    pr_ExprListSelect(d.Handles.ExprList,index);
else
    d.Plot.ListType = 'outputs';
    [state,key] = i_ButtonState(d.Plot.ListType);
    d = pr_RefreshExprList(d,index,'outputs');
    set(d.Handles.ExprList,'sortkey',key);
    set(d.Handles.ExprList,'sortorder',0);
    d = i_ExprClick(d);
end
    

%-----------------------------------------------------------------------
function d = i_ExprClick(d,l)
%-----------------------------------------------------------------------
% display output for selected expr/factor
% build up data for each selected output
%  check inputs are compatible.

uimenu = 0;

factors = []; data = []; done = [];
all_ptrs = [];  names = []; itemnames = [];
invalid = []; done_index = []; units = [];
pevdata = []; 
mess = '';

opfactors = d.pD.get('factors');
ptrlist = d.pD.get('ptrlist');
group = d.pD.get('group');
opdata = d.pD.get('data');
opunits = d.pD.get('units');
[in_i,out_i,ig_i] = getFactorTypes(d.pD.info);

ind = pr_getExprListSelection(d.Handles.ExprList);
if get(get(d.Handles.ExprList,'listitems'),'count')==0 
    mess = 'No items are available.';
elseif any(size(opdata)==0)
    mess = 'Data set is empty.';
    ind = [];
elseif isempty(ind)
    % Generally get here when have just switched to the plot view
    % So, force color by value to be enabled here
    set(d.Handles.plm.DoColor, 'enable', 'on');
    mess = 'Select an expression to view at data set points...';
end
if isempty(ind)
    index = [];
else
    index = get(d.Handles.ExprList,'selecteditemindex');
end

% no change in selection? (eg after right click)
%  Exit.
if isempty(mess) & ~isempty(index) & ~isempty(d.Exprs.plot_index) & ...
        length(index)==length(d.Exprs.plot_index) &...
        all(index==d.Exprs.plot_index) & ...
        ~d.Plot.SwapAxes & ...
        d.Plot.ShowError == -1
    return
end

PR=xregGui.PointerRepository;
ID=PR.stackSetPointer(d.Handles.Figure, 'watch');

units1 = junit;

if isempty(mess)
    
    [tptrs,linkptrs,itemnames,units,cr_flag,value_ind,return_ind] = ...
        ExpandPtrs(d.pD.info,d.Exprs.ptrs(ind),d.Exprs.factor_index(ind));
    itemnames = i_CheckFeatLegNames(tptrs, itemnames, linkptrs);
    return_ind = ind(return_ind);
    % replace feature ptrs with relevant model/equation
    f = find(isvalid(linkptrs));
    tptrs(f) = linkptrs(f);
    [isinput] = getIsFactorType(d.pD.info);
    
    % cr_flag indicates origin of ptr:
    %  1 = dataset only; -1 = Cage; -2 = complicated Cage;
    % - 3 overwritten by dataset.
    ptrs = []; 
    fact_i = d.Exprs.factor_index(return_ind);
    for i = 1:length(tptrs)
        if d.Exprs.eval(return_ind(i))
            if d.Exprs.factor_index(return_ind(i)) & isinput(d.Exprs.factor_index(return_ind(i)))
                % input dataset factor? Flag as using
                %  all inputs (must be able to plot alongside
                %  anything else)
                all_ptrs = [all_ptrs {1}];
            else
                switch cr_flag(i)
                case 1
                    all_ptrs = [all_ptrs {1}];
                case -3
                    % Check that ptr can be evaluated normally
                    optmp = d.pD.set(fact_i(i),'overwrite',0);
                    if check_eval(optmp,tptrs(i))
                        all_ptrs = [all_ptrs {tptrs(i).getptrs}];
                    else
                        % cannot evaluate - add to invalid list
                        invalid = [invalid i];
                    end
                otherwise
                    all_ptrs = [all_ptrs {tptrs(i).getptrs}];
                end
            end
        else
            invalid = [invalid i];
        end
    end
    keep = setdiff(1:length(cr_flag),invalid);
    cr_flag = cr_flag(keep);
    ptrs = tptrs(keep);
    fact_i = d.Exprs.factor_index(return_ind(keep));
    units = units(keep);
    itemnames = itemnames(keep);
    
    % Check that at least one thing is valid
    if ( (length(invalid)==length(return_ind)) ) & ~isempty(ind) %(length(invalid) == length(ind)) | 
        if length(ind)==1
            mess = {[d.Exprs.names{ind} ' cannot be evaluated.']};%,get(this,'subitems',2)};
            needstr = i_InputsRequired('',d.Exprs.need_ptrs{ind});
            if d.pD.isImported
                mess = [mess {'Ensure data is assigned to variables',...
                            needstr}];
            else
                mess = [mess {'Ensure these variables are included in data set:',needstr}];
            end
        else
            mess = {'No items can be evaluated.'};
        end
    elseif length(ptrs)==0 & length(ind)==1
        % Check for single feature with nothing to display.
        if d.Exprs.ptrs(ind).isa('cgfeature')
            mess = {[d.Exprs.ptrs(ind).getname ' has no model or equation.']};
        else
            % Could get here if clicked on two empty features.
            mess = 'No items can be evaluated.';
        end
    else
        inptrs = ptrlist(in_i);
        % Check inputs required
        [mess,inputs,in_match] = i_Checkinputs(mess,itemnames,all_ptrs,ptrlist,in_i);
        % Keep only inputs which are used
        in_i = in_match;
    
        % Check units
        [mess,displayunits] = i_CheckUnits(mess,units,itemnames);
    end
end


if isempty(mess)
    % Check the number of things we're about to evaluate
    %  Display a message if there is a lot of them.
    if length(index)>20 & length(d.Exprs.plot_index)<=20 | ...
          (length(index) - length(d.Exprs.plot_index))>20 | ...
          length(index)>50
       but = questdlg({'Evaluation of these expressions',...
             'may take some time.  Continue?'},...
          'Data Set Viewer','Continue','Cancel','Cancel');
       switch but
       case 'Cancel'
          listitems = d.Handles.ExprList.ListItems;
          % deselect the stuff that's just been selected
          for i = 1:length(index)
             this = listitems.Item(index(i));
             set(this,'selected',0);
          end
          % reselect the old stuff
          for i = 1:length(d.Exprs.plot_index)
             this = listitems.Item(d.Exprs.plot_index(i));
             set(this,'selected',1);
          end
          EnsureVisible(this);
          % exit
          return
       end
    end
    
    opfactors = d.pD.get('factors');
    if length(ptrs)==1
        titlestr = itemnames{1};
    else
        titlestr = 'Selected Items';
    end
    matchname = itemnames;
    pevdata = [];
    pevname = [];
    if d.Plot.DoPE
        [pevdata,pevvalid] = i_PevData(ptrs,cr_flag,opdata,d.pD.info);
        % May not have been able to calculate PE for anything
        if ~isempty(pevvalid)
            pevname = {'Prediction Error'};
            matchname = pevname;
        else
            pevdata = [];
            mess = 'No prediction errors can be evaluated.';
            uimenu = d.Handles.ColorBarMenu;
        end
        %titlestr = [titlestr ' (Prediction Error)'];
    end
    unitstr = char(displayunits);
    % Sort out plot colors
    if d.Plot.DoColor
        [col_mat,mark_mat] = ColorMatrix(d.Handles.Legend,length(itemnames),'k');
    else
        [col_mat,mark_mat,isrepeated] = ColorMatrix(d.Handles.Legend,length(itemnames));
    end
    if ~d.Plot.DoColor & ~isrepeated
        old_col = get(d.Handles.DataDisplay,'markercolor');
        old_mark = get(d.Handles.DataDisplay,'marker');
        old_items = get(d.Handles.DataDisplay,'userdata');
        [col_mat,mark_mat] = MatchColor(d.Handles.Legend,col_mat,mark_mat,itemnames,old_col,old_mark,old_items);
    end
    set(d.Handles.DataDisplay,'userdata',itemnames);

    if length(ptrs)>1 & isempty(mess)
        indata = [[1:size(opdata,1)]' opdata(:,in_i)];
        fnames = getFactorsAndUnits(d.pD.info,in_i);
        infactors = {'Data set point' fnames{:}};
        if d.Plot.DoPE  
            if isempty(pevdata)
                mess = 'No prediction errors can be evaluated.';
                uimenu = d.Handles.ColorBarMenu;
            elseif ~d.Plot.DoColor
                titlestr = [titlestr ' (Prediction Error)'];
            end
            if length(pevvalid)>1
                data = pevdata;
            end
            valid = pevvalid;
        else
            [data,valid] = i_Data(ptrs,cr_flag,opdata,fact_i,units,displayunits,d.pD.info);
            % May drop through to normal single plot.
            if isempty(valid)
                mess = 'No items can be evaluated.';
            end
        end
        if ~isempty(data), data = data(:,valid); end
        if ~isempty(pevdata), pevdata = pevdata(:,valid); end
        itemnames = itemnames(valid);
        ptrs = ptrs(valid);
        fact_i = fact_i(valid);
        if ~isempty(data) & length(ptrs)>1
            set(d.Handles.Legend,'items',itemnames,...
                'marker',mark_mat,...
                'markerfacecolor',col_mat);
                d.Plot.ShowError = -1;

            if d.Plot.DoColor
                % colorbar on
                set(d.Handles.DataDisplay,'type','multi',...
                    'currentyfactor', 1, ...
                    'title','','yunit',unitstr,...
                    'data',indata,'factors',infactors,...
                    'ydata',data,'cdata',pevdata,...
                    'yfactors',itemnames,...
                    'colorfactor',pevname,...
                    'markercolor',col_mat,'marker',mark_mat,...
                    'fillmask',inputs);
            else
                % colorbar off
                % ammended CH 31/8/01 - added 'currentyfactor',1 to avoid a problem described by DCL#2557
                set(d.Handles.DataDisplay,'type','multi',...
                    'currentyfactor', 1, ...
                    'title','','yunit',unitstr,...
                    'data',indata,'factors',infactors,...
                    'ydata',data,...
                    'yfactors',itemnames,...
                    'markercolor',col_mat,'marker',mark_mat,...
                    'fillmask',inputs);
            end
        end
    end
        
        
    if length(ptrs)==1 & isempty(mess)
        [data,itemnames,valid] = i_SingleView(ptrs,d.pD.info,fact_i,inptrs);
        % single plot
        if ~valid
            mess = [matchname{1} ' cannot be evaluated.'];
        else
            data = [[1:size(opdata,1)]' data pevdata opdata(:,in_i)];
            fnames = getFactorsAndUnits(d.pD.info,in_i);
            factors = [{'Data set point'} itemnames pevname fnames];
            yfac = [];xfac = [];
            oyfac = get(d.Handles.DataDisplay,'currentyfactor');
            xfac = get(d.Handles.DataDisplay,'currentxfactor');
            if isempty(itemnames)
                yfac = find(in_i==fact_i) + 1;
            else
                yfac = 2;
            end
            if isempty(yfac)
                yfac = oyfac;
            end
            if d.Plot.SwapAxes
                currentX = get(d.Handles.DataDisplay, 'currentxfactor');
                currentY = get(d.Handles.DataDisplay, 'currentyfactor');                
                yfac = currentX;
                xfac = currentY;
                d.Plot.SwapAxes = 0;
            end

            % Colorbar plot.doColor
            set(d.Handles.DataDisplay,'type','single',...
                'markercolor',col_mat,'marker',mark_mat,...
                'title','',...
                'cdata',pevdata,'colorfactor',pevname,...
                'data',data,'factors',factors,...
                'currentyfactor',yfac, ...
                'currentxfactor',xfac);
            d.Plot.ShowError = -1;
        end
        
        
    end
end
if ~isempty(mess)
    pr_Message(d,mess,uimenu);
    done_index = [];
else
    set(d.Handles.TopCard,'currentcard',d.currentcard);
end
%if displayunits~=d.Exprs.UnitFilter
if isempty(mess) & ~strcmp(char(displayunits),char(d.Exprs.UnitFilter))
    d = feval(d.CB.RefreshList,d,'bottom',-1,displayunits);
    d.Exprs.UnitFilter = displayunits;
end
% Store current selection - can check if anything has changed next time
d.Exprs.plot_index = index;
PR.stackRemovePointer(d.Handles.Figure, ID);
% Refresh the view data - which should refresh the menus
%pr_SetViewData(d);

%-----------------------------------------------------------------------
function [mess,inputs,match] = i_Checkinputs(mess,itemnames,all_ptrs,ptrlist,in_i)
%-----------------------------------------------------------------------
maxno = -1; max_i = 1; flag = 0;  inputs = {[]};
for i = 1:length(all_ptrs)
    ptrs = all_ptrs{i};
    keep = [];
    if isnumeric(ptrs)
        inputs{i} = in_i;
    elseif ~isempty(ptrs)
        for j = 1:length(in_i)
            if any(ptrs==ptrlist(in_i(j)));
                keep = [keep j];
            end
        end
        % these are the dataset inputs used by this item
        inputs{i} = in_i(keep);
    else
        % (May be a value - do something else here)
        inputs{i} = [];
    end
    % find item which takes maximum number of inputs
    if length(inputs{i})>maxno
        maxno = length(inputs{i});
        max_i = i;
    end
end
match = inputs{max_i};
for i = 1:length(inputs)
    % check that all inputs used belong to the maximal group
    if ~isempty(setdiff(inputs{i},match))
        flag = 1;
    end
end
if flag
    % Mismatched inputs - cannot display
    if length(all_ptrs)>4
        mess = {'Items require different inputs.'};
    else
        mess = {'Items require different inputs:'};
        for i = 1:length(all_ptrs)
            mess = [mess {i_InputsRequired([itemnames{i} ': '],ptrlist(inputs{i}))}];
        end
    end
else
    % build up inputs matrix.
    % Outputs are shown as filled blobs if plotted against an input
    %  they depend on, and empty blobs if plotted against a non-dependant.
    in_i = match;
    temp = [];
    for i = 1:length(inputs)
        % first column is data point - always included
        temp(i,:) = [1 ismember(in_i(:)',inputs{i})];
    end
    inputs = temp;
end

%-----------------------------------------------------------------------
function str = i_InputsRequired(str1,ptrs)
%-----------------------------------------------------------------------
str = '';
for j = 1:length(ptrs)
    if isvalid(ptrs(j))
        str = [str ptrs(j).getname ', '];
    end
end
if ~isempty(str)
    str = [str1 str(1:end-2) '.'];
else
    str = [str1 'none.'];
end

%-----------------------------------------------------------------------
function [mess,displayunits] = i_CheckUnits(mess,units,itemnames)
%-----------------------------------------------------------------------
if length(units)>1
    % check everything else against this.
    unitstr = {};
    displayunits = junit;
    for i = 1:length(units)
        if ~isempty(units{i}) & isvalid(units{i})
            if isempty(displayunits)
                % nothing to check against yet
                displayunits = units{i};
                ind1 = i;
            else
                % check against stored unit
                if ~compatible(units{i},displayunits)
                    unitstr = [unitstr {[itemnames{i} ': ' char(units{i})]}];
                end
            end
        end
    end
    if ~isempty(unitstr)
        if length(unitstr)>4
            mess = 'Items have incompatible units.';
        else
            mess = [{'Items have incompatible units:'} ...
                    {[itemnames{ind1} ': ' char(displayunits)]} ...
                    unitstr];
        end
        % Don't change list
        %displayunits = d.Exprs.UnitFilter;
    end
else
    displayunits = units{1};
end

%-----------------------------------------------------------------------
function [data,validdata] = i_Data(ptrs,cr_flag,opdata,fact_i,units,displayunits,op)
%-----------------------------------------------------------------------
data = [];
for i = 1:length(ptrs)
    switch cr_flag(i)
    case 1
        data = [data opdata(:,fact_i(i))];
    case -3
        % overwritten by dataset
        data = [data i_eval(op,fact_i(i),'trueeval')];
    otherwise
        data = [data i_eval(op,ptrs(i))];
    end
    % ensure data in same units
    if ~isempty(units{i})
        data(:,i) = convert(units{i},displayunits,data(:,i));
    end
end
validdata = find(~all(isnan(data)));

%-----------------------------------------------------------------------
function [pevdata,validdata] = i_PevData(ptrs,cr_flag,opdata,op)
%-----------------------------------------------------------------------
pevdata = [];
for i = 1:length(ptrs)
    switch cr_flag(i)
    case 1
        pevdata = [pevdata repmat(nan,size(opdata,1),1)];
    otherwise
        % pev eval returns trueeval anyway- don't worry about
        %  overwritten ptrs.
        if ptrs(i).isa('cgmodexpr')
            pevdata = [pevdata i_eval(op,ptrs(i),'pev')];
        else
            pevdata = [pevdata repmat(nan,size(opdata,1),1)];
        end
    end
end
validdata = find(~all(isnan(pevdata)));

%-----------------------------------------------------------------------
function [data,itemnames,valid] = i_SingleView(ptr,oppoint,fact_i,inptrs)
%-----------------------------------------------------------------------
% Check for special cases - eg. error
% Check also for selecting an input - these are added to the
%  data matrix anyway, so remove any input factors at this point.
if isvalid(ptr)
    tempObj = ptr.info;
    if isa(tempObj,'cgdivexpr') | isa(tempObj,'cgsubexpr')
        % show extra information for simple equations:
        %  for a = b - c, show errors
        %  for a = b + c, show a, b and c.
        titlestr = [getname(tempObj) ' = ' char(tempObj)];
        if isa(tempObj,'cgsubexpr')
            left = get(tempObj,'left');
            right = get(tempObj,'right');
        else
            left = get(tempObj,'top');
            right = get(tempObj,'bottom');
        end
        if isa(tempObj,'cgsubexpr') & length(left)==1 & length(right)==1
            % subtraction of one object from another - can form an error for this one
            [data,itemnames] = i_GenerateView('error',oppoint,inptrs,left,right,ptr);
        elseif length([left(:) ; right(:)])==2
            % Two things - show as much info as we can
            lr = [left(:) ; right(:)];
            [data,itemnames] = i_GenerateView('double',oppoint,inptrs,ptr,lr(1),lr(2));
        else
            [data,itemnames] = i_GenerateView('single',oppoint,inptrs,ptr);
            if strmatch(itemnames, 'Sum', 'exact')
                allnames = get(oppoint, 'orig_name');
                itemnames = allnames(fact_i);
            end
        end
    else
        %if ~d.Exprs.factor_index(done_index)
        [data,itemnames] = i_GenerateView('single',oppoint,inptrs,ptr);
    end
else
    [data,itemnames] = i_GenerateView('single',oppoint,inptrs,fact_i);
end
valid = ~any(all(isnan(data)));

%-----------------------------------------------------------------------
function [data,factors] = i_GenerateView(type,oppoint,inptrs,ptr1,ptr2,ptr3)
%-----------------------------------------------------------------------
% inptrs contains ptrs which are input factors.
%  These inputs will be shown regardless, so if they crop up here,
%  they should not be included (this would give a double occurrence)

% Ensure inptrs is not empty (creates warnings)
if isempty(inptrs)
    inptrs = xregpointer;
end
switch type
case 'error'
    % subtraction of one object from another - can form an error for this one
    leftdata = i_eval(oppoint,ptr1);
    rightdata = i_eval(oppoint,ptr2);
    err = leftdata - rightdata;
    relerr = err./(rightdata + eps).*100;
    data = [err abs(err) relerr abs(relerr) leftdata rightdata];
    if nargin>5 
        thisname = ptr3.getname;
        f = findstr('_minus_',thisname);
    else
        f = [];
    end
    if length(f)==1
        lname = thisname(1:f-1);
        rname = thisname(f+7:end);
        errname = [' (' lname ' - ' rname ')'];
        factors = {['Error' errname] ['Absolute Error' errname], ['Relative Error (%)' errname] ...
                ['Absolute Relative Error (%)' errname] lname rname};
    else
        factors = {'Error' 'Absolute Error' 'Relative Error (%)' ...
                'Absolute Relative Error (%)' ptr1.getname ptr2.getname};
    end
    fl = any(ptr1==inptrs);
    fr = any(ptr2==inptrs);
    keep = 1:6;
    if fr
        keep(6) = [];
    end
    if fl
        keep(5) = [];
    end
case 'double'
    leftdata = i_eval(oppoint,ptr2);
    rightdata = i_eval(oppoint,ptr3);
    tot = i_eval(oppoint,ptr1);
    data = [tot leftdata rightdata];
    factors = {ptr1.getname ptr2.getname ptr3.getname };
    f1 = any(ptr1==inptrs);
    f2 = any(ptr2==inptrs);
    f3 = any(ptr3==inptrs);
    keep = (~[f1 f2 f3]);
case 'single'
    if isnumeric(ptr1)
        factors = get(oppoint,'factors');
        factors = factors(ptr1);
        units = get(oppoint,'units');
        units = units{ptr1};
        keep = ~(oppoint.factor_type(ptr1)==1);
        opdata = get(oppoint,'data');
        data = opdata(:,ptr1);
    else
        units = ptr1.grabUnits;
        factors = {ptr1.getname};
        keep = (~any(ptr1==inptrs));
        data = i_eval(oppoint,ptr1);
    end
    if ~isempty(units)
        factors{1} = [factors{1} ' (' char(units) ')'];
    end
case 'multi'
    data = i_eval(oppoint,ptr1);
    factors = {ptr1.getname};
    % for multiple display, never discard any columns
    keep = 1;
    %(~any(ptr1==inptrs));
end
data = data(:,keep); factors = factors(keep);

%-----------------------------------------------------------------------
function cb_ColorBar(varargin)
%-----------------------------------------------------------------------
d = pr_GetViewData;
ud = get(d.Handles.DataDisplay,'userdata');
if ~isempty(ud.callback)
    if iscell(ud.callback)
        if length(ud.callback)>1
            d = feval(ud.callback{1},d,ud.callback{2:end});
        else
            d = feval(ud.callback{1},d);
        end
    end
end
d = i_MultiPlot([],[],ud.ycb2,d);
pr_SetViewData(d);

%-----------------------------------------------------------------------
function cb_Factor(varargin)
%-----------------------------------------------------------------------
d = pr_GetViewData;
ud = get(d.Handles.DataDisplay,'userdata');
if ~isempty(ud.callback)
    if iscell(ud.callback)
        if length(varargin)>2
            d = feval(ud.callback{1},d,varargin{3:end});
        else
            d = feval(ud.callback{1},d);
        end
    end
else
    d = i_MultiPlot([],[],ud.ycb2,d);
end
pr_SetViewData(d);

%-----------------------------------------------------------------------
function cb_SetLegend(src,ev,state,d);
%-----------------------------------------------------------------------
if nargin<4
    d = pr_GetViewData;
end
set(d.Handles.TopCard,'currentcard',d.currentcard);
switch lower(state)
case 'off'
    %turn legend off
    set(d.Handles.LegendDisplayCard, 'currentcard', 1);    
case 'on'
    %turn legend on
    set(d.Handles.LegendDisplayCard, 'currentcard', 2);
end


%-----------------------------------------------------------------------
function cb_SetupMenu(varargin)
%-----------------------------------------------------------------------
d = pr_GetViewData;
hndls = [d.Handles.plm.PlotStyleM(:); d.Handles.plm.LimitColor(:)];
if length(d.Exprs.plot_index)==1
end
v_en = d.Plot.ViewEnable;
set(d.Handles.plm.View,'checked','off',{'enable'},[v_en v_en]');
switch d.Table.TopMode
case 'dataset'
    set(d.Handles.plm.View([1 4]),'checked','on');
    if d.currentviewinfo == 5
        d.Plot.ShowError = -1;
    end
case 'surface'
    set(d.Handles.plm.View([2 5]),'checked','on');
    if d.currentviewinfo == 5 & d.Plot.ShowError == -1
        d.Plot.ShowError = 1;
    end
case 'line'
    set(d.Handles.plm.View([3 6]),'checked','on');
    if d.currentviewinfo == 5 & d.Plot.ShowError == -1
        d.Plot.ShowError = 0;        
    end
end
if d.Plot.ShowError == 1
    set(d.Handles.plm.ErrorView([1 2]),'enable','on');    
    set(d.Handles.plm.ErrorView,'checked','on');
elseif d.Plot.ShowError == 0
    set(d.Handles.plm.ErrorView([1 2]),'enable','on');    
    set(d.Handles.plm.ErrorView,'checked','off');
else
    set(d.Handles.plm.ErrorView([1 2]),'enable','off');
    set(d.Handles.plm.ErrorView,'checked','off');    
end
if d.Plot.DoColor
    set(d.Handles.plm.DoColor,'checked','on');
    set(hndls,'enable','on');
else
    set(d.Handles.plm.DoColor,'checked','off');
    set(hndls,'enable','off');
end
% if d.Plot.DoPE
%     set(d.Handles.plm.DoPE,'checked','on');
% else
%     set(d.Handles.plm.DoPE,'checked','off');
% end
set(d.Handles.plm.PlotStyleM,'enable','off', 'checked', 'off');
if d.Plot.DoColor
    pkcb = get(d.Handles.DataDisplay, 'colorbar');
    set(d.Handles.plm.LimitColor,'enable','on');
    if strmatch(get(pkcb, 'userange'), 'on')
        d.Plot.LimitColor = 1;
    else
        d.Plot.LimitColor = 0;
    end
    if d.Plot.LimitColor
        set(d.Handles.plm.PlotStyleM,'enable','on');
        set(d.Handles.plm.LimitColor,'checked','on');
        switch d.Plot.Style
            case 'exclude'
                set(d.Handles.plm.PlotStyleM([1 4]),'checked','on');
                set(d.Handles.plm.PlotStyleM([2 5]),'checked','off');
                set(d.Handles.plm.PlotStyleM([3 6]),'checked','off');
            case 'blank'
                set(d.Handles.plm.PlotStyleM([1 4]),'checked','off');
                set(d.Handles.plm.PlotStyleM([2 5]),'checked','on');
                set(d.Handles.plm.PlotStyleM([3 6]),'checked','off');
            case 'color'
                set(d.Handles.plm.PlotStyleM([1 4]),'checked','off');
                set(d.Handles.plm.PlotStyleM([2 5]),'checked','off');
                set(d.Handles.plm.PlotStyleM([3 6]),'checked','on');
        end
    else
        set(d.Handles.plm.LimitColor,'checked','off');
    end
end

if isequal(length(get(d.Handles.DataDisplay, 'userdata')), 1)
    set(d.Handles.plm.SwapAxes(2), 'enable', 'on');    
else
    set(d.Handles.plm.SwapAxes(2), 'enable', 'off');
end
if strmatch(d.ViewInfo(d.currentviewinfo).ID, 'table', 'exact')
    set(d.Handles.plm.DoColor,'enable','off');
    set(d.Handles.plm.SwapAxes, 'enable', 'off');    
end

pr_SetViewData(d);
%-----------------------------------------------------------------------
function cb_PESelector(varargin)
%-----------------------------------------------------------------------
d = pr_GetViewData;
switch varargin{3}
case 'switch'
    newvalue = 1-d.Plot.DoPE;
case 'on'
    newvalue = 1;
case 'off'
    newvalue = 0;
end
d.Plot.DoPE = newvalue;
d.Exprs.plot_index = [];
d = i_ExprClick(d);
pr_SetViewData(d);

%-----------------------------------------------------------------------
function cb_ColorSelector(varargin)
%-----------------------------------------------------------------------
d = pr_GetViewData;
switch varargin{3}
case 'switch'
    newvalue = 1-d.Plot.DoColor;
case 'on'
    newvalue = 1;
case 'off'
    newvalue = 0;
end
d.Plot.DoColor = newvalue;
pr_SetViewData(d);
old = get(d.Handles.DataDisplay,'marker');
if d.Plot.DoColor
    [col_mat,mark_mat] = ColorMatrix(d.Handles.Legend,length(old),'k');
else
    [col_mat,mark_mat,isrepeated] = ColorMatrix(d.Handles.Legend,length(old));
end
switch d.Table.TopMode
case 'dataset'
    myax = d.Handles.DataDisplay;
case 'surface'
    myax = d.Top.EditAxis;
case 'line'
    myax = d.Top.EditAxis;
end
set(myax,'colorbar',newvalue,'marker',mark_mat,'markercolor',col_mat);
set(d.Handles.Legend,...
    'marker',mark_mat,...
    'markerfacecolor',col_mat);

%-----------------------------------------------------------------------
function cb_PlotStyle(varargin)
%-----------------------------------------------------------------------
d = pr_GetViewData;
style = lower(varargin{3});
switch style
case {'exclude','blank','color'}
    d.Plot.Style = style;
    set(d.Handles.DataDisplay,'colorexcludestyle',style);
case 'switchcolor'
    
    % Toggle limit color range on/off
    d.Plot.LimitColor = 1-d.Plot.LimitColor;
    
    % Ensure that the colorbar limit range checkbox (cbox) agrees with the
    % menu toggle state. Fire the cbox callback to update the plot
    pkcb = get(d.Handles.DataDisplay, 'colorbar');
    if d.Plot.LimitColor
        set(pkcb, 'userange', 'on');
    else
        set(pkcb, 'userange', 'off');
    end
    cboxcb = get(pkcb, 'userangecb');
    xregcallback(cboxcb, [], []);
end
pr_SetViewData(d);

%-----------------------------------------------------------------------
function cb_ChangeView(src,ev,style)
%-----------------------------------------------------------------------
d = pr_GetViewData;
switch style
case 'dataset'
    card = 1;
case 'surface'
    card = 3;
    d.Plot.ShowError = 0;
case 'line'
    card = 3;
    d.Plot.ShowError = 0;
end
d.Table.TopMode = style;
set(d.Handles.PlotCard,'currentcard',card);
d = feval(d.CB.View,d);
%d = feval(d.CB.Replot,d);
pr_SetViewData(d);


%-----------------------------------------------------------------------
function cb_ShowError(src,ev,state)
%-----------------------------------------------------------------------
d = pr_GetViewData;
if nargin<3, state = 'switch'; end
switch state
case 'switch'
    newvalue = 1-d.Plot.ShowError;
case 'on'
    newvalue = 1;
case 'off'
    newvalue = 0;
end
d.Plot.ShowError = newvalue;
d = feval(d.CB.View,d);
%d = feval(d.CB.Replot,d);
pr_SetViewData(d);

%-----------------------------------------------------------------------
function cb_SwapAxes(varargin)
%-----------------------------------------------------------------------
d = pr_GetViewData;
newvalue = 1-d.Plot.SwapAxes;
d.Plot.SwapAxes = newvalue;
d = feval(d.CB.View,d);
pr_SetViewData(d);

%-----------------------------------------------------------------------
function cb_CheckShowError(varargin)
%-----------------------------------------------------------------------
d = pr_GetViewData;
currentY = get(d.Handles.DataDisplay, 'currentyfactor');
currentX = get(d.Handles.DataDisplay, 'currentxfactor');
myXfactors = get(d.Handles.DataDisplay, 'factors');
currentXstr = myXfactors(currentX);

switch d.Plot.ShowError
case -1
    return;
case 0
    if currentY > 2
        set(d.Handles.DataDisplay, 'currentyfactor', 1);
    end
case 1
    if strcmp(currentXstr, '<X-Y Selection>')
        set(d.Handles.DataDisplay, 'currentxfactor', strmatch('Data set point', myXfactors));
    end
    if currentY < 3
        set(d.Handles.DataDisplay, 'currentyfactor', 3);
    end
otherwise
    error('CGDATASETNODE/PLOT: Erroneous value of d.Plot.ShowError encountered');
end
d = feval(d.CB.View, d);
pr_SetViewData(d);    

%-----------------------------------------------------------------------
function names = i_CheckFeatLegNames(ptrs, names, linkptrs)
%-----------------------------------------------------------------------
%I_CHECKFEATLEGNAMES
% Checks for the case when model and/or strategy from a feature are selected
% separately for plotting. In this case, they will both have the same tptrs
% (output 1 of ExpandPtrs) and the same name. Need to correct the name field
% for the legend

% Search for features 
featptrs = [];featpos = [];
for j=1:length(ptrs)
    % Correction, 12/xi/01. Data columns that are imported and unassigned, are given a NULL
    % pointer in the pointer list. Must check for this.
    if isvalid(ptrs(j)) & isfeature(ptrs(j).info)
        featptrs = [featptrs ptrs(j)];
        featpos = [featpos j];
    end
end
dfeat = double(featptrs);
[sdfeat, sortind] = sort(dfeat);

i = 0;
while i < length(dfeat)
    i = i+1;
    if length(dfeat)- i > 0 & sdfeat(i) == sdfeat(i+1)
        % Have two instances of the same feature 
        % Sort out the names
        fp1 = featpos(sortind(i));
        fp2 = featpos(sortind(i+1));
        if isa(linkptrs(fp1).info, 'cgmodexpr')
            if isempty(findstr(names{fp1}, 'Model'))
                names{fp1} = [names{fp1}, ' : Model'];
                names{fp2} = [names{fp2}, ' : Strategy'];            
            end
        else
            if isempty(findstr(names{fp1}, 'Model'))
                names{fp2} = [names{fp2}, ' : Model'];            
                names{fp1} = [names{fp1}, ' : Strategy'];
            end
        end
        i = i+1;
    else
        % Have only one part of the feature being plotted
        fp = featpos(sortind(i));
        if isa(linkptrs(fp).info, 'cgmodexpr')
            if isempty(findstr(names{fp}, 'Model'))
                names{fp} = [names{fp}, ' : Model'];
            end
        else
            if isempty(findstr(names{fp}, 'Strategy'))
                names{fp} = [names{fp}, ' : Strategy'];
            end
        end
    end
end

