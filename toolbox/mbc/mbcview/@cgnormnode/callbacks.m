function h = callbacks(normnode, subfunc, varargin)
%CALLBACKS  Various cgnormaliser GUI callbacks
%
%  CALLBACKS(N, 'gethandles') returns a structure of function handles
%  to subfunctions available:
%
%  CALLBACKS(N, FUNC, ARGS) executes the internal function FUNC and passes
%  it ARGS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $  $Date: 2004/04/10 23:34:56 $

if ischar(subfunc)
    if strcmpi(subfunc,'gethandles')
        h=struct('ViewComparison',@i_ViewComparison,...
            'ViewHistory',@i_ViewHistory,...
            'DisplaySplitChange', @i_DisplaySplitChange,...
            'ClearTableSelection', @i_ClearTableSelection,...
            'PopupViewHistory', @i_PopupViewHistory,...
            'DataChanged', @i_DataChanged,...
            'Initialize', @i_initialize,...
            'Fill', @i_fill,...
            'Optimize', @i_optimize);
    else
        feval(subfunc,varargin{:});
        h=[];
    end
end


% -------------------------------------------
% Called when the user selects the "View Comparison" menu item
function i_ViewComparison(src,event)
% -------------------------------------------
cgh = cgbrowser;
ud = cgh.getViewData;
was_on = strcmp(get(ud.Handles.Menus.comparison,'checked'),'on');

if ~was_on
    % show the comparison pane
    ud = pPlotComparison(ud);
    set(ud.Handles.Display,'state','center');
else
    set(ud.Handles.Display,'state','bottom');
end
ud = pSetComparisonMenu(ud);
cgh.setViewData(ud);

% -------------------------------------------
function i_ViewHistory(src,event)
% -------------------------------------------
cgh = cgbrowser; 
nd = cgh.currentnode;
ud = cgh.getViewData;

index = 1;
if ~isempty(ud.Handles.TableList)
    if length(ud.Handles.TableList) == 2
        % Ask which table the history is required for
        Name1 = ud.Handles.TableList(1).getname;
        Name2 = ud.Handles.TableList(2).getname;
        button = questdlg('Which axis do you wish to view the history for ?','History View',Name1,Name2,nd.name);
        if strcmp(button,Name2)
            index = 2;
        end
    end
    cghistorymanager('create',ud.Handles.TableList(index));
end


% -------------------------------------------
% Called when the user moves the split bar in the main layout
% The main complication is to work out whether the visibility
function i_DisplaySplitChange(src,event)
% -------------------------------------------
cgh = cgbrowser;
ud = cgh.getViewData;
% new position of split bar
state = get(ud.Handles.Display,'state');
if ~strcmp(state,'bottom')
    % previous state of "View Comparison" menu.
    was_on = strcmp(get(ud.Handles.Menus.comparison,'checked'),'on');
    if ~was_on
        % comparison pane has been shown
        ud = pPlotComparison(ud);
    end
end
ud = pSetComparisonMenu(ud);
cgh.setViewData(ud);

%-------------------------------------------
function i_ClearTableSelection(unused1,unused2,table_to_clear)
%-------------------------------------------
table_to_clear.clearSelection;


%-------------------------------------------
function i_PopupViewHistory(menu,eventdata,I) 
%-------------------------------------------
cgh = cgbrowser;
ud = cgh.getViewData; 
ptr = ud.Handles.TableList(I); 
cghistorymanager('create', ptr); 

% -------------------------------------------
function i_DataChanged(src,event)
% -------------------------------------------
cgh = cgbrowser; 
ud = cgh.getViewData; 
if strcmp(get(ud.Handles.Menus.comparison,'checked'),'on');
    ud = pPlotComparison(ud);
    cgh.setViewData(ud);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% i_autospace                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function i_initialize(src,event)

cgh = cgbrowser; 
nd = cgh.CurrentNode;
ud = cgh.getViewData;

set(ud.Handles.Figure,'pointer','watch');
[nd.info, ok, msg] = initialize( nd.info, ud.TablePtr  );
if ok
    cgh.ViewNode;
    pMessage(ud, msg);
else
    i_error( msg );
end
set(ud.Handles.Figure,'pointer','arrow');
cgh.setViewData(ud);
return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% i_fill                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function i_fill(src,event)

cgh = cgbrowser; 
nd = cgh.CurrentNode;
ud = cgh.getViewData;

set(ud.Handles.Figure,'pointer','watch');
[nd.info, ok, msg] = fill( nd.info, ud.TablePtr, ud.FeatureData.Feature );
if ok
    cgh.ViewNode;
    pMessage(ud, msg);
else
    i_error( msg );
end
set(ud.Handles.Figure,'pointer','arrow');
cgh.setViewData(ud);
return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% i_optimise                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function i_optimize(src,event)

cgh = cgbrowser; 
nd = cgh.CurrentNode;
ud = cgh.getViewData;

set(ud.Handles.Figure,'pointer','watch');
[nd.info, ok, msg] = optimize( nd.info, ud.TablePtr, ud.FeatureData.Feature  );
if ok
    cgh.ViewNode;
    pMessage(ud, msg);
else
    i_error( msg );
end
set(ud.Handles.Figure,'pointer','arrow');
cgh.setViewData(ud);
return

%--------------------------------------------
function i_error(message)
%--------------------------------------------
uiwait(errordlg(message,'CAGE Error','modal'));
