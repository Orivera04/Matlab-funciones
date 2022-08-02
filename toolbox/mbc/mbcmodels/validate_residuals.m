function varargout= validate_residuals(Action,varargin)
%VALIDATE_RESIDUALS residual plots for MBC model selection tools

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.7.2.4 $  $Date: 2004/02/09 08:02:18 $

switch lower(Action)
case 'create'
   % compulsory validation Action
     [varargout{1:2}]= i_Create(varargin{:});
case 'view'
   % compulsory validation Action
   i_View(varargin{:});
case 'showtestnum'
   i_ShowTestNum;
case 'changetestnum'
   i_ChangeTestNum;
case {'modelselect','draw'}
   % quick view call
   i_draw(gcbf);
case 'print'
   i_Print(varargin{:});
end


function [Tool, mainLyt]= i_Create(hFig,DataType)

% compulsory tool properties
Tool.Name= '&Residuals';
Tool.MultiSelect= 1;
Tool.mfile= mfilename;
Tool.Icon = 'residuals.bmp';
Tool.Renderer='painters';

% Tools specific set up
Tool.DataType= DataType;

%-------------ContextMenu for plots---------------%
uic= uicontextmenu('parent',hFig);
um= uimenu('parent',uic,...
   'Label','&Test Number',...
   'Callback',[mfilename,'(''changetestnum'')']);

%----------------------Legend------------------------%
pH=xreguicontrol('parent',hFig,...
	'visible','off',...
   'style','text',...
   'HorizontalAlign','left',...
   'string','Legend:',...
   'enable','inactive');
hLegend=xregaxes('parent',hFig,...
	'visible','off',...
   'units','pixels',...
   'xlim',[0 1],'ylim',[0 1],...
   'box','on',...
   'xtick',[],'ytick',[],...
   'DefaultTextFontSize',8,...
   'DefaultTextFontName','Lucida Console');
legendWrapper = axiswrapper(hLegend);

%-------------------------Axes--------------------------------%
g2= mvgraph2d(hFig,...
	'visible','off');
set(g2,'grid','on','factorsettings','exclusive',...
   'Callback',[mfilename,'(''draw'')']);
ah= get(g2,'axes');
set(ah,'box','on',...
   'uicontextmenu',uic,...
   'buttonDown','mv_zoom',...
   'xlimmode','auto',...
   'ylimmode','auto');
xl= get(ah,'xlabel'); set(xl,'interpreter','none');
yl= get(ah,'ylabel'); set(yl,'interpreter','none');

%---------------LAYOUTS----------------------%
mainLyt = xreggridlayout(hFig,'correctalg','on',...
   'packstatus','off',...
   'dimension',[4 1],...
   'rowsizes',[15 80 15 -1],...
   'border',[10 10 10 10],...
   'elements',{pH,legendWrapper,[],g2});

Tool.Legend= hLegend;
Tool.testnum= um;
Tool.First  = 1;
Tool.graph2d = g2;
Tool.multilines = [];
Tool.helpmenus={'&Residuals Help','xreg_modSel_residuals'};

% --------------------------------------------------------
% SUBFUNCTION i_View
% --------------------------------------------------------
function i_View(hFig,varargin)

i_draw(hFig)

% --------------------------------------------------------
% SUBFUNCTION i_draw
% --------------------------------------------------------
function i_draw(hFig)
if ~nargin
   hFig = mvf('ValidationTool');
end

[Tool,p,Models,ModelSelect,ModelList]= i_GetTool(hFig);

% color and marker library
Colors = {'b','g','m','r','c'};
Markers = {'.','d','p','*','s'};

% set up the graph2d using the first Model
m= Models{1};
yname= ResponseLabel(m);
xname= InputLabels(m);
[X,Y]= getdata(p(1).info,Tool.DataType);
% TS      => X = {Xloc, Xglob}   this is fine for TS evaluation
% global  => X = {Xglob}   global model eval needs a sweepset NOT a cell array
if strcmp(p(1).guid,'global')
    X=X{end};
end

% called from Model/Evaluate at local node (not TS)
if isa(m,'localmod')
    if ~strcmpi(Tool.DataType,'VAL')
        View=  GetViewData(MBrowser);
        SNo = View.SweepPos;
        X = X(:,1:nfactors(m),SNo);
        Y = Y(:,1:nfactors(m),SNo);
    else
        SNo= 1;
    end
end

Rdata= residstats(m,X,Y);
Tool.graph2d.Data   = Rdata;
Tool.graph2d.limits = repmat({'auto'},1,length(Tool.graph2d.factors));

% delete old multiselect lines
if ~isempty(Tool.multilines)
   % delete old lines
   delete(Tool.multilines(ishandle(Tool.multilines)));
   Tool.multilines = [];
end

