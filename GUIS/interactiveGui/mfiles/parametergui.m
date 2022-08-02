% 
% 
% (c) 2003, University of Cambridge
% Stefan Bleeck (stefan@bleeck.de)
% http://www.mrc-cbu.cam.ac.uk/cnbh/aimmanual/tools/parameter
% $Date: 2004/07/26$

function varargout = parametergui(varargin)
% all action from a parametergui.
%
%   parametergui_MAINFCN provides these command line APIs for dealing with parameterguis
%
%      parametergui, by itself, creates a new parametergui or raises the existing
%      singleton*.
%
%      H = parametergui returns the handle to a new parametergui or the handle to
%      the existing singleton*.
%
%      parametergui(parameter_structure) creates a new window with the guis
%      for each parameter
%
%      parametergui('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in parametergui.M with the given input arguments.
%
%      parametergui('Property','Value',...) creates a new parametergui or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the parametergui before untitled_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to untitled_OpeningFcn via varargin.
%
%   Copyright 1984-2002 The MathWorks, Inc.
%   $Revision: 1.4 $ $Date: 2002/05/31 21:44:31 $
%
%   Copyright 2004 Stefan Bleeck
%   $Revision: 1.0 $ $Date: 2004/06/29 13:55:00 $



% find out, if we want a new window or the old one:
if length(varargin)==1 && ~isempty(varargin{1})
    parametergui_Singleton = 0;  % normally we want a new window
    all_childs=get(0,'children');
    this_name=getname(varargin{1});
    for i=1:length(all_childs)
        name=get(all_childs(i),'name');
        if strcmp(name,this_name)
            parametergui_Singleton = 1; % but if there is a copy already, take that window instead
            % and bring it to the front
            figure(all_childs(i));
            break
        end
    end
else
    parametergui_Singleton = 1; % but if there is a copy already, take that window instead
end

parametergui_State = struct('parametergui_Name',       mfilename, ...
    'parametergui_Singleton',  parametergui_Singleton, ...
    'parametergui_OpeningFcn', @parametergui_OpeningFcn, ...
    'parametergui_OutputFcn',  @parametergui_OutputFcn, ...
    'parametergui_LayoutFcn',  @parametergui_LayoutFcn, ...
    'parametergui_Callback',   []);
if nargin && ischar(varargin{1})
    parametergui_State.parametergui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = parametergui_mainfcn(parametergui_State, varargin{:});
else
    parametergui_mainfcn(parametergui_State, varargin{:});
end


% --- Executes just before parametergui is made visible.
function parametergui_OpeningFcn(hObject, eventdata, handles, varargin) %#ok
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see guidata)
% varargin   command line arguments to parametergui (see VARARGIN)

% Choose default command line output for parametergui
handles.output = hObject;


% copy the params in place
% params=varargin{1};
% handles.params=params;

% Update handles structure
guidata(hObject, handles);

global result;
% UIWAIT makes parametergui wait for user response (see UIRESUME)

% result=getdefaultvalue(handles.params);


if strcmp(getmode(handles.params),'modal')
    % set the first focus
    focus=getfirstfocus(handles.params);
    if ~isempty(focus)
        hand=gethandle(handles.params,focus);
        if ishandle(hand)
            uicontrol(hand);
        end
    end

    uiwait(handles.figure1);
end

% % set the userdata to the parameters so that they can be accessed from other programs
% set(handles.figure1,'userdata',handles.params);
% w=get(handles.figure1,'userdata');
%%%% that doesnt work because of an obvious bug in matlab. The set routine
%%%% calls the params set not the windows set


% --- Outputs from this function are returned to the command line.
function varargout = parametergui_OutputFcn(hObject, eventdata, handles) %#ok
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see guidata)


% Get default command line output from handles structure
global result;
% if isfield(result,'handles')
% % matlab doesnt call the callback routine when closed, so update all values
% % first:
%     generic_Callback([], 'onlyupdate', result.handles);
% end


varargout{1} = result;


% --- Executes on button press in pushbutton1.
function generic_Callback(hObject, eventdata, handles)
global result;
if ischar(eventdata) && strcmp(eventdata,'default')
    p=getdefaultbutton(handles.params);   % its as if the button was pressed
    hObject=p.handle{1};
end
if ischar(eventdata) && strcmp(eventdata,'onlyupdate')
    p=get(handles.params);
    hObject=p{1}.handle{1};
end
centry=getentrybyhandle(handles.params,hObject);
if isempty(centry)
    disp('clicked on something outside')
    return
end

params=handles.params;
entryparams=get(params);
data=getuserdata(params);
callback=centry.callback;
nr_params=length(entryparams);

