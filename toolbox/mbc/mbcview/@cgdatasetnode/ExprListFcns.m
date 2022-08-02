function varargout = ExprListFcns(varargin);
%EXPRLISTFCNS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.6.2.3 $  $Date: 2004/02/09 08:21:31 $

if nargin==0
    error('insufficient arguments.');
elseif isa(varargin{1},'cgdatasetnode')
    if nargin>2 & ischar(varargin{3})
        d = varargin{2};
        switch lower(varargin{3})
            case 'col_click'
                d = i_ColClick(d,varargin{4:5});
                pr_SetViewData(d);
            case 'right_click'
                i_RightClick(d,varargin{4});
            case 'click'
                d = i_Click(d,varargin{4});
                pr_SetViewData(d);
            case 'dbl_click'
                d = i_DblClick(d,varargin{4});
                pr_SetViewData(d);
            case 'get_callbacks'
                varargout{1} = i_GetCallbacks;
        end
    end
end




%-----------------------------------------------------------------------
%
% Column heading clicks
%  - sort data by column
%
%-----------------------------------------------------------------------



%-----------------------------------------------------------------------
function d = i_ColClick(d,liststr,col)
%-----------------------------------------------------------------------
page = d.ViewInfo(d.currentviewinfo);
switch lower(liststr)
case 'top'
    list = d.Handles.FactorList;
    cb = page.tpcolclick;
case 'bottom'
    list = d.Handles.ExprList;
    cb = page.bmcolclick;
otherwise
    return
end

if ~isempty(cb)
    if ~ischar(cb)
        feval(cb,d,liststr,col);
    end

elseif list.ListItems.Count>0
    i = get(col,'subitemindex');
    oi = get(list,'sortkey');
    if i==oi
        v = get(list,'sortorder');
        v = 1-v;
    else
        v = 0;
    end
    set(list,'sortorder',v);
    set(list,'sortkey',i);
    set(list,'sorted',-1);
    s = get(list,'selecteditem');
    EnsureVisible(s);
end




%-----------------------------------------------------------------------
%
% Right clicks on list
%  - display appropriate context menu
%
%-----------------------------------------------------------------------



%-----------------------------------------------------------------------
function i_RightClick(d,list)
%-----------------------------------------------------------------------
% Cannot return d
%  Control passes straight to menu item callback, which
%   may alter d itself.
pl=get(0,'pointerlocation');
fp=get(d.Handles.Figure,'position');
fp=fp(1:2);

page = d.ViewInfo(d.currentviewinfo);

d = i_Click(d,list,'internal');
switch lower(list)
case 'top'
    Menu = page.tpmenu;
case 'bottom'
    Menu = page.bmmenu;
case 'rules'
    Menu = page.bmmenu;
otherwise
    Menu = [];
end

if ~isempty(Menu)
    MenuCB = get(Menu,'callback');
else
    MenuCB = [];
end

if ~isempty(MenuCB)
    if ~isempty(page.tpselection)
        top_sel = feval(page.tpselection,d);
        feval(MenuCB,d,list,top_sel);
    else
        feval(MenuCB,d,list);
    end
end
if ~isempty(Menu)
    set(Menu,'visible','off');
    pos = pl-fp;
    set(Menu,'position',pos);
    set(Menu,'visible','on');
end


%-----------------------------------------------------------------------
function d = i_Click(d,list,intflag)
%-----------------------------------------------------------------------
intflag = (nargin==2);

page = d.ViewInfo(d.currentviewinfo);
Click = [];
switch lower(list)
case 'top'
    Click = page.tpclick;
case 'bottom'
    Click = page.bmclick;
case 'tables'
    Click = page.bmclick;
    d.currentlist = 'tables';
case 'factors'
    Click = page.bmclick;
    d.currentlist = 'factors';    
case 'rules'
    Click = page.bmclick;
    d.currentlist = 'rules';        
end
% set up toolbars
d = i_TBClick(d,list);


if ~isempty(Click)
    d = feval(Click,d,list);
end

%-----------------------------------------------------------------------
function d = i_DblClick(d,list)
%-----------------------------------------------------------------------
Click = [];
page = d.ViewInfo(d.currentviewinfo);
Click = [];
switch lower(list)
case 'top'
    Click = page.tpdblclick;
case 'bottom'
    Click = page.bmdblclick;
end

if ~isempty(Click)
    d = feval(Click,d);
end

%-----------------------------------------------------------------------
function d = i_TBClick(d,list)
%-----------------------------------------------------------------------
CB = [];
page = d.ViewInfo(d.currentviewinfo);

if ~isempty(CB)
    d = feval(CB,d,list);
end
    

%-----------------------------------------------------------------------
function cb = i_GetCallbacks
%-----------------------------------------------------------------------
cb = [];