if length(Models)==1
   Tool.graph2d.factors = [{'Obs. No.'
         'Residuals'
         ['Predicted ' yname]
         'Normalized Residuals'
         yname}
		xname];
   set(Tool.testnum,'enable','on');
else
   set(Tool.testnum,'checked','off','enable','off');

   % delete test num text
   hTxt= findobj(get(Tool.graph2d,'axes'),'tag','TestNumText');
   if ~isempty(hTxt)
      delete(hTxt(ishandle(hTxt)));
   end      

   Tool.graph2d.factors = [{'Obs. No.'
           'Residuals'
           'Predicted Response'
           'Normalized Residuals'
           'Actual Response'}
       xname];
    if length(Models)>1 && length(p)==1 
        p = p(ones(size(Models)));
    end
   for i = 2:length(Models)
      m= Models{i};
      
     [X,Y]= getdata(p(i).info,Tool.DataType);
     if isa(m,'localmod')
         X = X(:,1:nfactors(m),SNo);
         Y = Y(:,:,SNo);
     end
     
     if strcmp(p(1).guid,'global')
          % need to get data for this model so that outliers occur
          X=X{end};
      end
      data= residstats(m,X,Y);
      % create a line for this model
      line = xregline(Tool.graph2d.axes);
      % set(line,'userdata',data);
      set(line,'XData',data(:,Tool.graph2d.currentxfactor),...
         'YData',data(:,Tool.graph2d.currentyfactor),...
         'linestyle','none',...
         'marker',Markers{i},...
         'color',Colors{i},...
         'markerfacecolor',Colors{i});
     % store these lines for deleting later
      Tool.multilines = [Tool.multilines(:);line];
   end
   i_SetTool(hFig,Tool);
end
% delete, then write things in the Legend
delete(get(Tool.Legend,'children'));
ht= .98;
i=1;
Textent(4)=0;
while ht-Textent(4)>0 && i<=length(ModelList)
      line = xregline(Tool.Legend);
	set(line,'xdata',0.05,'ydata',ht-0.05,...
		'Marker',Markers{i},...
		'LineStyle','none',...
		'Color',Colors{i},...
      'markerfacecolor',Colors{i});
	th=text('clipping','on',...
		'pos',[.1 ht],'string',ModelList{i},...
		'horizon','left','vert','top',...
		'interpreter','none',...
		'Parent',Tool.Legend);
	Textent= get(th,'extent');
	ht= ht-Textent(4);
	i=i+1;
end

if strcmp(get(Tool.testnum,'checked'),'on')
   i_ShowTestNum(Tool,p);
end

% --------------------------------------------------------
% SUBFUNCTION i_ShowTestNum
% --------------------------------------------------------
function i_ShowTestNum(Tool,p)

if nargin==0
   [Tool,p]=i_GetTool(gcbf);
end
% delete 
hTxt= findobj(get(Tool.graph2d,'axes'),'tag','TestNumText');
if ~isempty(hTxt)
   delete(hTxt(ishandle(hTxt)));
end      

if strcmp(get(Tool.testnum,'checked'),'on')
   set(Tool.graph2d.line,'tag','main line');
   [X,Y]= getdata(p(1).info,Tool.DataType);
   p.ShowTestNum(get(Tool.graph2d,'axes'),0,X,Y);
end

% --------------------------------------------------------
% SUBFUNCTION i_ChangeTestNum
% --------------------------------------------------------
function i_ChangeTestNum

[Tool,p]=i_GetTool(gcbf);
if strcmp(get(Tool.testnum,'checked'),'on')
   set(Tool.testnum,'checked','off')
else
   set(Tool.testnum,'checked','on')
end
i_ShowTestNum(Tool,p)


% --------------------------------------------------------
% SUBFUNCTION i_Print
% --------------------------------------------------------
function i_Print(Tool,Name)

lyt1= get(Tool.graph2d,'axes');
lyt2= Tool.Legend;
printlayout1(lyt1,lyt2,Name);

% --------------------------------------------------------
% SUBFUNCTION i_GetTool
% --------------------------------------------------------
% access to Tool structure 
% must go via mv_ValidationTool('get',hFig);
function [Tool,p,Models,ModNo,ModelList]=i_GetTool(hFig)

if nargout==1
   Tool=mv_ValidationTool('get',hFig);
else
   [Tool,ModelInfo,ModelList]=mv_ValidationTool('get',hFig);
   % ModelInfo is cell array.
   % ModelNumber is the index in the list view of currently selected models
   ModNo= ModelInfo{1};
   p= ModelInfo{2};
   % This is a cell array of e.g. TwoStage models
   Models= ModelInfo{3};
end      
   
% --------------------------------------------------------
% SUBFUNCTION i_SetTool
% --------------------------------------------------------
function i_SetTool(hFig,Tool)

mv_ValidationTool('set',hFig,Tool);
