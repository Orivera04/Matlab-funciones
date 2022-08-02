function varargout = cg_table_history(action,varargin)
%CG_TABLE_HISTORY

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:39:20 $

% CG_TABLE_HISTORY - the table hisory viewing object. Call with 
%  (a) nothing - creates a figure, controls and contextmenu
%  (b) figure - does its thing in the figure.
%  (c) borderlayout - does its thing in the borderlayout
%  (d) one of the above and a pointer - creates stuff and then populates it all.

if nargin == 0
    action = 'create';
end
switch action
case 'create'
    if ~isempty(varargin)
        h = varargin{1};
        if ishandle(h)
            hand = h;
            b = xregborderlayout(hand);
        elseif isa(h,'xregborderlayout')
            hand = get(h,'parent');
            b = h;
        end
    if length(varargin) >= 2
        parent = varargin{2}; % will tell us which file to call with a history refresh call
    else
        parent = [];
    end
    else
        hand = figure;
        b = xregborderlayout(hand,'container',hand,'packstatus','on');
        parent = [];
    end
    LB = i_create(hand,b,parent);
    % We return the handle to the listbox which can then be stored and then used later for initialisation.
    if nargout == 1
        varargout{1} = LB;
    end    
case 'initialise'
    if length(varargin) == 2 & varargin{2}.isa('cglookup')
        i_initialise(varargin{1},varargin{2});
    elseif length(varargin) >= 3 & varargin{2}.isa('cglookup')    
        i_initialise(varargin{1},varargin{2},varargin{3});
    end
case 'refresh'
    if length(varargin) == 2 & varargin{2}.isa('cglookup')
        i_refresh(varargin{1},varargin{2});
    end
case 'details'
    i_details;
case 'reset'
    i_reset;
case 'diff'
    i_differences;
case 'edit'
    i_edit_comment;
case 'clear'
    i_clear;
case 'save'
    ud = i_getdata; 
    if ud.Data.SaveFlag
        i_save(ud);
    else 
        i_is_that_your_final_answer;
    end
case 'menu check'
    i_check;
case 'kill edit'
    i_kill_edit;
case 'change is good'
    i_change_entry;
case 'stop save'
    i_stop_save
case 'really save' 
    % If we're here then we just clicked on the OK button on the save dialogue window.
    d = get(gcbf,'UserData');
    i_save(get(d.Handles.ListBox,'UserData'));
case 'no more stinking dialogue'
    i_stop_dialogue;
case 'refresh'
    i_refresh(varargin{1},varargin{2}) % varargin{1} should be handle to the ListBox, varargin{2} should be the poiter to the table.
end
return
            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% i_gethandle                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function h = i_gethandle

% Tries to return the handle to the list box that's just been clicked on (hopefully)

h = gco;

if ~isequal(get(h,'tag'),'cg_table_history')
    h = findobj(gcf,'tag','cg_table_history');
    if length(h)~=1
        h = [];
    end
end

return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% i_getdata                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function ud = i_getdata

% Returns the UserData of the beloved listbox

ud = get(i_gethandle,'UserData');

return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% i_setdata                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function i_setdata(ud)

% sets the data of the data of the listbox central to the functioning of this GUI.

set(i_gethandle,'UserData',ud);

return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% i_create                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function LB = i_create(hand,b,parentGUI)

% Create the history thingy and the menu it uses.

ud.Handles.Parent = hand;
ud.Handles.ParentGUI = parentGUI;

menu = uicontextmenu('parent',hand,...
    'tag','history context menu');

%ud.Handles.Menus(1) = uimenu(menu,...
%    'label','&Details',...
%    'callback','cg_table_history(''details'')'); %Show details about selected entry

ud.Handles.Menus(1) = uimenu(menu,...
    'label','&Reset',...
    'callback','cg_table_history(''reset'')'); % reset to this entry

%ud.Handles.Menus(3) = uimenu(menu,...
%    'label','Di&fferences',...
%    'callback','cg_table_history(''diff'')'); % Show differences between two entries

ud.Handles.Menus(2) = uimenu(menu,...
    'label','&Edit comment',...
    'callback','cg_table_history(''edit'')'); % Edit information field for this entry

