function cghistorymanager(Action,varargin)
%CGHISTORYMANAGER
%
% GUI to manage Cal files for the current session.
%
% CGHISTORYMANAGER(action)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.9.2.4 $  $Date: 2004/04/12 23:35:13 $

if nargin==0
    Action = 'create';
end
switch lower(Action)
case 'precreate'
    i_CreateFigure;
case 'create'
    fh = i_gethandle;
    if isempty(fh)
        i_CreateFigure;
        fh = i_gethandle;
    end
    if nargin>1
        i_Refresh(varargin{:});
    end	
    fh = handle(fh);
    fh.showDialog;
case 'itemselect'
    i_PlotTable;
case 'finish'
    i_Finish;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             CREATEFIGURE            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function i_CreateFigure
c = cgbrowser;

fhWidth = 700; fhHeight = 500;
xFig= xregdialog('position',[100 100 fhWidth fhHeight],...
    'resize','off',...
    'closerequestfcn',[mfilename,'(''finish'')'],...
    'Tag','HistoryManager',...
    'name','History',...
    'pointer','watch');
fh = double(xFig);
c.registersubfigure(fh,'none');
ud.FigureHandle = fh;

str = {'Reset','Add...','Remove','Edit...','Close'};
callbacks = {@i_Reset,@i_Add,@i_Remove,@i_Edit,@i_Finish};

for i = 1:length(str)
    ud.Hand.But(i) = xreguicontrol('style','push',...
        'parent',fh,...
        'callback',callbacks{i},...
        'string',str{i},...
        'visible','off');
end
ud.Hand.But(6)=cghelpbutton(fh,'CGHISTORYVIEWER');

ud.ILmanager = get(cgbrowser,'ILmanager');
IL=ud.ILmanager.IL;
lPos = [-2 -2 1 1]; 
callbacks = {'click','cghistcb'};
lh = xregGui.listview(lPos , fh, callbacks);
lh.Parent = fh;
lh.InsertSmallIcons(IL);

set(lh , 'view' , 3,...
   'multiselect' , 1,...
   'labeledit' , 1,...
   'hideselection' , 0 ,...
   'sorted' , 0,...
   'Appearance', 1,...
   'BorderStyle', 1,...
   'sortorder', 0,...
   'inactive', 0,...
   'fullrowselect', 1);

cols = {'Version','Comment / Action','Date and Time'};
widths = [50 350 120];
hCols = lh.ColumnHeaders;
for i = 1:length(cols)
    hItem = hCols.Add;
    set(hItem , 'text' , cols{i});
    set(hItem , 'width' , widths(i));
end
set(lh, 'sortkey', 1);
list = actxcontainer(lh);
ud.List = lh;

% create table.
ud.TableWrapper = mbctable.simple('parent', fh, 'visible', 'off');
ud.layout = xreggridbaglayout(fh,'packstatus','off',...
   'elements',{list,[],[],[],[],[],ud.TableWrapper,[],...
      [],[],[],[],[],[],[],ud.Hand.But(5),...
      [],ud.Hand.But(1),ud.Hand.But(2),ud.Hand.But(3),ud.Hand.But(4),[],[],ud.Hand.But(6)},...
   'dimension',[8,3],...
   'colsizes',[-1 65 65],...
   'gapx',7,'gapy',10,...
   'rowsizes',[25,25,25,25,25,50,-1,25],...
    'mergeblock',{[1 6],[1 2]},...
    'mergeblock',{[7 7],[1 2]},...
    'border',[10 10 10 10]);

set(ud.layout,'position',[0 0 fhWidth fhHeight],'packstatus','on','visible','on');
% Finish up
drawnow;
set(fh,'userdata',ud,'pointer','arrow');


% --------------------------------------------------------
function h = i_gethandle
% --------------------------------------------------------
h = findall(0,'tag','HistoryManager');

% --------------------------------------------------------
function ud = i_getdata                         
% --------------------------------------------------------
ud = get(i_gethandle,'UserData');


% --------------------------------------------------------
function i_setdata(ud)                         
% --------------------------------------------------------
set(i_gethandle,'UserData',ud);

% --------------------------------------------------------
function i_Finish(src,event)
% --------------------------------------------------------
fh = i_gethandle;
c = cgbrowser;
c.doDrawTree([],'update');
ShowNode(c);
ViewNode(c);
set(fh,'visible','off');

