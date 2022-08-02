function stat_out = playbiodemo(action,caller)
%PLAYBIODEMO Plays a cell-formatted demo as a paused-style demo.
%
%  PLAYBIODEMO should only be invoked from the beginning of the demo that
%  it is desired to run in a paused-style. PLAYBIODEMO allows to step
%  through the 'caller' demo and interact with the demo variables in the
%  MATLAB command window. For more advanced debugging options open the demo
%  with the MATLAB editor/debugger. 
%
%  Notes:
%  -The 'reset' option must be used with care, since it will rewind the code
%   execution to the start, but will not clear any already created variable.
%  -Requires java, otherwise it will not pause the demo
%
%  Example:
%
%        if playbiodemo return; end

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.6 $  $Date: 2004/04/01 15:58:45 $
%

stat_out = true; % when stat_out is true, it will stop the execution of the
                 % calling demo (normal behaivor)                              
                 
dbs = dbstack;   % stack of functions
Data.filename = dbs(end).name; % caller program
if nargin == 2       % called from playbiodemo
    figBio = caller; % and passing the gui handler
else
    figBio = gcbf;   % called from the gui
end
if nargin<1
    action = 'init';
    if numel(figBio)                 % There is another demo running
        action = 'stop_here';
    elseif numel(dbstatus(Data.filename)) % There are breakpoints in  
                                     % the file, it means it is being  
                                     % debugged, no need to add pauses
        action = 'no_action';
    elseif numel(dbs) ~= 2           % There must be only 2 functions 
        action = 'stop_here';        % in the stack
    end
else % nargin == 1
    if isempty(figBio)              % no gui to execute the action,
        action = 'stop_here';       %       who called me ?!
    elseif strcmpi(action,'init')   % do not let to re-init manually
        action = 'stop_here';
    end
end

if ~usejava('desktop')
    action = 'no_action';           % must have java to run playbiodemo
end
    