% second go through all fields and update the value. This is neccessary to
% make sure to update the values in the params-structure when altered from
% outside
for iii=1:nr_params
%     param=entryparams{iii};
    type=entryparams{iii}.type;
    handleb=gethandle(params,entryparams{iii}.text,entryparams{iii}.panel);
    switch type
        case {'pop-up menu'}
            vals=get(handleb,'string');
            nrval=get(handleb,'value');
            value=vals{nrval};
            params=set(params,entryparams{iii}.text,value,entryparams{iii}.panel); % set the string value
        case {'bool','radiobutton'}
            value=get(handleb,'value');
            params=set(params,entryparams{iii}.text,value,entryparams{iii}.panel);

            % bool items can enable or disable other items:
            for i=1:length(entryparams{iii}.enables)
                params=enable(params,entryparams{iii}.enables{i},value,entryparams{iii}.enables_inbox{i});
            end
            for i=1:length(entryparams{iii}.disables)
                params=enable(params,entryparams{iii}.disables{i},1-value,entryparams{iii}.disables_inbox{i});
            end
        case {'filename','string','directoryname'}
            stringvalue=get(handleb,'string');
            params=set(params,entryparams{iii}.text,stringvalue,entryparams{iii}.panel);
        case {'slider'}
            % user could have clicked on the slider or on the edit
            secombi=entryparams{iii}.slidereditcombi;
            hand1=gethandle(params,entryparams{iii}.text,entryparams{iii}.panel,1);
            hand2=gethandle(params,entryparams{iii}.text,entryparams{iii}.panel,3);
            if hObject==hand1
                strval=get(hand1,'string');
                val=str2num(strval);
                secombi=slidereditcontrol_set_raweditvalue(secombi,val);
            else
                val=get(hand2,'value');
                secombi=slidereditcontrol_set_rawslidervalue(secombi,val);
            end
            val=slidereditcontrol_get_value(secombi);
            selectedunit=getcurrentunit(params,entryparams{iii}.text);
            toval=val*secombi.editscaler;
            params=setas(params,entryparams{iii}.text,toval,selectedunit,entryparams{iii}.panel); % set the real value
        case {'float'}
            set(handleb,'backgroundcolor','w');
            set(handleb,'foregroundcolor','k');
            strvalue=get(handleb,'string');            % value is a string, lets see what we make of it
            if ~strcmp(strvalue,'auto')
                selectedunit=getcurrentunit(params,entryparams{iii}.text);
                units=entryparams{iii}.unittype;
                if isa(units,'unit_none')
                    testvalue=str2num(strvalue); % its a float, it must have a value
                    realvalue=testvalue;
                    selectedunit='';
                else
                    params=setas(params,entryparams{iii}.text,strvalue,selectedunit,entryparams{iii}.panel); % set the real value
                    testvalue=getas(params,entryparams{iii}.text,entryparams{iii}.orgunit);
                    realvalue=str2num(strvalue);
                end
                if isempty(testvalue)
                    set(handleb,'backgroundcolor','g');
                    set(handleb,'foregroundcolor','r');
                    uicontrol(handleb);
                    errordlg(sprintf('no valid value for ''%s''',entryparams{iii}.text));
                    return
                end
                if min(testvalue)<entryparams{iii}.minvalue || max(testvalue)>entryparams{iii}.maxvalue
                    set(handleb,'backgroundcolor','g');
                    set(handleb,'foregroundcolor','r');
                    uicontrol(handleb);
                    if testvalue<entryparams{iii}.minvalue
                        errordlg(sprintf('''%s'' must be bigger then %f %s',entryparams{iii}.text,entryparams{iii}.minvalue,selectedunit));
                    else
                        errordlg(sprintf('''%s'' must be smaller then %f %s',entryparams{iii}.text,entryparams{iii}.maxvalue,selectedunit));
                    end
                    return
                end
                params=setas(params,entryparams{iii}.text,strvalue,selectedunit,entryparams{iii}.panel); % set the real value
            else
                set(handleb,'backgroundcolor','w');
                set(handleb,'foregroundcolor','k');
            end

        case {'int'}
            strvalue=get(handleb,'string');            % value is a string, lets see what we make of it
            set(handleb,'backgroundcolor','w');
            set(handleb,'foregroundcolor','k');
            if strcmp(strvalue,'auto')
                params=set(params,entryparams{iii}.text,'auto',entryparams{iii}.panel);
            else
                testvalue=str2num(strvalue); % its a float, it must have a value (str2double does produce a NAN then!)
                if isempty(testvalue)
                    testvalue=[];     % could be empty, sometimes useful...
                else
                    if min(testvalue)<entryparams{iii}.minvalue || max(testvalue)>entryparams{iii}.maxvalue
                        set(handleb,'foregroundcolor','g');
                        set(handleb,'backgroundcolor','r');
                        uicontrol(handleb);
                        if testvalue<entryparams{iii}.minvalue
                            errordlg(sprintf('''%s'' must be bigger then %d',entryparams{iii}.text,entryparams{iii}.minvalue+1));
                        else
                            errordlg(sprintf('''%s'' must be smaller then %d',entryparams{iii}.text,entryparams{iii}.maxvalue+1));
                        end
                        return
                    end
                end
                if isempty(strfind(strvalue,':'))
                    value=round(testvalue); % its an integer!
                    params=set(params,entryparams{iii}.text,value,entryparams{iii}.panel);
                else
                    params=set(params,entryparams{iii}.text,strvalue,entryparams{iii}.panel);
                end
            end
    end
end

% first find out if the response is towards a change of a unit. then only
% change the string
for iii=1:nr_params
    param=entryparams{iii};
    type=param.type;
    if strcmp(type,'float') || strcmp(type,'slider')
        handleb2=gethandle(params,param.text,param.panel,2);
        if hObject==handleb2 % yes, user changed a unit
            [selectedunit,fullunitname]=getcurrentunit(params,param.text);
            if ~ischar(param.rawvalue)
%                 rawval=fromunits(param.unittype,param.rawvalue,current_unit); %the unit in which the min and max values are defined
                newvalue=tounits(param.unittype,param.rawvalue,selectedunit); %the unit in which the min and max values are defined
                params=setas(params,param.text,newvalue,selectedunit,param.panel);
            end
            % make a new tooltip
            unittype=getname(param.unittype);
            tooltips=sprintf('%s measured in %s (%s)',unittype,selectedunit,fullunitname);
            set(handleb2,'tooltip',tooltips);
            
            if strcmp(type,'slider')  % change the slidercontrol to the new multiplier
                editscaler=tounits(param.unittype,1,selectedunit);
                se=param.slidereditcombi;
                se.editscaler=editscaler;
                params=setslidereditcontrol(params,param.text,se,param.panel);
            end
            handles.params=params;
            guidata(hObject, handles); % Update handles structure
            return
        end
    end
end

%third do something with the action
type=centry.type;
gethandle(params,centry.text,centry.panel);
switch type
    case 'button'
        result=params;
        eval(callback);
        return
    case {'filename','directoryname'}
        hand=gethandle(params,centry.text,centry.panel,1);
        hand2=gethandle(params,centry.text,centry.panel,2);
        % analyse the old file for pathes so that the filebox starts
        % correct:
        if hand2==hObject % the button was pressed
            oldname=get(params,centry.text,centry.panel);
            [filedir,x,x,x]=fileparts(oldname);
            if strcmp(type,'filename')
                % we want to allow files that do not exist jet therefore calling
                % uiput, not uiget
                if exist(filedir,'dir')
                    olddir=cd(filedir);
                else
                    olddir=pwd;
                end
                [nam,dir]=uiputfile('*.*','select a file');
                if ~isequal(nam,0)
                    fullname=fullfile(dir,nam);
                    set(hand,'string',fullname);
                else
                    fullname=oldname;
                end
                cd(olddir);
            else % must be directory
                olddir=cd(filedir);
                ret=uigetdir(filedir,'select a directory');
                if ~isequal(ret,0)
                    fullname=ret;
                else
                    fullname=oldname;
                end
                cd(olddir);
            end
            params=set(params,centry.text,fullname,centry.panel);
            params=settooltip(params,centry.text,fullname,centry.panel);
        else
            fullname=get(hand,'string');
            params=set(params,centry.text,fullname,centry.panel);
            params=settooltip(params,centry.text,fullname,centry.panel);
        end
end

% find out if it was a 'other...' line of a buttonrow
entry=getentrybyhandle(params,hObject);
if strcmp(entry.type,'radiobutton') &&  strcmp(entry.text,'other...')
    buttonhand=gethandle(params,entry.text,entry.panel,1);
    clickedinbox=entry.panel;
    % set all to 0 except of other...

    for j=1:nr_params
        paramas=entryparams{j};
        if strcmp(paramas.type,'radiobutton') && strcmp(paramas.panel,clickedinbox)
            curhand=gethandle(params,paramas.text,clickedinbox);
            set(curhand,'value',0);
            params=set(params,entryparams{j}.text,0,clickedinbox);
        end
    end
    set(buttonhand,'value',1); % set the one you clicked on to 1
    params=set(params,entry.text,1,entry.panel);
    otherhand=gethandle(params,entry.text,entry.panel,2);
    otherstr=get(otherhand,'string');
    params=setuserdata(params,otherstr,entry.text,entry.panel);
    set(otherhand,'back','y');
end

% every item can have a callback
if ~isempty(callback);
    eval(callback);
end

handles.params=params;
% save for later (the rückgabewert)
result=params;

guidata(hObject, handles); % Update handles structure


% --- Creates and returns a handle to the parametergui figure.
function guihandle = parametergui_LayoutFcn(policy)
% policy - create a new figure or use a singleton. 'new' or 'reuse'.

persistent hsingleton;
if strcmpi(policy, 'reuse') && ishandle(hsingleton)
    guihandle = hsingleton;
    return;
end
% collect my own params to generate parmeters on the fly
global params

% now build from bottom to top a line of text and an edit box for each
% parameter

% first find out, what the longest name is
% maxxlen=5;  % the longest text in width
% maxylen=5;  % the preliminary height of the window
rowheight=2.1;    % how high every row is
elementhigth=1.6; % how high every element is
edit_width=14;      % how wide an edit box is
unit_width=12;   % the width of a unit
stringedit_width=30;
spacebetweentextandedit=5;  % space between text and edit box
leftoffset=2;   % offset of text to the left boundary (and right as well)
buttonoffset=3;  % how far the buttons are away from the left edge
spacearoundtext=1.5;  % a space around either side of each text
filenamelength=35;   % how long the entry for a filename is
popuplength=28;
yoffset=(rowheight-elementhigth)/2; % brings everything to the middle
rightoffset=2; % a few spaces to the right edge of the screen
all_y_offset=1; % shift all entries a bit down.
extrabuttondown=0.5; % shift buttons an extra bit down

entryparams=get(params);
nr_params=length(entryparams);

% first go through and find the biggest text entry to define the width of
% the window
maxtextlen=0;
maxeditwidth=0;
mineditwidth=stringedit_width;
otheroffset=0;  % when an "other..." is in a panel, then make everything a bit wider
thirdpaneladd=0;    % a third panel to the right
for iii=1:nr_params
    param=entryparams{iii};
    text_len=length(param.text);
    if text_len>maxtextlen
        maxtextlen=text_len;
    end

    if strcmp(param.type,'filename')
        maxeditwidth=filenamelength+10;
    end
    if strcmp(param.type,'directoryname')
        maxeditwidth=filenamelength+10;
    end
    if strcmp(param.type,'string')
        maxeditwidth=max(maxeditwidth,param.width);
        maxeditwidth=max(maxeditwidth,mineditwidth);
    end
    if strcmp(param.type,'float') || strcmp(param.type,'int')
        maxeditwidth=max(maxeditwidth,25);
    end
    if strcmp(param.type,'pop-up menu')
        maxeditwidth=max(maxeditwidth,20);
    end
    if strcmp(param.type,'slider')
        thirdpaneladd=30;
        maxeditwidth=max(maxeditwidth,45);
    end
end

% the total size of the window is now:
maxwidth=max(maxeditwidth,edit_width);
window_width=maxtextlen+spacebetweentextandedit+maxwidth+3*leftoffset+rightoffset+thirdpaneladd;
window_height=(nr_params+1)*rowheight;
% get the size of the screen in chars
set(0,'units','char');
siz=get(0,'screensize');
screeen_height=siz(4);
screeen_width=siz(3);
set(0,'units','pixels'); % back to normal

% the figure
% windoff=1.3; % offset from the top right corner
windoff=0;
guihandle = figure(...
    'Units','characters',...
    'Color',[0.831372549019608 0.815686274509804 0.784313725490196],...
    'Colormap',[0 0 0.5625;0 0 0.625;0 0 0.6875;0 0 0.75;0 0 0.8125;0 0 0.875;0 0 0.9375;0 0 1;0 0.0625 1;0 0.125 1;0 0.1875 1;0 0.25 1;0 0.3125 1;0 0.375 1;0 0.4375 1;0 0.5 1;0 0.5625 1;0 0.625 1;0 0.6875 1;0 0.75 1;0 0.8125 1;0 0.875 1;0 0.9375 1;0 1 1;0.0625 1 1;0.125 1 0.9375;0.1875 1 0.875;0.25 1 0.8125;0.3125 1 0.75;0.375 1 0.6875;0.4375 1 0.625;0.5 1 0.5625;0.5625 1 0.5;0.625 1 0.4375;0.6875 1 0.375;0.75 1 0.3125;0.8125 1 0.25;0.875 1 0.1875;0.9375 1 0.125;1 1 0.0625;1 1 0;1 0.9375 0;1 0.875 0;1 0.8125 0;1 0.75 0;1 0.6875 0;1 0.625 0;1 0.5625 0;1 0.5 0;1 0.4375 0;1 0.375 0;1 0.3125 0;1 0.25 0;1 0.1875 0;1 0.125 0;1 0.0625 0;1 0 0;0.9375 0 0;0.875 0 0;0.8125 0 0;0.75 0 0;0.6875 0 0;0.625 0 0;0.5625 0 0],...
    'IntegerHandle','off',...
    'InvertHardcopy',get(0,'defaultfigureInvertHardcopy'),...
    'MenuBar','none',...
    'Name',getname(params),...
    'NumberTitle','off',...
    'Position',[screeen_width-window_width+windoff screeen_height-window_height-windoff window_width window_height],...
    'Renderer',get(0,'defaultfigureRenderer'),...
    'RendererMode','manual',...
    'Resize','off',...
    'HandleVisibility','callback',...
    'visible','off',...
    'KeyPressFcn'     ,@doFigureKeyPress          , ...
    'Tag','figure1');

pos=getposition(params);
movegui(guihandle,pos);

% make sure we are on screen
movegui(guihandle)

% error in V7... correct for small offset
if strcmp(pos,'northeast')
    wp=get(guihandle,'pos');
    wp(1)=wp(1)+5;
    wp(2)=wp(2)+5;
    set(guihandle,'pos',wp);
end
set(guihandle,'visible','on')

% application data
setappdata(guihandle, 'parameterguiDEOptions', struct(...
    'active_h', 1.020033e+002, ...
    'taginfo', struct(...
    'figure', 2, ...
    'pushbutton', 2), ...
    'override', 0, ...
    'release', 13, ...
    'resize', 'simple', ...
    'accessibility', 'callback', ...
    'mfile', 1, ...
    'callbacks', 1, ...
    'singleton', 1, ...
    'syscolorfig', 1, ...
    'lastSavedFile', 'c:\bla bla bla'));

% generate a huge panel that resides in that figure

set(guihandle,'Units','characters');
winsize=get(guihandle,'position');
winsize(1)=0;
winsize(2)=0;
bigpanel=uipanel(...
    'Parent',guihandle,...
    'Units','characters',...
    'Position',winsize,...
    'backgroundColor',[0.831372549019608 0.815686274509804 0.784313725490196],...
    'Title','',...
    'BorderType','none',...
    'visible','on',...
    'Tag','parameterpanel');




% first plot all panels so that they are in the background
linecount=1;
panelcount=1;
for iii=nr_params:-1:1
    param=entryparams{iii};
    type=param.type;
    if strcmp(type,'panel') % draw a panel around the next ones
        pos_x=leftoffset;
        width=window_width-2*leftoffset+rightoffset/2;
        height=(param.nr_elements+0.99)*rowheight;
        pos_y=(linecount+0.82)*rowheight-height-all_y_offset;
        %         panelhand(panelcount) = uipanel(...        % panel
        callbackstr='parametergui(''generic_Callback'',gcbo,[],guidata(gcbo))';
        panelhand(panelcount) = uibuttongroup(...        % panel
            'Parent',bigpanel,...
            'Units','characters',...
            'Position',[pos_x pos_y width height],...
            'backgroundColor',[0.831372549019608 0.815686274509804 0.784313725490196],...
            'TitlePosition','lefttop',...
            'Title',param.text,...
            'BorderType','etchedin',...
            'FontWeight','bold',...
            'Fontsize',11,...
            'Tag',sprintf('panel%d',panelcount),...
            'SelectionChangeFcn',callbackstr,...
            'Userdata',param.text);
        panelcount=panelcount+1;
        params=sethandle(params,param.text,panelhand,param.panel); % save the handle
    end
    linecount=linecount+1;
    param_y(iii)=linecount;
end
% then make a line for each parameter
linecount=ones(panelcount,1); % one linecounter for each panel
general_line_count=1;
for iii=nr_params:-1:1
    param=entryparams{iii};
    type=param.type;
    callbackstr='parametergui(''generic_Callback'',gcbo,[],guidata(gcbo))';
    tooltiptext=param.tooltiptext;
    % find out to which panel we belong and set the parent appropriate
    parentpanel=bigpanel; % by default the ui is in the big panel without subp
    current_panel_count=1; % by default in the big panel
    for jjj=1:panelcount-1
        if strcmp(param.panel,get(panelhand(jjj),'title'))
            parentpanel=panelhand(jjj);
            current_panel_count=jjj+1; % the current panel +1 to avoid confusion with the big one
        end
    end
    if ~strcmp(type,'button') && ~strcmp(type,'panel')
        text_len=length(param.text);
        if current_panel_count==1
            pos_x=maxtextlen-(text_len+2*spacearoundtext)+3*leftoffset;
            pos_y=general_line_count*rowheight-all_y_offset;
        else
            pos_x=maxtextlen-(text_len+2*spacearoundtext)+3*leftoffset-2;
            pos_y=linecount(current_panel_count)*rowheight-all_y_offset;
        end
        h2 = uicontrol(...    % text
            'Parent',parentpanel,...
            'Units','characters',...
            'Position',[pos_x pos_y-yoffset text_len+2*spacearoundtext elementhigth],...
            'String',param.text,...
            'backgroundColor',[0.831372549019608 0.815686274509804 0.784313725490196],...
            'HorizontalAlignment','right',...
            'Tag',sprintf('text%d',general_line_count),...
            'Style','text');
        if strcmp(type,'text')
            set(h2,'FontSize',12);
            set(h2,'Fontweight','bold');
            ext=get(h2,'extent');
            pos=get(h2,'position');
            pos(1)=buttonoffset;
            pos(3)=ext(3);
            pos(4)=ext(4);
            set(h2,'position',pos);
        end
    end
    switch param.enable
        case 0
            enableval='off';
        case 1
            enableval='on';
    end

    switch type
        case {'int'}
            if current_panel_count==1
                pos_x=maxtextlen+spacebetweentextandedit+2*leftoffset;
                pos_y=general_line_count*rowheight-all_y_offset;
            else
                pos_x=maxtextlen+spacebetweentextandedit+2*leftoffset-3;
                pos_y=linecount(current_panel_count)*rowheight-all_y_offset;
            end
            val=getraw(params,param.text);
            hand = uicontrol(...        % float edit box
                'Parent',parentpanel,...
                'Units','characters',...
                'BackgroundColor',[1 1 1],...
                'Position',[pos_x pos_y edit_width elementhigth],...
                'Callback',callbackstr,...
                'String',val,...
                'enable',enableval,...
                'Style','edit',...
                'Tag',sprintf('entry%d',general_line_count),...
                'Userdata',param.text);
            set(hand,'HorizontalAlignment','right');
            params=sethandle(params,param.text,hand,param.panel);
        case {'float'}
            if current_panel_count==1
                pos_x=maxtextlen+spacebetweentextandedit+2*leftoffset;
                pos_y=general_line_count*rowheight-all_y_offset;
            else
                pos_x=maxtextlen+spacebetweentextandedit+2*leftoffset-3;
                pos_y=linecount(current_panel_count)*rowheight-all_y_offset;
            end
            %             val=getas(params,param.text,param.orgunit);
            strval=param.stringvalue;
            hand = uicontrol(...        % float edit box
                'Parent',parentpanel,...
                'Units','characters',...
                'BackgroundColor',[1 1 1],...
                'Position',[pos_x pos_y edit_width elementhigth],...
                'Callback',callbackstr,...
                'String',strval,...
                'Style','edit',...
                'enable',enableval,...
                'Tag',sprintf('entry%d',general_line_count),...
                'Userdata',param.text);

            set(hand,'HorizontalAlignment','left');
            params=sethandle(params,param.text,hand,param.panel);

            % make the unit poupbox
            unit=param.unittype;
            % make a tooltip for it
            unittype=getname(unit);
            if ~isa(unit,'unit_none')
                pos_x=pos_x+edit_width+2;
                possible_units=getunitstrings(unit);
                possible_units_full=getunitfullstrings(unit);
                select_nr=findunit(unit,param.orgunit);
                unitname=possible_units{select_nr};
                fullunitname=possible_units_full{select_nr};
                tooltips=sprintf('%s measured in %s (%s)',unittype,unitname,fullunitname);
                hand2 = uicontrol(...    % bool: radiobutton
                    'Parent',parentpanel,...
                    'Units','characters',...
                    'BackgroundColor',[1 1 1],...
                    'Position',[pos_x pos_y unit_width elementhigth],...
                    'string',possible_units,...
                    'enable',enableval,...
                    'value',select_nr,...
                    'Style','popupmenu',...
                    'Callback',callbackstr,...
                    'tooltip',tooltips,...
                    'Tag',sprintf('entry%d',general_line_count),...
                    'Userdata',param.panel); % for radiobuttons it is important to know in which context they appear
                params=sethandle(params,param.text,hand2,param.panel,2);
            end
        case {'slider'}
            if current_panel_count==1
                pos_x=maxtextlen+spacebetweentextandedit+2*leftoffset;
                pos_y=general_line_count*rowheight-all_y_offset;
            else
                pos_x=maxtextlen+spacebetweentextandedit+2*leftoffset-3;
                pos_y=linecount(current_panel_count)*rowheight-all_y_offset;
            end
            %             val=getas(params,param.text,param.orgunit);
            strval=param.stringvalue;
            hand = uicontrol(...        % float edit box
                'Parent',parentpanel,...
                'Units','characters',...
                'BackgroundColor',[1 1 1],...
                'Position',[pos_x pos_y edit_width elementhigth],...
                'Callback',callbackstr,...
                'String',strval,...
                'Style','edit',...
                'enable',enableval,...
                'Tag',sprintf('entry%d',general_line_count),...
                'Userdata',param.text);

            set(hand,'HorizontalAlignment','left');
            params=sethandle(params,param.text,hand,param.panel);

            % make the unit poupbox
            unit=param.unittype;
            % make a tooltip for it
            unittype=getname(unit);
            if ~isa(unit,'unit_none')
                pos_x=pos_x+edit_width+2;
                possible_units=getunitstrings(unit);
                possible_units_full=getunitfullstrings(unit);
                select_nr=findunit(unit,param.orgunit);
                unitname=possible_units{select_nr};
                fullunitname=possible_units_full{select_nr};
                tooltips=sprintf('%s measured in %s (%s)',unittype,unitname,fullunitname);
                hand2 = uicontrol(...    % bool: radiobutton
                    'Parent',parentpanel,...
                    'Units','characters',...
                    'BackgroundColor',[1 1 1],...
                    'Position',[pos_x pos_y unit_width elementhigth],...
                    'string',possible_units,...
                    'enable',enableval,...
                    'value',select_nr,...
                    'Style','popupmenu',...
                    'Callback',callbackstr,...
                    'tooltip',tooltips,...
                    'Tag',sprintf('entry%d',general_line_count),...
                    'Userdata',param.panel); % for radiobuttons it is important to know in which context they appear
                params=sethandle(params,param.text,hand2,param.panel,2);
            else
                pos_x=pos_x+edit_width+2;
                params=sethandle(params,param.text,0,param.panel,2);
            end

            % make the slider
            pos_x=pos_x+unit_width+2;
            hand3 = uicontrol(...    % bool: radiobutton
                'Parent',parentpanel,...
                'Units','characters',...
                'Position',[pos_x pos_y thirdpaneladd+15 elementhigth],...
                'enable',enableval,...
                'value',1,...
                'Style','slider',...
                'Callback',callbackstr,...
                'Tag',sprintf('entry%d',general_line_count),...
                'Userdata',param.panel); % for radiobuttons it is important to know in which context they appear
            params=sethandle(params,param.text,hand3,param.panel,3);
            
            % set up the slidereditcontrol
            secombi=slidereditcontrol_setup(hand3,hand,param.minvalue,param.maxvalue,param.rawvalue,param.islog,param.editscaler,param.nreditdigits);
            secombi=slidereditcontrol_set_value(secombi,param.rawvalue);
            params=setslidereditcontrol(params,param.text,secombi,param.panel);

        case 'string'
            if current_panel_count==1
                pos_x=maxtextlen+spacebetweentextandedit+2*leftoffset;
                pos_y=general_line_count*rowheight-all_y_offset;
            else
                pos_x=maxtextlen+spacebetweentextandedit+2*leftoffset-3;
                pos_y=linecount(current_panel_count)*rowheight-all_y_offset;
            end
            width=max(stringedit_width,param.width)-2;
            hand = uicontrol(...        % string edit box
                'Parent',parentpanel,...
                'Units','characters',...
                'BackgroundColor',[1 1 1],...
                'enable',enableval,...
                'Position',[pos_x pos_y width elementhigth],...
                'Callback',callbackstr,...
                'String',param.value,...
                'Style','edit',...
                'HorizontalAlignment','left',...
                'Tag',sprintf('entry%d',general_line_count),...
                'Userdata',param.text);
            params=sethandle(params,param.text,hand,param.panel);
        case 'bool'
            if current_panel_count==1
                pos_x=maxtextlen+spacebetweentextandedit+2*leftoffset;
                pos_y=general_line_count*rowheight-all_y_offset;
            else
                pos_x=maxtextlen+spacebetweentextandedit+2*leftoffset-3;
                pos_y=linecount(current_panel_count)*rowheight-all_y_offset;
            end
            hand = uicontrol(...    % bool: checkbox
                'Parent',parentpanel,...
                'Units','characters',...
                'backgroundColor',[0.831372549019608 0.815686274509804 0.784313725490196],...
                'Position',[pos_x pos_y edit_width elementhigth],...
                'enable',enableval,...
                'value',param.value,...
                'Style','checkbox',...
                'Callback',callbackstr,...
                'Tag',sprintf('entry%d',general_line_count),...
                'Userdata',param.text);
            params=sethandle(params,param.text,hand,param.panel);
        case 'radiobutton'
            if current_panel_count==1
                pos_x=maxtextlen+spacebetweentextandedit+2*leftoffset;
                pos_y=general_line_count*rowheight-all_y_offset;
            else
                pos_x=maxtextlen+spacebetweentextandedit+2*leftoffset-3;
                pos_y=linecount(current_panel_count)*rowheight-all_y_offset;
            end
            hand = uicontrol(...    % bool: radiobutton
                'Parent',parentpanel,...
                'TooltipString',tooltiptext,...
                'Units','characters',...
                'backgroundColor',[0.831372549019608 0.815686274509804 0.784313725490196],...
                'Position',[pos_x pos_y 3 elementhigth],...
                'value',param.value,...
                'Style','radiobutton',...
                'enable',enableval,...
                'Tag',sprintf('entry%d',general_line_count),...
                'Userdata',param.text);
            params=sethandle(params,param.text,hand,param.panel);
            if strcmp(param.text,'other...')
                pos_x=pos_x+4;
%                 width=max(window_width-pos_x-5,10);
                width=maxeditwidth-1;
                if isfield(param,'userdata')
                    userstr=param.userdata;
                else
                    userstr='';
                end
                hand2 = uicontrol(...        % string edit box
                    'Parent',parentpanel,...
                    'Units','characters',...
                    'BackgroundColor',[1 1 1],...
                    'Position',[pos_x pos_y width elementhigth],...
                    'Callback',callbackstr,...
                    'String',userstr,...
                    'Style','edit',...
                    'enable',enableval,...
                    'HorizontalAlignment','left',...
                    'Tag',sprintf('other_entry%d',general_line_count),...
                    'Userdata',param.text);
                params=sethandle(params,param.text,hand2,param.panel,2);
                %                 params=sethandle(params,param.text,param.panel,hand2,2);
            end
        case {'filename','directoryname'}
            if current_panel_count==1
                pos_x=maxtextlen+spacebetweentextandedit+2*leftoffset;
                pos_y=general_line_count*rowheight-all_y_offset;
            else
                pos_x=maxtextlen+spacebetweentextandedit+2*leftoffset-3;
                pos_y=linecount(current_panel_count)*rowheight-all_y_offset;
            end

            hand = uicontrol(...    % bool: radiobutton
                'Parent',parentpanel,...
                'Units','characters',...
                'BackgroundColor',[1 1 1],...
                'Position',[pos_x pos_y filenamelength elementhigth],...
                'enable',enableval,...
                'string',param.value,...
                'Style','edit',...
                'Callback',callbackstr,...
                'Tag',sprintf('entry%d',general_line_count),...
                'Userdata',param.panel); % for radiobuttons it is important to know in which context they appear
            params=sethandle(params,param.text,hand,param.panel);
            % and a button
            pos_x=pos_x+filenamelength+2;
            str=' select...';
            width=length(str);
            hand2 = uicontrol(...        % string edit box
                'Parent',parentpanel,...
                'Units','characters',...
                'Position',[pos_x pos_y width elementhigth+0.2],...
                'Callback',callbackstr,...
                'String',str,...
                'Style','pushbutton',...
                'HorizontalAlignment','left',...
                'enable',enableval,...
                'Tag',sprintf('other_entry%d',general_line_count),...
                'Userdata',param.text);
            params=sethandle(params,param.text,hand2,param.panel,2);
            %                 params=sethandle(params,param.text,param.panel,hand2,2);

        case 'button'
            textlen=length(param.text)+4;
            buttonwidth=2*spacearoundtext+textlen;
            if current_panel_count==1
                buttonposy=rowheight*linecount(current_panel_count)-yoffset-all_y_offset-extrabuttondown+0.5;
            else
                buttonposy=rowheight*linecount(current_panel_count)-yoffset-all_y_offset-extrabuttondown-3+0.5;
            end

            hand = uicontrol(...    % button
                'Parent',parentpanel,...
                'Units','characters',...
                'Callback',callbackstr,...
                'Position',[buttonoffset+2*leftoffset buttonposy+0.1 buttonwidth 1.8],...
                'String',param.text,...
                'Style','pushbutton',...
                'enable',enableval,...
                'KeyPressFcn',@doFigureKeyPress , ...
                'Tag',sprintf('entry%d',general_line_count),...
                'Userdata',param.text);
            %                 'backgroundcolor',[0.5 1 1],...
            %                 'foregroundcolor',[0.5 1 1],...
            params=sethandle(params,param.text,hand,param.panel);

            if param.isdefaultbutton==1
                setappdata(guihandle, 'DefaultValid', true);
                h = uicontrol(...
                    'Units','characters',...
                    'BackgroundColor', 'k', ...
                    'Style','frame',...
                    'Position',[buttonoffset+2*leftoffset-0.5 buttonposy-0.05 buttonwidth+0.9 1.9],...
                    'Parent',parentpanel...
                    );
                uistack(h,'bottom')
            end

        case 'pop-up menu'
            if current_panel_count==1
                pos_x=maxtextlen+spacebetweentextandedit+2*leftoffset;
                pos_y=general_line_count*rowheight-all_y_offset;
            else
                pos_x=maxtextlen+spacebetweentextandedit+2*leftoffset-3;
                pos_y=linecount(current_panel_count)*rowheight-all_y_offset;
            end

            hand = uicontrol(...    % bool: radiobutton
                'Parent',parentpanel,...
                'Units','characters',...
                'BackgroundColor',[1 1 1],...
                'Position',[pos_x pos_y popuplength elementhigth],...
                'string',param.possible_values,...
                'Style','popupmenu',...
                'enable',enableval,...
                'Callback',callbackstr,...
                'Tag',sprintf('entry%d',general_line_count),...
                'Userdata',param.panel); % for radiobuttons it is important to know in which context they appear
            params=sethandle(params,param.text,hand,param.panel);
    end

    linecount(current_panel_count)=linecount(current_panel_count)+1;
    general_line_count=general_line_count+1;
end

hsingleton = guihandle;


% --- Handles default parameterguiDE parametergui creation and callback dispatch
function varargout = parametergui_mainfcn(parametergui_State, varargin)

parametergui_StateFields =  {'parametergui_Name'
    'parametergui_Singleton'
    'parametergui_OpeningFcn'
    'parametergui_OutputFcn'
    'parametergui_LayoutFcn'
    'parametergui_Callback'};
parametergui_Mfile = '';
for i=1:length(parametergui_StateFields)
    if ~isfield(parametergui_State, parametergui_StateFields{i})
        error('Could not find field %s in the parametergui_State struct in parametergui M-file %s', parametergui_StateFields{i}, parametergui_Mfile);
    elseif isequal(parametergui_StateFields{i}, 'parametergui_Name')
        parametergui_Mfile = [getfield(parametergui_State, parametergui_StateFields{i}), '.m'];
    end
end

numargin = length(varargin);

if numargin == 0
    % parametergui
    % create the parametergui
    parametergui_Create = 1;
elseif numargin > 3 && ischar(varargin{1}) && ishandle(varargin{2})
    % parametergui('CALLBACK',hObject,eventData,handles,...)
    parametergui_Create = 0;
else
    % parametergui(...)
    % create the parametergui and hand varargin to the openingfcn
    parametergui_Create = 1;
end

%SB: return values
global params

if parametergui_Create == 0
    varargin{1} = parametergui_State.parametergui_Callback;
    if nargout
        [varargout{1:nargout}] = feval(varargin{:});
    else
        feval(varargin{:});
    end
else
    if parametergui_State.parametergui_Singleton
        parametergui_SingletonOpt = 'reuse';
    else
        parametergui_SingletonOpt = 'new';
    end

    % Open fig file with stored settings.  Note: This executes all component
    % specific CreateFunctions with an empty HANDLES structure.
    % make params global, so that I can access them in the generation
    % function
    params=varargin{1};

    % Do feval on layout code in m-file if it exists
    if ~isempty(parametergui_State.parametergui_LayoutFcn)
        gui_hFigure = feval(parametergui_State.parametergui_LayoutFcn, parametergui_SingletonOpt);
        % SB: the original one finds the wrong one, possible because it just looks
        % for the first one with the m-file. We can do better:

        all_childs=get(0,'children');
        this_name=getname(params);
        for i=1:length(all_childs)
            name=get(all_childs(i),'name');
            if strcmp(name,this_name)
                gui_hFigure=all_childs(i);
                break
            end
        end

    else
        gui_hFigure = local_openfig(parametergui_State.parametergui_Name, parametergui_SingletonOpt);
        % If the figure has InparameterguiInitialization it was not completely created
        % on the last pass.  Delete this handle and try again.
        if isappdata(gui_hFigure, 'InparameterguiInitialization')
            delete(gui_hFigure);
            gui_hFigure = local_openfig(parametergui_State.parametergui_Name, parametergui_SingletonOpt);
        end
    end

    % Set flag to indicate starting parametergui initialization
    setappdata(gui_hFigure,'InparameterguiInitialization',1);

    % Fetch parameterguiDE Application params
    parametergui_Options = getappdata(gui_hFigure,'parameterguiDEOptions');

    if ~isappdata(gui_hFigure,'parameterguiOnScreen')
        % Adjust background color
        if parametergui_Options.syscolorfig
            set(gui_hFigure,'Color', [0.831372549019608 0.815686274509804 0.784313725490196]);
        end

        % Generate HANDLES structure and store with guidata
        guidata(gui_hFigure, guihandles(gui_hFigure));
    end



    % If user specified 'Visible','off' in p/v pairs, don't make the figure
    % visible.
    parametergui_MakeVisible = 1;
    for ind=1:2:length(varargin)
        if length(varargin) == ind
            break;
        end
        len1 = min(length('visible'),length(varargin{ind}));
        len2 = min(length('off'),length(varargin{ind+1}));
        if ischar(varargin{ind}) && ischar(varargin{ind+1}) && ...
                strncmpi(varargin{ind},'visible',len1) && len2 > 1
            if strncmpi(varargin{ind+1},'off',len2)
                parametergui_MakeVisible = 0;
            elseif strncmpi(varargin{ind+1},'on',len2)
                parametergui_MakeVisible = 1;
            end
        end
    end

    % Check for figure param value pairs
    for index=1:2:length(varargin)
        if length(varargin) == index
            break;
        end
        try
            set(gui_hFigure, varargin{index},vargin{index+1});
        catch
            break
        end
    end

    % If handle visibility is set to 'callback', turn it on until finished
    % with OpeningFcn
    parametergui_HandleVisibility = get(gui_hFigure,'HandleVisibility');
    if strcmp(parametergui_HandleVisibility, 'callback')
        set(gui_hFigure,'HandleVisibility', 'on');
    end

    % SB: save the user structure to the handle struct
    handles=guidata(gui_hFigure);
    handles.params=params;
    guidata(gui_hFigure, handles);
    feval(parametergui_State.parametergui_OpeningFcn, gui_hFigure, [], handles, varargin{:});




    if ishandle(gui_hFigure)
        % Update handle visibility
        set(gui_hFigure,'HandleVisibility', parametergui_HandleVisibility);

        % Make figure visible
        if parametergui_MakeVisible
            set(gui_hFigure, 'Visible', 'on')
            if parametergui_Options.singleton
                setappdata(gui_hFigure,'parameterguiOnScreen', 1);
            end
        end

        % Done with parametergui initialization
        rmappdata(gui_hFigure,'InparameterguiInitialization');
    end

    % If handle visibility is set to 'callback', turn it on until finished with
    % OutputFcn
    if ishandle(gui_hFigure)
        parametergui_HandleVisibility = get(gui_hFigure,'HandleVisibility');
        if strcmp(parametergui_HandleVisibility, 'callback')
            set(gui_hFigure,'HandleVisibility', 'on');
        end
        parametergui_Handles = guidata(gui_hFigure);
    else
        parametergui_Handles = [];
    end


    % SB: if the window was reused then update the handles in the params, so
    % that they can be recalculated.
    % this only works when the number and type of variables have not
    % changed in between
    if strcmp(parametergui_SingletonOpt,'reuse')
        dsnew=get(handles.params); % the new parameter without handles
        nr_ds=length(dsnew);
        fields=fieldnames(handles);
        for i=1:nr_ds % we have to find the uicontrol with these two features:
            searchtext=dsnew{i}.text;
            searchpanel=dsnew{i}.panel;
            searchtype=dsnew{i}.type;
            nr_h=length(fields);
            for j=1:nr_h  % search through all
                fh=getfield(handles,fields{j});
                if ishandle(fh)
                    type=get(fh,'type');
                    [nr_enty,len]=size(type);
                    if nr_enty>1
                        type=type(1);
                        secondh=fh(1);
                        fh=fh(2);
                    end
                    if strcmp(type,'uipanel') && strcmp(searchtype,'panel')
                        panelname=get(fh,'title');
                        if strcmp(searchpanel,panelname)
                            params=sethandle(params,searchtext,fh,searchpanel); % set the handle
                            break
                        end
                    end
                    % if its not a panel then its an uicontrol
                    if strcmp(type,'uicontrol')
                        parent=get(fh,'parent');
                        panelname=get(parent,'title'); % this is the panel
                        if strcmp(panelname,'')
                            panelname='all';
                        end
                        uiname=get(fh,'UserData');

                        if strcmp(searchpanel,panelname) && strcmp(searchtext,uiname)
                            params=sethandle(params,searchtext,fh,searchpanel); % set the handle
                            if nr_enty>1
                                params=sethandle(params,searchtext,secondh,searchpanel,2); % set the handle
                            end
                            break
                        end

                        %                     newstyle=get(fh,'style');
                        %                     if strcmp(orgstyle,newstyle)
                        %                         str2=get(fh,'UserData');
                        %                         if strcmp(str1,str2)
                        %                             params=sethandle(params,str1,fh); % set the handle
                        %                             style=get(fh,'style');
                        %                             switch style
                        %                                 case 'edit'
                        %                                     params=set(params,str1,get(fh,'string'));
                        %                                 case {'checkbox','radiobox','int','float'}
                        %                                     params=set(params,str1,get(fh,'value'));
                        %                                     params=set(params,str1,get(fh,'value'));
                        %                             end
                        %                             break
                        %                         end
                        %                     end
                    end
                end
                %                 h=gethandle(params,searchtext,searchpanel);
            end
        end
        handles.params=params;
        guidata(gui_hFigure, handles);
    end



    if nargout
        global result
        parametergui_Handles=result;
        if strcmp(getmode(handles.params),'nonmodal')
            result=params;
        end
        [varargout{1:nargout}] = feval(parametergui_State.parametergui_OutputFcn, gui_hFigure, [], parametergui_Handles);
    else
        feval(parametergui_State.parametergui_OutputFcn, gui_hFigure, [], parametergui_Handles);
    end

    if ishandle(gui_hFigure)
        set(gui_hFigure,'HandleVisibility', parametergui_HandleVisibility);
    end


end


function gui_hFigure = local_openfig(name, singleton)
if nargin('openfig') == 3
    gui_hFigure = openfig(name, singleton, 'auto');
else
    % OPENFIG did not accept 3rd input argument until R13,
    % toggle default figure visible to prevent the figure
    % from showing up too soon.
    parametergui_OldDefaultVisible = get(0,'defaultFigureVisible');
    set(0,'defaultFigureVisible','off');
    gui_hFigure = openfig(name, singleton);
    set(0,'defaultFigureVisible',parametergui_OldDefaultVisible);
end

function doFigureKeyPress(obj, evd)
switch(evd.Key)
    case {'return','space'}
        if getappdata(gcbf,'DefaultValid')
            handles=guidata(gcbf);
            generic_Callback([],'default',handles)
        end
    case 'escape'
        close(gcbf)
end