ud.Handles.Menus(3) = uimenu(menu,...
    'separator','on',...
    'Label','&Save selected stages to history (discard rest)',...
    'callback','cg_table_history(''save'')');

ud.Data = [];

ud.Handles.Text = xreguicontrol('parent',hand,...
    'style','text',...
    'visible','off',...
    'string','History:'); % text box

ud.Handles.ListBox = xreguicontrol('parent',hand,...
    'tag','cg_table_history',...
    'style','listbox',...
    'visible','off',...
    'Tooltip','Current history of this table.',...
    'background',[1 1 1],...
    'horizontal','left',...
    'max',2,...
    'min',0,...
    'buttondownfcn','cg_table_history(''menu check'')',...
    'uicontextmenu',menu); % box for comments to accompany changes

cth = xreggridlayout(hand,'elements',...
    {ud.Handles.Text,ud.Handles.ListBox},...
    'dimension',[2,1],...
    'visible','off',...
    'correctalg','on',...
    'rowsizes',[30 -1]);

set(b,'center',cth);

set(ud.Handles.ListBox,'UserData',ud);

LB = ud.Handles.ListBox;

return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% i_initialise                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function i_initialise(h,ptr,varargin)

% Fill in the listbox of destiny with the details of this particular table

% First up if the table history thingy hasn't been properly cleared then do nothing, save look disapprovingly on the 
% mfile that called for a such a foolish thing.

ud = get(h,'userdata');

if ~isempty(ud.Data)
%    msgbox('History Initialisation problem');
    return
end
% Now interpret varargin. If we're called from the breakpoint editor then we're going to need to know
% which pane to play with and varargin will tell us this. If we're called from tableviewer then this is not needed.
if ~isempty(varargin)
    ud.Data.Flag = varargin{1};
else
    ud.Data.Flag = 0;
end

ud.Data.TablePointer = ptr;
if ptr.isa('cglookupone')
    set(ud.Handles.Menus(1),'enable','off');
else
    set(ud.Handles.Menus(1),'enable','on');
end

M = ptr.get('memory');
ud.Data.Memory = ptr.get('memory');
ud.Data.SaveFlag = 0;
set(ud.Handles.ListBox,'UserData',ud);

i_refresh(ud.Handles.ListBox,ptr);

return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% i_details                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function i_details

% show the details of the chosen stage in the tables history. Will be handled by object methods, which construct a
% simple GUI to show a snap shot of the table at this point.

ud = i_getdata;

v = get(ud.Handles.ListBox,'value');

ud.Data.TablePointer.HistoryDetails(v);

return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% i_reset                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function i_reset

% Reset the table to the chosen entry

ud = i_getdata;

v = get(ud.Handles.ListBox,'value');

ud.Data.TablePointer.info = ud.Data.TablePointer.history_reset(v); % We handle this case if an object method since
% with the expanded role envisioned for history (i.e., including locks and extrapolation masks) each table should perhaps 
% look after itself in these matters.

i_refresh(ud.Handles.ListBox,ud.Data.TablePointer);

if ~isempty(ud.Handles.ParentGUI)
    % Refresh the parent gui with the changes
    eval([ud.Handles.ParentGUI,'(''history_reset'',',num2str(ud.Data.Flag),')']);
end

return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% i_differences                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function i_differences 

% show the differences between two stages in the tables history. Will be handled by object methods, which construct a
% simple GUI to show a snap shot of the table at this point.

ud = i_getdata;

v = get(ud.Handles.ListBox,'value');

ud.Data.TablePointer.HistoryDifferences(v);

return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% i_edit_comment                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function i_edit_comment

% Create a modal comment box to allow the user to update the string they've chosen

ud = i_getdata;

v = get(ud.Handles.ListBox,'value');
str = ud.Data.Memory{v}.Information;
X = get(ud.Handles.Parent,'currentpoint');
pos = get(ud.Handles.Parent,'position');

d.Handles.Figure = figure('numbertitle','off',...
    'color',get(0,'DefaultUIcontrolBackgroundColor'),...
    'resize','off',...
    'menubar','none',...
    'closerequestfcn','cg_table_history(''kill edit'')',...
    'visible','off',...
    'position',[pos(1)+X(1) max(pos(2)+X(2)-150,50) 350 120],...
    'name','Enter new Comment:');...,...