% --------------------------------------------------------
function i_Reset(src,event)
% --------------------------------------------------------
ud = i_getdata;
index = double(ud.List.SelectedItemIndex);
if index > 1
    N = double(ud.List.ListItems.Count);
    MemIndex = (N+1)-index;
    [ud.Obj.info, ok] = history_reset(ud.Obj.info, MemIndex);
    if ok
        i_Refresh(ud.Obj);
    else
        % Warn user that the operation was not allowed
        h = errordlg(['Unable to reset to this point in the history.  ' ...
            'This may be because the size of the table has been locked']);
        waitfor(h);
    end
end


% --------------------------------------------------------
function i_Remove(src,event)
% --------------------------------------------------------
ud = i_getdata;
try
    index = double(ud.List.SelectedItemIndex);
    if index > 1
        N = double(ud.List.ListItems.Count);
        MemIndex = (N+1)-index;
        mem = ud.Obj.get('memory');
        mem(MemIndex) = [];
        ud.Obj.info = ud.Obj.set('memory',mem);
        i_Refresh(ud.Obj,index(1));
    end
end

% --------------------------------------------------------
function i_Add(src,event)
% --------------------------------------------------------
ud = i_getdata;
V = ud.Obj.get('values');
ud.Obj.info = ud.Obj.set('values',{V,''});
i_Refresh(ud.Obj);
OK = i_Edit;
if ~OK
    % Cancel
    mem = ud.Obj.get('memory');
    mem(end) = [];
    ud.Obj.info = ud.Obj.set('memory',mem);
    i_Refresh(ud.Obj)
end

% --------------------------------------------------------
function varargout = i_Edit(src,event)
% --------------------------------------------------------
OK = 1;
ud = i_getdata;
index = double(ud.List.SelectedItemIndex);
N = double(ud.List.ListItems.Count);
MemIndex = (N+1)-index;
mem = ud.Obj.get('memory');
Date = mem{MemIndex}.Date;
defstr=mem{MemIndex}.Information;
if isempty(defstr)
   defstr='';   % make sure empties go to a string
end
answer=inputdlg({'Comment / Action:'},['Edit History: Version ',num2str(MemIndex)],1,{defstr});
if isempty(answer)
    % cancel
    OK = 0;
elseif ~isequal(mem{MemIndex}.Information,answer{1})
    mem{MemIndex}.Information = answer{1};
    ud.Obj.info = ud.Obj.set('memory',mem);
    i_Refresh(ud.Obj,index);
end
if nargout == 1
    varargout{1} = OK;
end

% --------------------------------------------------------
function i_Close(src,event)
% --------------------------------------------------------

% --------------------------------------------------------
function i_PlotTable
% --------------------------------------------------------
try
    ud = i_getdata;
    index = double(ud.List.SelectedItemIndex);
    % Enable the buttons - reset, add, remove, edit
    if length(index) > 1
        set(ud.Hand.But([1 4]),'enable','off');
    else
        set(ud.Hand.But(4),'enable','on');
        if index == 1
            set(ud.Hand.But([1 3]),'enable','off');
        else
            set(ud.Hand.But([1 3]),'enable','on');
        end
    end
    N = double(ud.List.ListItems.Count);
    index = (N+1)-index; % Reverse order of list box
    if length(index) == 0 || length(index) > 2
        % Clear the table
        ud.TableWrapper.table.clearTable;
    else
        mtableview(ud.Obj.info,ud.TableWrapper,index);
    end
    i_setdata(ud);
catch
    disp('Error');
    [x,y]=lasterr;
    disp(x);
    disp(y);
end

% --------------------------------------------------------
function i_Refresh(ptr,SelInd)
% --------------------------------------------------------
TranslationFlag = 0; % Flag to tell us if we ever do a translation
ud = i_getdata;
set(ud.FigureHandle,'name',['History for ',ptr.getname]);
LI = ud.List.ListItems;
LI.Clear;
mem = ptr.get('memory');
L = length(mem);
if (nargin == 1) | (SelInd > L) | (SelInd <= 0)
    SelInd = 1;