switch lower(action) case 'init'

    switch questbiodemo
        case 'Codepad'
            edit(Data.filename)
            stat_out = true;
            return
        case 'Slideshow'
            % do nothing, continue with init of this GUI
        otherwise 
            stat_out = true;
            return
    end
    
    % load m file
    fid=fopen(which(Data.filename),'r');
    Data.str = fscanf(fid,'%c');
    fclose(fid);
    
    % Normalize line endings to Unix-style.
    Data.str = strrep(Data.str,char([13 10]),char(10));
    Data.str = strrep(Data.str,char(13),char(10));
    
    % Append an 'end of demo' cell
    Data.str = [Data.str char(10) '%% ********** END OF DEMO **********'];

    % find cells
    Data.h = union([1 length(Data.str)],findstr(Data.str,'%%'));
    Data.numcells = numel(Data.h) - 1;
    Data.count = 1; % reset counter 
    Data.shfilename = dir(which(Data.filename));
    
    %========================= The GUI figure ============================
    figureName = ['Playbiodemo : ' Data.shfilename.name];
    figBio = figure('Name',figureName,'NumberTitle','off', ...
                   'MenuBar','none','Visible','off', ...
                   'IntegerHandle','off','tag','playbiodemo');

    %======================= The Comment Window ==========================
    top=0.97; bottom=0.15; left=0.02;  right=0.98;
    labelHt=0.05; spacing=0.005; frmBorder=0.01;

    % First, the MiniCommand Window frame
    frmPos=[left-frmBorder bottom-frmBorder ...
            (right-left)+2*frmBorder (top-bottom)+2*frmBorder];
    uicontrol('Style','frame', 'Units','normalized', ...
             'Position',frmPos, 'BackgroundColor',[0.5 0.5 0.5]);
    % Then the text label
    labelPos=[left top-labelHt (right-left) labelHt];
    uicontrol('Style','text','Units','normalized', ...
              'Position',labelPos,'BackgroundColor',[0.5 0.5 0.5], ...
              'ForegroundColor',[1 1 1],'String','Comment Window');
    % Then the editable text field
    txtPos=[left bottom (right-left) top-bottom-labelHt-spacing];
    txtHndl=uicontrol('Units','normalized','Position',txtPos, ...
                      'Style','listbox','Max',2,'Min',0,...
                      'Value',[],'Enable','inactive','FontSize',9); 

    %=======================  Information for all buttons ================
    %labelColor=[0.8 0.8 0.8];
    top=0.11; bottom=0.03; left=0.02; right=0.98;
    btnWid=0.12; btnHt=0.07; spacing=0.04; frmBorder=0.01;

    %========================= The CONSOLE frame =========================
    frmPos=[left-frmBorder bottom-frmBorder ...
         (right-left)+2*frmBorder (top-bottom)+2*frmBorder];
    uicontrol('Style','frame', 'Units','normalized', ...
       'Position',frmPos,'BackgroundColor',[0.5 0.5 0.5]);

    %========================= The Step button ===========================
    btnNumber=1;
    labelStr='Start >>';
    callbackStr='playbiodemo(''step'');';
    btnPos=[left+spacing bottom btnWid btnHt];
    Data.btn1 = uicontrol('Style','pushbutton','Units','normalized', ...
              'Position',btnPos,'String',labelStr, ...
              'Callback',callbackStr,'UserData',btnNumber); 

    %========================= The Edit button ===========================
    btnNumber=2;
    labelStr='View code';
    callbackStr='playbiodemo(''edit'');';
    btnPos=[right-2*spacing-2*btnWid bottom btnWid btnHt];
    Data.btn2 = uicontrol('Style','pushbutton','Units','normalized', ...
                          'Position',btnPos,'String',labelStr, ...
                          'Callback',callbackStr,'UserData',btnNumber); 

    %========================= The Reset button ===========================
    btnNumber=3;
    labelStr='Reset';
    callbackStr='playbiodemo(''Reset'');';
    btnPos=[left+2*spacing+btnWid bottom btnWid btnHt];
    Data.btn3 =uicontrol('Style','pushbutton','Units','normalized', ...
                         'Position',btnPos,'String',labelStr, ...
                         'Callback',callbackStr,'UserData',btnNumber);

    %========================= The Close button ===========================
    btnNumber=4;
    labelStr='Close';
    callbackStr='close(gcbf)';
    btnPos=[right-spacing-btnWid bottom btnWid btnHt];
    Data.btn4 = uicontrol('Style','pushbutton','Units','normalized', ...
                          'Position',btnPos,'String',labelStr, ...
                          'Callback',callbackStr,'UserData',btnNumber); 

    % save gui data and set the gui ready
    Data.txtHndl = txtHndl;          % Handle to put text in the gui
    Data.lastfigure=gcf;             % Set the last figure
    Data.firstTime=true;
    guidata(figBio,Data);            % Save guidata
    % Put the window in the bottom-rigth corner
    figPos = get(figBio,'Position'); 
    ScreenSz = get(0,'ScreenSize');
    set(figBio,'Position',[ScreenSz(3)-figPos(3) 50 figPos(3) figPos(4)*2/3]);
    set(figBio,'Visible','on');            % Now uncover the figure   
    set(figBio,'HandleVisibility','off');  % and hide its handle visibility
    playbiodemo('step',figBio);            % Do the first step
           
case 'step'
    set(figBio,'Pointer','watch')
    Data = guidata(figBio);
    % turn off buttons in gui
    set([Data.btn1 Data.btn2 Data.btn3 Data.btn4],'Enable','off')
    % prepares strings
    strtodisp = char(Data.str(Data.h(Data.count):Data.h(Data.count+1)-1));
    celltodisp = strread(strtodisp,'%s','delimiter','\n','whitespace','');
    if Data.count == 1
        h = cellfun('isempty',regexp(celltodisp,'if playbiodemo'));
        celltodisp = celltodisp(h);
    end
    set(Data.txtHndl,'String',celltodisp)  % put it in gui
    commcells = strread(strtodisp,'%s','delimiter','\n','commentstyle',...
        'matlab','whitespace','')';
    commcells(strcmp(commcells,''))=[]; % erase empty lines
    commcells(2,:)=deal({char(10)});    % bring back the 'new line' chars
    
    % WARNING: The following java methods are not supported by The
    % MathWorks, Inc. and will change in future releases, use them at your
    % own risk.
    
    % Bring command window console to front
    % com.mathworks.ide.desktop.MLDesktop.getMLDesktop.showClient('Command Window');
    drawnow % wait for the command window to finish drawing.
    % send commands to the console (asynchronous)
    com.mathworks.ide.cmdline.MatlabCommandWidget.executeCommand(horzcat(commcells{:}))
    % synchronizes after the commands
    com.mathworks.ide.cmdline.MatlabCommandWidget.consoleEval(['playbiodemo(''sync'',' num2str(figBio,20) ');'])
    