%    'windowstyle','modal');

d.Handles.Edit = uicontrol(d.Handles.Figure,...
    'style','edit',...
    'backgroundcolor',[1 1 1],...
    'position',[20 70 310 25],...
    'tag','cg_table_history/i_edit_comment',...
    'horizontalalignment','left',...
    'string',str);

d.Handles.OK = uicontrol(d.Handles.Figure,...
    'style','push',...
    'string','OK',...
    'callback','cg_table_history(''change is good'')',...
    'position',[170 20 70 30]);

d.Handles.Cancel = uicontrol(d.Handles.Figure,...
    'style','push',...
    'string','Cancel',...
    'callback','cg_table_history(''kill edit'')',...
    'position',[260 20 70 30]);

d.Handles.ListBox = ud.Handles.ListBox; % Store some stuff so that we can get around
d.Data.TablePointer = ud.Data.TablePointer;
d.Data.Index = v;

set(d.Handles.Edit,'UserData',d);
set(d.Handles.Figure,'visible','on');

return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% i_clear                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function i_clear(h)

% Clear needs to be called with the handle of the listbox we're going to clear, which means that this handle needs to 
% be kept track of throughout the use of the GUI (That is if reuse of this puppy is intended)

ud = get(h,'UserData');
set(ud.Handles.ListBox,'string','');
ud.Data = [];
set(ud.Handles.ListBox,'UserData',ud);

return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% i_save                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function i_save(ud)

% Save the selected stages of the tables development, dtscard the rest, Cannot be reversed (should probably warn them of this).
 
v = get(ud.Handles.ListBox,'value');
j = 1;
tempmem = {};
for i = 1:length(ud.Data.Memory)
    if ~isempty(intersect(v,i))
        tempmem{j} = ud.Data.Memory{i};
        j = j+1;
    end
end

ud.Data.TablePointer.info = ud.Data.TablePointer.set('memory',tempmem);
ud.Data.Memory = tempmem;
set(ud.Handles.ListBox,'UserData',ud);
i_refresh(ud.Handles.ListBox,ud.Data.TablePointer);
delete(get(findobj('tag','cg_table_history/i_is_that_your_final_answer'),'parent'));

return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% i_check                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function i_check

ud = i_getdata;
v = get(ud.Handles.ListBox,'value');

if length(v) == 1
   set(ud.Handles.Menus(2),'enable','on');
%   set(ud.Handles.Menus(3),'enable','off');
   if v == length(get(ud.Handles.ListBox,'string'))
       set(ud.Handles.Menus(1),'enable','off');
       set(ud.Handles.Menus(3),'enable','on');
   else
       set(ud.Handles.Menus(1),'enable','on');
       set(ud.Handles.Menus(3),'enable','off');
   end
else
    if length(v) > 2
        set(ud.Handles.Menus([1:2]),'enable','off');
    else
%        set(ud.Handles.Menus(3),'enable','on');
        set(ud.Handles.Menus([1,2]),'enable','off');
    end
    if any(ismember(v,length(get(ud.Handles.ListBox,'string'))))
        set(ud.Handles.Menus(3),'enable','on');
    else
        set(ud.Handles.Menus(3),'enable','off');
    end
end
ptr = ud.Data.TablePointer;
if ptr.isa('cglookupone')
    set(ud.Handles.Menus(1),'enable','off');
else
    set(ud.Handles.Menus(1),'enable','on');
end

return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% i_kill_edit                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function i_kill_edit

% delete the little comment box and don't do anything else.

d = get(findobj('tag','cg_table_history/i_edit_comment'),'UserData');
delete(d.Handles.Figure);

return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% i_change_entry                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function i_change_entry

% Update the chosen entry with an all new bright and shiny user specified string

d = get(findobj('tag','cg_table_history/i_edit_comment'),'UserData');
str = get(d.Handles.Edit,'string');

ud = get(d.Handles.ListBox,'UserData');
ud.Data.Memory{d.Data.Index}.Information = str;
ud.Data.TablePointer.info = ud.Data.TablePointer.set('memory',ud.Data.Memory); % Make sure that the table memory is the same as that 
% held in the memory field here.
delete(d.Handles.Figure);
i_refresh(ud.Handles.ListBox,ud.Data.TablePointer);
set(ud.Handles.ListBox,'UserData',ud);

