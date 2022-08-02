function varargout = ExprListFcns(varargin);
%EXPRLISTFCNS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.3 $  $Date: 2004/02/09 06:51:13 $

if nargin==0
    error('cgoppoint::plot: insufficient arguments.');
elseif isa(varargin{1},'cgoppoint')
    if nargin>1 & ischar(varargin{2}) & isempty(varargin{1})
        switch lower(varargin{2})
        case 'col_click'
            i_ColClick(varargin{3:4});
        case 'right_click'
            i_RightClick(varargin{3});
        case 'click'
            i_Click(varargin{3});
        case 'dbl_click'
            i_DblClick(varargin{3});
        case 'get_callbacks'
            varargout{1} = i_GetCallbacks;
        end
    end
end


%------------------------------------------------------------------
function h=i_GetHandle
%------------------------------------------------------------------
h=findall(0 , 'tag' , 'DatasetViewer');

%------------------------------------------------------------------
function i_SetData(d)
%------------------------------------------------------------------
CGBH = cgbrowser;
if CGBH.GuiExists
    CGBH.setViewData(d);
    % update the current object
    d.opptr.info = d.oppoint;
else
    set(i_GetHandle , 'UserData' , d);
end

%------------------------------------------------------------------
function d=i_GetData
%------------------------------------------------------------------
CGBH = cgbrowser;
if CGBH.GuiExists
    d=CGBH.getViewData;
    pFN = CGBH.CurrentNode;
    pF = pFN.getdata;
    d.oppoint = pF.info;
    d.opptr = pF;
else
    d=get(i_GetHandle , 'UserData');
end


%-----------------------------------------------------------------------
%
% Column heading clicks
%  - sort data by column
%
%-----------------------------------------------------------------------



%-----------------------------------------------------------------------
function i_ColClick(list,col)
%-----------------------------------------------------------------------
d = i_GetData;

switch lower(list)
case 'factor'
    switch d.InputMode
    case 'normal'
        buttons = d.Handles.TopButtons;
        list = d.Handles.FactorList;
    case 'grid'
        feval(d.CB.InputsColClick,col);
        return
    end
case {'factorexpr','tableexpr','plot','inputsexpr'}
    buttons = d.Handles.BottomButtons;
    list = d.Handles.ExprList;
case 'inputs'
    Inputs(cgoppoint,'col_click',col);
    return
otherwise
    return
end

if list.ListItems.Count>0
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
    invoke(s,'ensurevisible');
end



%-----------------------------------------------------------------------
%
% Right clicks on list
%  - display appropriate context menu
%
%-----------------------------------------------------------------------



%-----------------------------------------------------------------------
function i_RightClick(list)
%-----------------------------------------------------------------------
d = i_GetData;

pl=get(0,'pointerlocation');
fp=get(gcf,'position');
fp=fp(1:2);

i_Click(list,'internal');

pass_list = 0;
switch lower(list)
case {'factorexpr'}
    %MenuData = d.Handles.FactorEM;
    MenuData = d.Handles.fm;
    pass_list = 1;
case {'factor'}
    switch d.InputMode
    case 'normal'
        MenuData = d.Handles.fm;
    case 'grid'
        MenuData = d.Handles.InputsM;
    end
    pass_list = 1;
case 'tableexpr'
    MenuData = d.Handles.fm;
    %MenuData = d.Handles.FactorEM;
    pass_list = 1;
case 'plot'
    MenuData = d.Handles.fm;
    pass_list = 1;
case 'inputs'
    MenuData = d.Handles.InputsM;
case {'linkingdata','linkingfactors','linkingtop'}
    MenuData = d.Handles.LinkM;
    pass_list = 1;
otherwise
    MenuData = [];
end

if ~isempty(MenuData)
    if iscell(MenuData.SetupCB)
        feval(MenuData.SetupCB{:});
    elseif ~isempty(MenuData.SetupCB)
        if pass_list
            feval(MenuData.SetupCB,list);
        else
            feval(MenuData.SetupCB);
        end
    end
    set(MenuData.menu,'visible','off');
    set(MenuData.menu,'position',pl-fp,'visible','on');
end


%-----------------------------------------------------------------------
function i_Click(list,intflag)
%-----------------------------------------------------------------------
d = i_GetData;
intflag = (nargin==2);

switch lower(list)
case 'factor'
    switch d.InputMode
    case 'normal'
        ExprClick = d.CB.FactorClick;
    case 'grid'
        ExprClick = d.CB.InputsClick;
    end
case 'factorexpr'
    switch d.InputMode
    case 'normal'
        ExprClick = d.CB.FactorsExprClick;
    case 'grid'
        ExprClick = d.CB.FactorsExprClick;
    end
case 'tableexpr'
    ExprClick = d.CB.DataExprClick;
case 'plot'
    ExprClick = d.CB.PlotExprClick;
case 'linkingdata'
    ExprClick = d.CB.DataLinkClick;
    if ~intflag, feval(d.Handles.LinkM.SetupCB,list); end
case 'linkingfactors'
    ExprClick = d.CB.FactorsExprClick;  % normal behaviour
    if ~intflag, feval(d.Handles.LinkM.SetupCB,list); end
case 'linkingtop'
    ExprClick = d.CB.FactorClick;  % normal behaviour
    if ~intflag, feval(d.Handles.LinkM.SetupCB,list); end
otherwise
    ExprClick = [];
end

if ~isempty(ExprClick)
    feval(ExprClick);
end

%-----------------------------------------------------------------------
function i_DblClick(list)
%-----------------------------------------------------------------------
d = i_GetData;

ExprClick = [];
switch lower(list)
case 'factor'
    switch d.InputMode
    case 'grid'
        ExprClick = d.CB.InputsDblClick;
    end
end

if ~isempty(ExprClick)
    feval(ExprClick);
end

%-----------------------------------------------------------------------
function cb = i_GetCallbacks
%-----------------------------------------------------------------------
cb.ListClick = @i_Click;
