function varargout = importtable(nd,varargin)
%IMPORTTABLE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.5.2.2 $  $Date: 2004/02/09 08:21:35 $

action = varargin{1};

switch lower(action)
case 'create'
   varargout{1} = i_Create(varargin{2:end});
case 'return_data'
   varargout = i_ReturnData;
case 'close'
   i_Close;
case 'ok'
   i_OK;
end


function out = i_Create(varargin)

%The inputs on creation are...
% h - call handle
% opt - 'create_new', 'fill_existing'
% oppoint - current oppoint

h_this = findobj(0 , 'tag' , 'importtable');
if ~isempty(h_this)
   delete(h_this);
end

if nargin<1
    Handles.Daddy = [];
    cage_pos = [100 300 300 400];
else
    Handles.Daddy = varargin{1};
    cage_pos = get(Handles.Daddy , 'position');
end
if nargin<2
    opt = 'create_new';
else 
    opt = varargin{2};
end
if nargin<3
    d.oppoint = [];
else
    d.oppoint = varargin{3};
end

d.fillopt = 0;
if isempty(d.oppoint)   %cannot fill, so create new.
    opt = 'create_new';
end
switch lower(opt)
case 'fill_existing'
    titlestr = 'Fill data set from table';
    d.fillopt = 1;
case 'create_new'
    titlestr = 'Overwrite data set from table';
otherwise
    error('Unrecognised option');
end

% Create list of tables to use for filling data set
c = cgbrowser;
pr = c.RootNode;
nds = pr.preorder('getnode');
tableList = [];tableListStr = []; included = []; done = [];
tpfilter = cgtypes.cgtabletype;
for i = 1:length(nds)
    if matchtype(typeobject(nds{i}),tpfilter)
        ptr = getdata(nds{i});
      if ~ptr.isa('cgnormaliser') & ...
              (isempty(done) | ~ismember(double(ptr),done))
          done = [done double(ptr)];
          if ~d.fillopt | i_check_eval(d.oppoint,ptr)
             include = (~d.fillopt | isfactor(d.oppoint,ptr));
             if (include & d.fillopt), addstr = '* '; else addstr = '  '; end
             tableList = [tableList;ptr];  %list of ptrs to available tables
             tableListStr = [tableListStr,{[addstr ptr.getname]}];
             included = [included include];
         end
      end
   end
end

if isempty(tableList)
    thiserrstr = 'The columns in this data set do not completely match the axes of any of the tables in the session. Cannot fill this data set from a table';
    out = errordlg(thiserrstr, 'Import Data from Table', 'modal');
    return;
end
d.included = included;

figW = 300; figH = 230; okH = 40;
pos = [cage_pos(1)+100 cage_pos(2)+cage_pos(4)-140-200 figW figH];

bgCol = get(0 , 'defaultuicontrolbackgroundcolor');

Handles.Figure = figure('position' , pos , ...
   'menubar' , 'none' , ...
   'resize' , 'off' , ...
   'numbertitle' , 'off' , ...
   'name' , 'Import Data from Table' , ...
   'color' , bgCol , ...
   'CloseRequestFcn',@i_Close,...
   'tag' , 'importtable',...
   'windowstyle' , 'modal');
out = Handles.Figure;

i_AxesFrame([10 50 figW-20 figH-20-okH],Handles.Figure);

titletext = uicontrol('style' , 'text' , ...
   'parent' , Handles.Figure , ...
   'horizontalalignment' , 'left' , ...
   'position' , [20 figH-50 figW-40 20] , ...
   'fontweight' , 'demi' , ...
   'backgroundcolor' , bgCol , ...
   'string' , titlestr);

Handles.TableList = uicontrol('style' , 'popup' , ...
   'parent' , Handles.Figure , ...
   'horizontalalignment' , 'left' , ...
    'backgroundcolor' , [1 1 1] , ...
   'position' , [20 figH-80 figW-40 20] , ...
   'string' , tableListStr,...
   'userdata',tableList,...
   'callback',@i_Select);

Handles.TableCheck = uicontrol('style' , 'checkbox' , ...
   'parent' , Handles.Figure , ...
   'position' , [20 figH-110 figW-40 20] , ...
   'value',0,...
   'string','Include table output');
Handles.AddString = uicontrol('style','text',...
   'parent' , Handles.Figure , ...
   'position' , [35 figH-125 figW-60 15] ,...
   'string', '(Add as new factor)',...
   'horizontalalignment','left',...
   'visible','off');

Handles.TableInfo = uicontrol('style' , 'text' , ...
   'parent' , Handles.Figure , ...
   'tag','tablecheck',...
   'position' , [20 figH-160 figW-40 20]);

uicontrol('style' , 'push' , ...
   'parent' , Handles.Figure , ...
   'position' , [220 10 70 30] , ...
   'string' , 'Cancel' , ...
   'callback' , @i_Close);

uicontrol('style' , 'push' , ...
   'parent' , Handles.Figure , ...
   'position' , [140 10 70 30] , ...
   'string' , 'OK' , ...
   'callback' , @i_OK);

d.TableList = tableList;
d.Handles = Handles;
set(Handles.Figure , 'UserData' , d);
i_Select;