case 'sync'
    %pause(.1) % allows text flow to the command window
    drawnow
    Data = guidata(figBio);
    Data.count = Data.count + 1;
    if Data.count > 2 
        set(Data.btn1,'String','Next >>'); 
    end
    if Data.count > Data.numcells
        set([Data.btn1],'Enable','off')
        set([Data.btn2 Data.btn3 Data.btn4],'Enable','on')
    else
        set([Data.btn1 Data.btn2 Data.btn3 Data.btn4],'Enable','on')
    end
    set(figBio,'Pointer','arrow')
    figure(figBio);             % last thing to do is to bring gui to front 
    guidata(figBio,Data);       % save modifyied counter    
case 'edit'
    Data = guidata(figBio);
    edit(Data.filename)
case 'reset'
    Data = guidata(figBio);
    Data.count = 1;
    set([Data.btn1],'Enable','on')
    set(Data.btn1,'String','Start >>')
    guidata(figBio,Data);
    playbiodemo('step',figBio);
case 'stop_here'
    % stat_out = true which will stop the calling demo
otherwise % or no_action
    stat_out = false; % will let the calling demo continue
end % switch action


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function selection = questbiodemo
% quest window to select the method to run a demonstration

% set the strings
CBString = 'uiresume(gcbf)';
IntroStr = 'There are two options to run a demonstration in the Bioinformatics Toolbox:';
Option1Str = 'Open the demo code in the MATLAB Editor and run it step by step using the "Cell" tools or the advanced debugging options.';
Option2Str = 'Run the demo step by step using a Slideshow-style interface.';    
WindowTitlte = 'Bioinformatics Toolbox Demonstration';
BkgColor = [0.831373 0.815686 0.784314];
% setup the quest box
c = get(0,'ScreenSize')*[1 0;0 1;.5 0;0 .5];
QuestFig = figure('WindowStyle','modal','Color',BkgColor,...
             'Position',[c-[180 100] 360 200],'Resize','off','NumberTitle','off',...
             'KeyPressFcn',@doFigureKeyPress,'IntegerHandle','off',...
             'Name',WindowTitlte);
uicontrol(QuestFig,'style','text','Position',[21 160 320 30],'HorizontalAlignment','left','string',IntroStr,'BackgroundColor',BkgColor)
h1 = uibuttongroup('Position',[.04 .25 .92 .55],'BorderType','none','BackgroundColor',BkgColor);
uicontrol(h1,'style','radiobutton','Position',[5 85 20 20],'BackgroundColor',BkgColor,'Tag','Codepad','value',1);
uicontrol(h1,'style','radiobutton','Position',[5 30 20 20],'BackgroundColor',BkgColor,'Tag','Slideshow');
uicontrol(h1,'style','text','Position',[25 50 310 50],'HorizontalAlignment','left','string',Option1Str,'BackgroundColor',BkgColor)
uicontrol(h1,'style','text','Position',[25 15 310 30],'HorizontalAlignment','left','string',Option2Str,'BackgroundColor',BkgColor)
uicontrol(QuestFig,'style','pushbutton','Position',[80 20 60 30],'string','OK','Callback',CBString,'KeyPressFcn',@doControlKeyPress,'BackgroundColor',BkgColor);
uicontrol(QuestFig,'style','pushbutton','Position',[195 20 60 30],'string','Cancel','Callback',CBString,'KeyPressFcn',@doControlKeyPress,'BackgroundColor',BkgColor);

% make sure we are on screen
movegui(QuestFig)
set(QuestFig,'Visible','on');
drawnow;

% wait for an event (figure is modal)
uiwait(QuestFig);

% probably the figure was closed by other method, check if the handle still
% exists
if ishandle(QuestFig) 
    % check is a default shorcut was pressed ('return' or 'space' without
    % selecting an object)
    if isappdata(QuestFig,'DefaultPressed') && getappdata(QuestFig,'DefaultPressed')
        action = 'OK';
    else %if not, get the current value
        action = get(get(QuestFig,'CurrentObject'),'String');
    end
    switch action
        case 'OK'
            selection = get(findobj(QuestFig,'style','radiobutton','value',1),'tag');
        otherwise
            selection = 'Cancel';
    end
    delete(QuestFig);
else
    selection = 'Cancel';
end

function doFigureKeyPress(obj, evd)
switch(evd.Key)
    case {'return','space'}
        setappdata(gcbf,'DefaultPressed',true)
        uiresume(gcbf);
    case 'escape'
        delete(gcbf)
end

function doControlKeyPress(obj, evd)
switch(evd.Key)
    case 'return'
        uiresume(gcbf);
    case 'escape'
        delete(gcbf) 
end