end
for i = 1:L
    index = (L+1-i);
    [mem{index},change] = i_translate(mem{index});
    TranslationFlag = TranslationFlag | change;
    hand = LI.Add;
    set(hand , 'text' , num2str(index));
    info = mem{index}.Information;
    if ~ischar(info)
        info = '';
    end
    set(hand , 'subitems',1, info);
    if isfield(mem{index},'Date')
       set(hand , 'subitems',2,mem{index}.Date);
    end
    if i == SelInd
        set(hand , 'selected' , 1);
    else
        set(hand , 'selected' , 0);
    end
end

if TranslationFlag == 1
    % we have done a translation from an old style of history to a new style - reset memory of table.
    ptr.info = ptr.set('memory',mem);
end
ud.Obj = ptr;
i_setdata(ud);
i_PlotTable;

% --------------------------------------------------------
function [out,change] = i_translate(in)
% --------------------------------------------------------
% As of 15-05-2001 the nature of history is changing.

% New history shall have the following fields:
% Information, Date, Values & Breakpoints BPlocks and Vlocks as appropriate, Data
if isfield(in,'Data') & isfield(in, 'Information') & ischar(in.Information)
    % new style        
    out = in;
    change = 0;
else 
    change = 1;
    if isfield(in,'Values');
        out.Values = in.Values;
        if isfield(in,'VLocks');
            if isequal(size(in.Values),size(in.VLocks))
                out.VLocks = in.VLocks;
            else
                out.VLocks = zeros(size(in.Values));
            end
        else
            out.VLocks = zeros(size(in.Values));
        end
    end
    
    if isfield(in,'Breakpoints')
        out.Breakpoints = in.Breakpoints;
        if isfield(in,'BPLocks');
            if isequal(size(in.Breakpoints),size(in.BPLocks))
                out.BPLocks = in.BPLocks;
            else
                out.BPLocks = zeros(size(in.Breakpoints));
            end
        else
            out.BPLocks = zeros(size(in.Breakpoints));
        end
    end
    
    if isfield(in,'Date')
        out.Date = in.Date;
    else
        out.Date = '';
    end
    
    % in strange cases when there is no information field
    if ~isfield(in,'Information')
        in.Information = '';
    end
    
    if ischar(in.Information) | isempty(in.Information)
        out.Information = in.Information;
        if isfield(in,'Data')
            out.Data = in.Data;
        else
            out.Data = [];
        end
    elseif iscell(in.Information)
        switch in.Information{1}
        case 'A' % averaged
            out.Information = 'Averaged';
            try
                sfstr = in.Information{2}.getname;
            catch
                sfstr = 'Subfeature not known';
            end
            out.Data.SubFeature = sfstr;
            try
                mod = in.Information{2}.get('model');
                modstr = [mod.getname,'*'];
            catch
                modstr = 'Model not known';
            end
            out.Data.Model = modstr;
            varstr{1} = 'Variable not known';
            for i = 1:length(in.Information{3})
                try
                    varstr{i} = in.Information{3}(i).getname;
                catch
                    varstr{i} = 'Variable not known';
                end
            end
            out.Data.SteadyVariables = varstr;
            try 
                out.Data.ValuesAndWeights = in.Information{4};
            catch
                out.Data.ValuesAndWeights = [];
            end           
        case {'O', 'AO'} % optimised
            out.Information = 'Optimised';
            varstr{1} = 'Variable not known';
            for i = 1:length(in.Information{2})
                try
                    varstr{i} = in.Information{2}(i).getname;
                catch
                    varstr{i} = 'Variable not known';
                end
            end
            out.Data.SteadyVariables = varstr;
            try
                out.Data.SteadyValues = in.Information{3};
            catch
                out.Data.SteadyValues = [];
            end
            try
                sfstr = in.Information{4}.getname;
            catch
                sfstr = 'Subfeature not known';
            end
            out.Data.SubFeature = sfstr;
            try
                mod = in.Information{4}.get('model');
                modstr = [mod.getname,'*'];
            catch
                modstr = 'Model not known';
            end
            out.Data.Model = modstr;
            try
                out.Data.Weights = in.Information{5};
            catch
                out.Data.Weights = [];
            end
            try
                out.Data.Grid = in.Information{6};
            catch
                out.Data.Grid = [];
            end
        case 'E' % extrapolated
            out.Information = 'Extrapolated';
            out.Data.Mask = in.Information{2};
        otherwise
            out.Information = in.Information;
        end
    end
end