%-------------------------------------------------------------------
function valid = i_check_eval(oppoint,tptr);
%-------------------------------------------------------------------
valid = 1;
t_ptrs = get(tptr.info,'axesptrs');
ptrlist = oppoint.ptrlist;
for i = 1:length(t_ptrs)
    if ~any(t_ptrs(i)==ptrlist)
        valid = 0;
    end
end

%-------------------------------------------------------------------
function i_Select(varargin);
%-------------------------------------------------------------------
d = i_GetData;
    ind = get(d.Handles.TableList,'value');
if isempty(ind)
   ind = 1;
end
set(d.Handles.TableList,'value',ind);

check = 0; str = '';
set(d.Handles.AddString,'visible','off');
if isempty(d.TableList)
    d.Table = [];
    str = '';
else
    d.Table = d.TableList(ind);
    switch lower(class(d.Table.info))
    case 'cglookuptwo'
        type = '2-D Table';
    case 'cglookupone'
        type = '1-D Table';
    case 'cgnormfunction'
        type = 'Function';
    otherwise
        type = '';
    end
    if ~isempty(type)
        t_ptrs = d.Table.get('axesptrs');
        prettyaxesnames = [];
        for i = 1:length(t_ptrs)
            prettyaxesnames = [prettyaxesnames t_ptrs(i).getname ', '];
        end
        prettyaxesnames = prettyaxesnames(1:end-2);
        values = get(d.Table.info,'values');
        if isempty(values)
            str =[type,' object with no values'];
        else
            [m,n]=size(values);
            if n==1
                str = [type,' (',prettyaxesnames,') with ' num2str(m) ' breakpoints'];
            else
                str = [type,' (',prettyaxesnames,') : Size ' num2str(m) ' by ' num2str(n)];
            end
        end 
        if ~d.included(ind) & d.fillopt
            set(d.Handles.AddString,'visible','on','string','(Add new factor)');
        elseif d.fillopt
            set(d.Handles.AddString,'visible','on','string','(Factor already present)');
        end
        d.tableincluded = d.included(ind);
        check = ~d.fillopt | d.tableincluded;
        d.axesstring = prettyaxesnames;
    end
end
set(d.Handles.TableInfo,'string',str);
set(d.Handles.Figure , 'UserData' , d);
set(d.Handles.TableCheck,'value',check);

%-------------------------------------------------------------------
function i_Close(varargin)
%-------------------------------------------------------------------
d=i_GetData;
if ~isempty(d)
    delete(d.Handles.Figure);
end

%-------------------------------------------------------------------
function argout = i_ReturnData;
%-------------------------------------------------------------------
d = i_GetData;
if isempty(d) | isempty(d.Table) | ~isvalid(d.Table)
    argout{1} = 0;
    argout{2} = [];
else
    name = getname(d.Table.info);
    check = get(d.Handles.TableCheck,'value');
    ok = 1;
    if ~d.fillopt
        [op,mess] = ImportTable(cgoppoint,d.Table,check);
    else
        but = 'Overwrite';
        switch lower(but)
            case {'overwrite','evaluate'}
                [op,mess] = ImportTable(d.oppoint,d.Table,check,but);
                if ~isempty(mess)
                    h = errordlg(mess, 'Cage' , 'modal');
                    uiwait(h);
                    ok = 0;
                end
            case 'cancel'
                ok = 0;
                op = d.oppoint;
        end
    end
    argout{1} = ok;
    argout{2} = op;
    if ~isempty(d.Handles.Daddy)
        if strcmp(get(d.Handles.Daddy,'visible'),'on')
            figure(d.Handles.Daddy);
        end
    end
end

%-------------------------------------------------------------------
function i_OK(varargin)
%-------------------------------------------------------------------
d = i_GetData;
uiresume(d.Handles.Figure);

%-------------------------------------------------------------------
function ax=i_AxesFrame(pos,figH)
%-------------------------------------------------------------------
ax=axes('parent',figH,'units','pixels','xtick',[],'ytick',[], ...
   'ylim',[0 1],'xlim',[0 1],'color',get(figH,'color'),'position',pos);
l1=line([0 0 1],[0 1 1],'parent',ax,'color',[0.25 0.25 0.25]);
l2=line([0 1 1],[0 0 1],'parent',ax,'color',[1 1 1]);

if pos(3)<5 | pos(4)<5
   set([ax,l1 l2],'handlevisibility','on','hittest','on');
   return
end

dx=1./pos(3);
dy=1./pos(4);
set(l1,'xdata',[0 0 (1-dx) (1-dx) 0],'ydata',[dy 1 1 dy dy]);
set(l2,'xdata',[dx dx (1-2*dx) 1 1 0],'ydata',[2*dy (1-dy) (1-dy) 1 0 0]);
set([ax,l1 l2],'handlevisibility','off','hittest','off');

%-------------------------------------------------------------------
function d = i_GetData
%-------------------------------------------------------------------
h_this = findobj(0 , 'tag' , 'importtable');
if isempty(h_this)
    d = [];
   return
end
d = get(h_this , 'UserData');