return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% i_refresh                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function i_refresh(h,ptr)

TranslationFlag = 0; % Flag to tell us if we ever do a translation

ud = get(h,'UserData');

mem = ptr.get('memory');

for i = 1:length(mem)
    if ~isfield(mem{i},'Data') | ~isfield(mem{i}, 'Information') | ~ischar(mem{i}.Information) % Are we old style?
       % OK we now need to interpret old memory files and rewrite them in a form that will be useful to future generations.
        mem{i} = i_translate(mem{i});
        TranslationFlag = 1;
    end 
    if isempty(mem{i}.Information)
        if isfield(mem{i}.Date)
            info = ['(',num2str(i),') ','No Information, ',mem{i}.Date];
        else
            info = ['(',num2str(i),') ','No Information, no date available'];
        end
    else
        info = ['(',num2str(i),') ',mem{i}.Information,', ',mem{i}.Date];            
    end
    str{i} = info;
end

if TranslationFlag == 1
    % we have done a translation from an old style of history to a new style - reset memory of table.
    ptr.info = ptr.set('memory',mem);
end

ud.Data.Memory = mem;

set(h,'value',1,'string',str,'UserData',ud);

return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% i_is_that_your_final_answer           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function i_is_that_your_final_answer

% In which we question the user as to whether they really want to delete all those lovely history entries

ud = i_getdata;

X = get(ud.Handles.Parent,'currentpoint');
pos = get(ud.Handles.Parent,'position');

d.Handles.Figure = figure('numbertitle','off',...
    'color',get(0,'DefaultUIcontrolBackgroundColor'),...
    'resize','off',...
    'menubar','none',...
    'closerequestfcn','cg_table_history(''stop save'')',...
    'visible','off',...
    'position',[pos(1)+X(1) max(pos(2)+X(2)-150,50) 350 150],...
    'name','Delete history entries?');

uicontrol(d.Handles.Figure,...
    'style','text',...
    'position',[20 110 310 30],...
    'horizontalalignment','left',...
    'string','By proceeding you will irretrievably lose all the nonselected entries in the history. Do you wish to continue?');

d.Handles.Check = uicontrol(d.Handles.Figure,...
    'style','check',...
    'tag','cg_table_history/i_is_that_your_final_answer',...
    'string','Do not show me this dialogue again for this table',...
    'callback','cg_table_history(''no more stinking dialogue'')',...
    'position',[20 70 310 30],...
    'value',0);

d.Handles.OK = uicontrol(d.Handles.Figure,...
    'style','push',...
    'string','OK',...
    'callback','cg_table_history(''really save'')',...
    'position',[170 20 70 30]);

d.Handles.Cancel = uicontrol(d.Handles.Figure,...
    'style','push',...
    'string','Cancel',...
    'callback','cg_table_history(''stop save'')',...
    'position',[260 20 70 30]);

d.Handles.ListBox = ud.Handles.ListBox;

set(d.Handles.Check,'UserData',d);
set(d.Handles.Figure,'visible','on','UserData',d);

return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% i_stop_save                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function i_stop_save

delete(get(findobj('tag','cg_table_history/i_is_that_your_final_answer'),'parent'));

return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% i_stop_dialogue                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function i_stop_dialogue

% In which we determine whether or not to continue asking for permission to delete entries.

d = get(findobj('tag','cg_table_history/i_is_that_your_final_answer'),'UserData');
v = get(d.Handles.Check,'value');

ud = get(d.Handles.ListBox,'UserData');
ud.Data.SaveFlag = v;
set(d.Handles.ListBox,'UserData',ud);

return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% i_translate                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function out = i_translate(in)

% As of 15-05-2001 the nature of history is changing. In an attempt to create links between past versions 
% and the ever changing nature of future interpretations of the memory field, teams of brave programmers undertook
% the task of constructioning this translation function. Pray that they got it right! (and if that doesn't
% sound like bad SF then I don't know what does).

% New history shall have the following fields:
% Information, Date, Values & Breakpoints BPlocks and Vlocks as appropriate, Data. Data will be a structure that changes it's format
% but will display change related stuff that we want stored.

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

return