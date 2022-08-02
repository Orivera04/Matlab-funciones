function varargout = timeseriesviewer(varargin)
%% TIMESERIESVIEWER    Interactive application for exploring time series data
%
% TIMESERIESVIEWER opens the timeseriesviewer application. Detailed help is available
% from the help menu.  

% Scott Hirsch
% shirsch@mathworks.com
% 12/03


% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @timeseriesviewer_OpeningFcn, ...
    'gui_OutputFcn',  @timeseriesviewer_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before timeseriesviewer is made visible.
function timeseriesviewer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to timeseriesviewer (see VARARGIN)

% Choose default command line output for timeseriesviewer
handles.output = hObject;

% Handle multiple axes configurations.
% There are 4 configurations, containing between 1 and 4 axes. 
% All possible positions are laid out in guide, but we'll only use 4 of the
% axes.  Get the positions from all axes, then delete the ones we don't
% need.  We'll hide the axes we aren't currently using

% Store axes handles a bit more conveniently
ax1 = handles.Ax11;                                             %1 Axes
ax2 = [handles.Ax21 handles.Ax22];                              %2 Axes
ax3 = [handles.Ax31 handles.Ax32 handles.Ax33];                 %3 Axes
ax4 = [handles.Ax41 handles.Ax42 handles.Ax43 handles.Ax44];    %4 Axes

handles.axes = ax4;     %These are the only four we need
handles.axpos{1} = {get(ax1,'Position')};
handles.axpos{2} = get(ax2,'Position');
handles.axpos{3} = get(ax3,'Position');
handles.axpos{4} = get(ax4,'Position');

delete([ax1 ax2 ax3]);

% Initially, show only one axes
DA = 1;            %Vector from 1:number axes
set(ax4(DA),'Visible','on','Position',handles.axpos{1}{1});
set(ax4(DA+1:end),'Visible','off');

% Make the one visible axes look inactive
inactivecolor = [.7 .7 .7];
set(ax4(DA),'Color',inactivecolor,'XColor',inactivecolor,'YColor',inactivecolor);

% Configure drag and drop interface.
% Allow parameters to be dragged from parameter list to axes
% Also allow one axes to be dragged to another - replace the contents of
% the target with the source.  This is useful for moving a plot up to the
% top axes
% Finally, allow for parameters to be dragged from parameter list to
% TimeSelectPopup.  This defines these parameters as time bases, as removes
% them from the parameter list.
dd = dragndrop(handles.figure1);

set(dd,'DragHandles',[handles.listbox1 handles.axes]);
% set(dd,'DropHandles',[handles.axes handles.TimeSelectPopup]);
set(dd,'DropHandles',[handles.axes handles.AddTimeVectorsFrame]);
set(dd,'DropCallbacks',@localDropCallback);
set(dd,'DropValidDrag','all');
% set(dd,'DropValidDrag','all');

% Make only the Time Select popup valid.  Once the user adds something 
% to the TimeSelect, we'll enable visible axes, too.  This happens in
% localDropCallback.
% set(dd,'DropHandles',handles.TimeSelectPopup);
set(dd,'DropHandles',handles.AddTimeVectorsFrame);

handles.dd = dd;

% Add a context menu to the axes
% Add a context menu to each line
cmenu = uicontextmenu('Parent',handles.figure1);
set(handles.axes,'UIContextMenu',cmenu);
item1 = uimenu(cmenu, 'Label', 'Export Axes', ...        % Export Axes
    'Callback', @localExportAxes,'Tag','ExportAxes');

item2 = uimenu(cmenu, 'Label', 'Clear Axes', ...        % Clear Axes
    'Callback', @localClearAxes,'Tag','ClearAxes', ...
    'Separator','on');

% Put icons on toolbar
load zoom_icons
set(handles.ZoomButton,'CData',zoomxCData);

load datatip_icon
set(handles.DataLabelButton,'CData',cdata);

% Initialize a storage location for derived parameters
handles.derivedparameters = {};

% Initialize application data for storage of parameter names in each axes
for ii=1:length(handles.axes)
    setappdata(handles.axes(ii),'Parameters',{})
end;

% Load data from workspace
%   - populate parameter list with all 2D variables, except time
localUpdateParmlist(handles);

% Add a context menu to the parameter list
% I can't do this, because the context menu shows up whenever you drag!!
% cmenu = uicontextmenu('Parent',handles.figure1);
% set(handles.listbox1,'UIContextMenu',cmenu);
% item1 = uimenu(cmenu, 'Label', 'Clear', ...        % Clear Parameter
%     'Callback', @localClearParameter,'Tag','ClearParameter');
% item2 = uimenu(cmenu, 'Label', 'Update Parameters', ...        % Refresh Parameter List
%     'Callback', @localUpdateParmlist,'Tag','UpdateParameters');

% Initialize the TimeSelectPopup, so it knows that no data has been dragged
% to it.
firsttime = 1;
set(handles.TimeSelectPopup,'UserData',firsttime);

% Update handles structure
guidata(hObject, handles);
%UIWAIT makes timeseriesviewer wait for user response (see UIRESUME)
% uiwait(handles.figure1);

movegui(handles.figure1,'north')

% --- Outputs from this function are returned to the command line.
function varargout = timeseriesviewer_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1



function localDropCallback(drag,drop);
% Don't do anything if drop target is invisible (such as a hidden axes)
vis = get(drop,'Visible');
if ~strcmp(vis,'on')
    return
end;
handles = guidata(drag);        %Get handles structure

% Switch between drop target types:
% 1) Popupmenu.  Identify a parameter as a time basis.
% 2) Axes.  Drag and drop plotting

switch get(drop,'Type')
    case 'uicontrol'    % Identify a parameter as a time basis.
        
        % Special case for first time
        %  - Enable other controls
        %  - Replace string with parameters
        firsttime = get(handles.TimeSelectPopup,'UserData');
        if firsttime
            oldtimes = {};
            firsttime = 0;
            set(handles.TimeSelectPopup,'UserData',firsttime);
            
            % Enable dropping on the axes.
%             handles.dd = set(handles.dd,'DropHandles',[handles.axes(1) handles.TimeSelectPopup]);
            handles.dd = set(handles.dd,'DropHandles',[handles.axes(1) handles.AddTimeVectorsFrame]);
            
            
        else
            % Get original time list
            val = get(handles.TimeSelectPopup,'Value');
            oldtimes = get(handles.TimeSelectPopup,'String'); 
            oldtimes = localRemoveLengthFromParms(oldtimes);
            selectedtime = oldtimes{val};
        end;
        
        % Get new time vectors from parameter list
        val = get(drag,'Value');
        parms = get(drag,'String'); 
        
        % Strip lengths off of parms
        parms = localRemoveLengthFromParms(parms);
        
        newtimes = parms(val);             %Name of parameters
        
        % Build unique intersection of the lists.
        times = unique([oldtimes;newtimes]);
        
        % Remove from parameter list
        ind = 1:length(parms);
        keepind = setdiff(ind,val);
        parms = parms(keepind);
        
        % Update parameter list
        set(handles.listbox1,'Value',1);
        parms = localAddLengthToParms(parms);
        set(handles.listbox1,'String',parms);
        
        % Update list of time vectors and Select the new time vector 
        % (first if multiple added)
        val = find(strcmp(newtimes{1},times));
        times = localAddLengthToParms(times);
        set(handles.TimeSelectPopup,'String',times);
        set(handles.TimeSelectPopup,'Value',val);
        
        % Set the axis limits to the max range of all time vectors
        tlim = localGetAxesLimits(handles);
        set(handles.axes,'XLim',tlim);
        set(handles.axes,'XTick',[tlim(1) mean(tlim) tlim(2)]);
        
    case 'axes'         % Drag and drop plotting
        % Switch between valid drag sources: 1) Parameter list. 2) another axes
        switch get(drag,'Type')
            case 'uicontrol'        % Parameter List
                val = get(drag,'Value');
                strng = get(drag,'String'); 
                parms = strng(val);             %Name of parameters
                
                % Strip lengths off of parms
                parms = localRemoveLengthFromParms(parms);
                
                set(handles.figure1,'CurrentAxes',drop);
                
                % First time only:
                % * Enable some controls
                % * Turn off text directions covering the axes
                % * Change the axes color
                if strcmp(get(handles.DirectionsText,'Visible'),'on');
                    % Enable other controls
                    list = [handles.ZoomButton handles.CursorButton handles.DataLabelButton ...
                            handles.NoAxesCombo handles.NoAxesText];
                    set(list,'Enable','on');
                    
                    set(handles.DirectionsText,'Visible','off');
                    % Give axes normal colors
                    set(handles.axes,'Color','w','XColor','k','YColor','k')
                end;
                
                % Get list of parameters already plotted
                oldparms = getappdata(drop,'Parameters');
                
                % New parameters
                newparms = setdiff(parms,oldparms);
                
                % Each parameter could have multiple columns.  Need to
                % account for all of them.
                %                 nLines = 0;
                %                 for ii=1:length(newparms)
                %                     [nr,nc] = evalin('base',['size(' newparms{ii} ')']);
                %                     if nr<nc, % Force into columns
                %                         newparms{ii} = newparms{ii}'; 
                %                         [nr,nc] = size(newparms{ii});
                %                     end 
                %                     nLines = nLines = nc;
                %                 end;
                
                % Initialize array of line handles
                lh = [];
                
                % Color picking.  This is flawed, but good enough for now.
                colors = get(0,'defaultAxesColorOrder');
                cind = length(oldparms) + 1; nc = length(colors);  %Number of colors
                    cind = rem(cind,nc);    % limit to 1..nc
                    if cind==0, cind=size(colors,1); end;
                
                % Get time basis
                time = localGetCurrentTime(handles);
                
                % Store list of parameters that are actually plotted.  Any
                % parameters that aren't the same length as the time basis
                % will be removed
                newparms_keep = {};
                keepers = 0;
                for ii=1:length(newparms)
                    data = evalin('base',newparms{ii});
                    
                    % Don't plot if this variable is not defined on
                    % the current time.  Instead, display a NO
                    % cursor
                    if length(data) ~= length(time)
                        ptr = get(handles.figure1,'Pointer');
                        set(handles.figure1,'Pointer','custom');
                        set(handles.figure1,'PointerShapeCData',no_icon,'PointerShapeHotSpot',[9 9]);
                        pause(.2)
                        set(handles.figure1,'Pointer',ptr);
                        
                        continue    % Go to next iteration
                    end;
                    
                    % Handle
                    lh = [lh line(time, data, ...
                        'Parent',drop, ...
                        'Color',colors(cind,:))];
                    
                    % Add to list of parameters we actually plotted
                    keepers = keepers+1;
                    newparms_keep{keepers,1} = newparms{ii};
                    
                    %Cycle through colors
                    cind = rem(cind+1,nc);
                    if cind==0, cind=size(colors,1); end;
                end;
                
                % Build list of all parameters plotted on this axes.
                parms = unique([oldparms;newparms_keep]);
                
                % Store tags. Skip if didn't add any parameters
                if any(lh)
                    set(lh,{'Tag'},newparms_keep);                  %Store names in lines
                end;
                %     plot(handles.timeNumVec, handles.rawdata(:,val),'Parent',drop)
                setappdata(drop,'Parameters',parms);    %Store this so that we can restore legend
                localUpdateLegend(drop);
                
                
                %If datalabels are on, update them
                if get(handles.DataLabelButton,'Value')
                    datalabel('update');
                end;
                
                % Add a context menu to each line
                cmenu = uicontextmenu('Parent',handles.figure1);
                set(lh,'UIContextMenu',cmenu);
                
                % Define the context menu items
                %Label Max and Min
                item1 = uimenu(cmenu, 'Label', 'Label Max and Min', ...
                    'Callback', @localContextMenuCallback,'Tag','MaxMin');
                
                %Label mean
                item1 = uimenu(cmenu, 'Label', 'Label Mean', ...
                    'Callback', @localContextMenuCallback,'Tag','Mean');
                
                %Plot derivative
                item1 = uimenu(cmenu, 'Label', 'Plot derivative', ...
                    'Callback', @localContextMenuCallback,'Tag','Derivative');
                
                %Find Value
                item1 = uimenu(cmenu, 'Label', 'Find value', ...
                    'Callback', @localContextMenuCallback,'Tag','FindValue');
                
                %Delete this line
                item1 = uimenu(cmenu, 'Label', 'Delete', ...
                    'Callback', @localDeleteObject,'Separator','on');
                
            case 'axes'
                % Do nothing if dropping axes on itself
                if drag==drop
                    return
                end;
                
                % Get all children of drag axes
                dragkids = get(drag,'Children');
                dragmenus = get(dragkids,'UIContextMenu');
                if ~iscell(dragmenus), dragmenus = {dragmenus};end;
                if iscell(dragkids)
                    dragkids = cell2mat(dragkids);
                end;
                
                % Get all children of drop axes
                dropkids = get(drop,'Children');
                dropmenus = get(dropkids,'UIContextMenu');
                if iscell(dropkids)
                    dropkids = cell2mat(dropkids);
                end;
                if ~iscell(dropmenus), dropmenus = {dropmenus};end;
                
                % Swap children
                hgS_drag = handle2struct(dragkids);
                hgS_drop = handle2struct(dropkids);
                
                % Delete kids
                delete(dragkids)
                delete(dropkids)
                
                % Add children to axes
                newdropkids = struct2handle(hgS_drag,drop);
                set(newdropkids,{'UIContextMenu'},dragmenus)
                
                newdragkids = struct2handle(hgS_drop,drag);
                set(newdragkids,{'UIContextMenu'},dropmenus)
                
                
                % Update parameter list of axes
                dragparms = getappdata(drag,'Parameters');
                dropparms = getappdata(drop,'Parameters');
                setappdata(drop,'Parameters',dragparms);
                parms = getappdata(drop,'Parameters');
                setappdata(drag,'Parameters',dropparms);
                
                % Update legend on drop axes
                localUpdateLegend(drop)
                localUpdateLegend(drag)
                
            end;
    end;
    
    
    
    
    % --- Executes during object creation, after setting all properties.
    function NoAxesEdit_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to NoAxesEdit (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc
        set(hObject,'BackgroundColor','white');
    else
        set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
    end
    
    
    
    function NoAxesEdit_Callback(hObject, eventdata, handles)
    % hObject    handle to NoAxesEdit (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hints: get(hObject,'String') returns contents of NoAxesEdit as text
    %        str2double(get(hObject,'String')) returns contents of NoAxesEdit as a double
    
    % Adjust the number of visible axes
    
    % Error check - must be number between 1 and 4
    % --- Executes during object creation, after setting all properties.
    function NoAxesCombo_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to NoAxesCombo (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: slider controls usually have a light gray background, change
    %       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
    usewhitebg = 1;
    
    % Set slider to gray, edit box to white
    switch get(hObject,'style') 
        case 'slider'
            if usewhitebg
                set(hObject,'BackgroundColor',[.9 .9 .9]);
            else
                set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
            end
        case 'edit'
            set(hObject,'BackgroundColor',[1 1 1]);
    end;
    
    
    % --- Executes on slider movement.
    function NoAxesCombo_Callback(hObject, eventdata, handles)
    % hObject    handle to NoAxesCombo (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hints: get(hObject,'Value') returns position of slider
    %        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
    
    %I've created my own combobox - combining an edit box and a slider.  I gave
    %them both the same handle so that they would share a callback
    
    
    sl = handles.NoAxesCombo(1);        %Slider handle
    ed = handles.NoAxesCombo(2);        %Edit handle
    
    if hObject==sl      %Slider
        NoAx = round(get(sl,'Value'));
        set(ed,'String',num2str(NoAx));
        
    else                %Edit
        NoAx = str2num(get(hObject,'String'));
        
        if isempty(NoAx)
            NoAx=1;
            set(hObject,'String','1');
        end;
        
        NoAx = round(NoAx);
        if NoAx<1
            NoAx = 1;
            set(hObject,'String','1');
        elseif NoAx>4
            NoAx = 4;
            set(hObject,'String','4');
        end;    
    end;
    
    % Set the selected number of axes visible
    ax = handles.axes;      %Handles to axes
    
    set(ax(1:NoAx),'Visible','on',{'Position'},handles.axpos{NoAx});         %First NoAx are visible
    set(ax(NoAx+1:end),'Visible','off');    %The rest (if any) are not
    
    % Show XTicks on bottom axes only
%     set(ax(1:NoAx-1),'XTick',[]);
    localZoomCallback(handles.figure1);
    
    % Set the children of only the visible axes to be visible
    showkids = get(ax(1:NoAx),'Children');
    if iscell(showkids)
        showkids = cell2mat(showkids);
    end;
    hidekids = get(ax(NoAx+1:end),'Children');
    if iscell(hidekids)
        hidekids = cell2mat(hidekids);
    end;
    
    set(showkids,'visible','on');
    set(hidekids,'visible','off');
    
    % Reset the legends
    for ii=1:4
        legend(ax(ii),'off');
    end;
    
    for ii=1:NoAx
        if isappdata(ax(ii),'Parameters');
            parms = getappdata(ax(ii),'Parameters');
            if ~isempty(parms)
                legend(ax(ii),parms)
            end;
        end;
    end;
    
    % Reset the dragndrop targets to just the visible axes.  This will also
    % update the positions.
%     handles.dd = set(handles.dd,'DropHandles',[ax(1:NoAx) handles.TimeSelectPopup]);
    handles.dd = set(handles.dd,'DropHandles',[ax(1:NoAx) handles.AddTimeVectorsFrame]);
    
    guidata(handles.figure1,handles);
    % Set the positions
    
    % 
    % %Some fun and games to get a decent array of handles to children of each
    % %axes
    % ax1kids = get(ax1,'Children');
    % ax1kids = ax1kids';
    % ax2kids = get(ax2,'Children');ax2kids = cell2mat(ax2kids)';
    % ax3kids = get(ax3,'Children');ax3kids = cell2mat(ax3kids)';
    % ax4kids = get(ax4,'Children');ax4kids = cell2mat(ax4kids)';
    % 
    % %Delete all legends.  Add a new one when axes become visible
    % delete(findobj(handles.figure1,'Type','Axes','Tag','legend'));
    % 
    % if isempty(ax1kids)
    %     ax1kids = [];
    % end;
    % if isempty(ax2kids)
    %     ax2kids = [];
    % end;
    % if isempty(ax3kids)
    %     ax3kids = [];
    % end;
    % if isempty(ax4kids)
    %     ax4kids = [];
    % end;
    % 
    % 
    % switch NoAx
    %     case 1
    %         set([ax1 ax1kids],'Visible','on');
    %         set([ax2 ax3 ax4 ax2kids ax3kids ax4kids],'Visible','off');
    %         %         legend([ax2 ax3 ax4],'hide');
    %         %         legend(ax1,'show')
    %         legend(ax1,getappdata(ax1,'Parameters'))
    %     case 2
    %         set([ax2 ax2kids],'Visible','on');
    %         set([ax1 ax3 ax4 ax1kids ax3kids ax4kids],'Visible','off');
    %         %         legend([ax1 ax3 ax4],'hide');
    %         %         legend(ax2,'show')
    %         for ii=1:2
    %             if isappdata(ax2(ii),'Parameters');
    %                 legend(ax2(ii),getappdata(ax2(ii),'Parameters'))
    %             end;
    %         end;
    %     case 3
    %         set([ax3 ax3kids],'Visible','on');
    %         set([ax1 ax2 ax4 ax1kids ax2kids ax4kids],'Visible','off');
    %         %         legend([ax1 ax2 ax4],'hide');
    %         %         legend(ax3,'show')
    %         for ii=1:3
    %             if isappdata(ax3(ii),'Parameters');
    %                 legend(ax3(ii),getappdata(ax3(ii),'Parameters'))
    %             end;
    %         end;
    %     case 4
    %         set([ax4 ax4kids],'Visible','on');
    %         set([ax1 ax2 ax3 ax1kids ax2kids ax3kids],'Visible','off');
    % %         legend([ax1 ax2 ax3],'hide');
    % %         legend(ax4,'show')
    %         for ii=1:4
    %             if isappdata(ax4(ii),'Parameters');
    %                 legend(ax4(ii),getappdata(ax4(ii),'Parameters'))
    %             end;
    %         end;
    % end;
    % 
    %         
    
    
    
    
    % --- Executes on button press in ZoomButton.
    function ZoomButton_Callback(hObject, eventdata, handles)
    % hObject    handle to ZoomButton (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    val = get(hObject,'Value');
    if val
        %Turn off datalabels
        set(handles.DataLabelButton,'Value',0);
        datalabel off
        
        %Turn off cursors
        set(handles.CursorButton,'Value',0)
        eventlabel off
        
        %Turn on zoom
        linkedzoom(handles.axes,'onx',{@localZoomCallback,handles.figure1});
        
        % Reset legends - they get hidden by linkedzoom
        for ii=1:4
            localUpdateLegend(handles.axes(ii));
        end;
        
        
    else
        % Turn off zoom
        linkedzoom off
        
        % Reset axis limits
        localTurnOffZoom(handles);
        
    end;
    
    
    
    % --- Executes on button press in DataLabelButton.
    function DataLabelButton_Callback(hObject, eventdata, handles)
    % hObject    handle to DataLabelButton (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    val = get(hObject,'Value');
    if val
        %Turn off zoom
        set(handles.ZoomButton,'Value',0);
        linkedzoom off
        
        % Reset axis limits
        localTurnOffZoom(handles);
                
        %Turn off event labels
        set(handles.CursorButton,'Value',0)
        eventlabel off
        
        %Turn on datalabels
        datalabel on
        
    else
        datalabel off
    end;
    
    
    
    % --- Executes on button press in CursorButton.
    function CursorButton_Callback(hObject, eventdata, handles)
    % hObject    handle to CursorButton (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hint: get(hObject,'Value') returns toggle state of CursorButton
    
    val = get(hObject,'Value');
    if val
        %Turn off datalabels
        set(handles.DataLabelButton,'Value',0);
        datalabel off
        
        % Reset axis limits
        localTurnOffZoom(handles);
                
        %Turn off zoom
        set(handles.ZoomButton,'Value',0)
        linkedzoom off
        
        %Turn on cursors
        eventlabel
        
    else
        eventlabel off
    end;
    
    function localContextMenuCallback(hObject,eventdata);
    % Callback function for ContextMenu on lines
    fn = get(hObject,'Tag');
    handles = guidata(hObject);
    
    hLine = gco;        %Selected line
    xd = get(hLine,'XData');
    yd = get(hLine,'YData');
    parm = get(hLine,'Tag');
    hAx = get(hLine,'Parent');   %Axes handle
    
    switch fn
        case 'MaxMin'   %Compute and display max and min values
            % Label Max and Min of selected parameter
            % Compute max&min
            [ymax,maxind] = max(yd);
            [ymin,minind] = min(yd);
            
            xmax = xd(maxind);
            xmin = xd(minind);
            
            %Add text
            th(1) = text(xmax,ymax,{parm;['x_{max} = ' num2str(xmax)];['y_{max} = ' num2str(ymax)]});
            th(2) = text(xmin,ymin,{parm;['x_{min} = ' num2str(xmin)];['y_{min} = ' num2str(ymin)]});
            set(th(1),'VerticalAlignment','top');
            set(th(2),'VerticalAlignment','bottom');
            
            %Add marker, too
            lh(1) = line(xmax,ymax,'Color','k','Marker','o','MarkerFaceColor',get(hLine,'Color'),'MarkerSize',4);
            lh(2) = line(xmin,ymin,'Color','k','Marker','o','MarkerFaceColor',get(hLine,'Color'),'MarkerSize',4);
            
            setappdata(th(1),'h',lh(1));
            setappdata(th(2),'h',lh(2));
            setappdata(lh(1),'h',th(1));
            setappdata(lh(2),'h',th(2));
            
            %Right click marker or text to delete
            cmenu = uicontextmenu('Parent',handles.figure1);
            set([lh th],'UIContextMenu',cmenu);
            
            % Define the context menu items
            item1 = uimenu(cmenu, 'Label', 'Delete', ...
                'Callback', 'h=getappdata(gco,''h'');delete(h);delete(gco)');
            set(th,'BackgroundColor',localLighten(get(hLine,'Color')),'FontSize',8);
            set(th,'ButtonDownFcn','dragtext(gco)');
            
        case 'Mean'     %Compute and display mean value
            % Label Mean value of selected parameter
            
            % Compute mean
            ymn = mean(yd);
            
            
            % Add text.  Place it just to the right of the axis.
            xl = xlim(get(hLine,'Parent'));
            x = xl(2) - .05*diff(xl);
            th = text(x,ymn,{[parm ': mean = ' num2str(ymn)]});
            set(th,'VerticalAlignment','middle');
            
            % Add a line along the mean, too
            hMeanLine = line(xd,ymn*ones(1,length(xd)), ...
                'Color',localLighten(get(hLine,'Color')), ...
                'LineStyle', '-.');
            
            setappdata(th,'h',hMeanLine);
            setappdata(hMeanLine,'h',th);        
            
            %Right click text to delete
            cmenu = uicontextmenu('Parent',handles.figure1);
            set([th hMeanLine],'UIContextMenu',cmenu);
            
            % Define the context menu items
            item1 = uimenu(cmenu, 'Label', 'Delete', ...
                'Callback', 'h=getappdata(gco,''h'');delete(h);delete(gco)');
            set(th,'BackgroundColor',localLighten(get(hLine,'Color')),'FontSize',8);
            set(th,'ButtonDownFcn','dragtext(gco)');
            
        case 'Derivative'       %Plot the normalized derivative
            d = diff(yd);
            
            ymin = min(yd);     %We'll normalize to the original data
            ymax = max(yd);
            yl = [ymin ymax];
            
            dmn = min(d);
            dmx = max(d);
            
            dn = yl(1) + (d-dmn)*(diff(yl)/(dmx-dmn));   %Normalized to same scale as y
            dt = mean(diff(xd));        %Approximate dt
            dtime = xd(1:end-1)+.5*dt;  %Approximate time
            % Compute color for new line - same color, but lighter!
            color = get(hLine,'Color');
            color = localLighten(color);
            
            lh = line(dtime, dn,'Color',color);
            %         lh = patch([dtime NaN],[dn NaN],'k', ...
            %             'FaceColor','n', ...
            %             'EdgeColor',get(hLine,'Color'), ...
            %             'EdgeAlpha',.3);
            %         %Use patch instead of line, so that we can make it faint
            set(lh,'Tag',['d' parm]);
            
            %Right click line to delete
            cmenu = uicontextmenu('Parent',handles.figure1);
            set(lh,'UIContextMenu',cmenu);
            
            % Define the context menu items
            item1 = uimenu(cmenu, 'Label', 'Delete', ...
                'Callback', @localDeleteObject);
            
            % Update legend
            parms = getappdata(hAx,'Parameters');    %Store this so that we can restore legend        
            parms{end+1} = ['d' parm];
            setappdata(hAx,'Parameters',parms);
            legend(hAx,parms)
            
        case 'FindValue'        %Find a specified value
            % Create a simple dialog
            h = localCreateFindValueGUI([],[],'init',parm,handles);
            waitfor(h,'Tag');       %We change the tag when clicking apply button
            
            % Get updated handles structure
            handles = guidata(hObject);
            
            %Overlay conditional on plot
            values = handles.data.(parm).conditional.values;
            time   = handles.data.(parm).conditional.time;
            
            % Check if anything was found
            if all(isnan(values))
                msgbox('No values found','','modal');
                return
            end;
            
            % If only a few values, plot a marker
            if length(values)<=15 
                Marker = '*';
            else
                Marker = 'none';
            end;
            
            % Use same color as existing line, just a little thicker
            c = get(hLine,'Color');
            lh = line(time, values, ...
                'Parent',hAx, ...
                'Color',c, ...
                'LineWidth',3, ...
                'Marker',Marker, ...
                'Tag',handles.data.(parm).conditional.equation);
            
            parms = getappdata(hAx,'Parameters');
            parms{end+1} = handles.data.(parm).conditional.equation;
            
            setappdata(hAx,'Parameters',parms);
            
            % Add a context menu to delete
            cmenu = uicontextmenu('Parent',handles.figure1);
            set(lh,'UIContextMenu',cmenu);
            
            % Define the context menu items
            item1 = uimenu(cmenu, 'Label', 'Delete', ...
                'Callback', @localDeleteObject);
            
            % Update the legend.
            localUpdateLegend(hAx)
            
            
            
    end;
    
    
    
    
    
    % --------------------------------------------------------------------
    function Untitled_1_Callback(hObject, eventdata, handles)
    % hObject    handle to Untitled_1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Unused callback for File menu (top level)
    % Do not delete
    
    function localZoomCallback(hFigure);
    % Callback for zoom action. 
    % Keep ticks at first, center, last
    % This is called by linkedzoom after each zoom update.
    
    % Get handles
    handles = guidata(hFigure); 
    
    % Get the axis limits
    noax = str2num(get(handles.NoAxesCombo(2),'String'));
    ax = handles.axes(noax);
    tlim = xlim(ax);
    
    % Set the ticks on last axes, hide on others
    NoAx = str2num(get(handles.NoAxesCombo(2),'String'));
    set(handles.axes(NoAx),'XTick',[tlim(1) mean(tlim([1 end])) tlim(end)]);
    set(handles.axes(1:NoAx-1),'XTick',[]);
    
    function localExportAxes(hObject,eventdata);
    % Callback for axes context menu item to export the axes (to a new
    % figure)
    
    % Clone the current axes
    hgS = handle2struct(gco);
    
    figure;
    ax = axes;
    struct2handle(hgS,ax);
    
    function localClearAxes(hObject,eventdata);
    % handle 2 input cases.
    switch get(hObject,'type')
        case 'axes'         % Internal call to clear axes
            h = hObject;  
        case 'uimenu'       % Context menu select clear
            h = gco;
    end;    
    
    % Callback for axes context menu item to clear the axes
    kids = get(h,'Children');     % Handle to children
    fig = get(h,'Parent');        % Figure handle
    
    if ~isempty(kids)               % Don't bother if there's nothing to delete
        localDeleteObject(kids,[],1);   % Third argument says delete all kids
    end;
    
    
    %     for ii=1:length(kids)
    %         set(fig,'CurrentObject',kids(ii));  % Make this child current (necessary for localDeleteObject)
    %         localDeleteObject(kids(ii),[]);
    %     end;
    
    function localDeleteObject(hObject,eventdata,deleteall);
    % Callback for context menu item to delete an object
    % Third input argument is an option for internal calls which tells
    % localDeleteObject that it is deleting all of the objects on an axes.
    % This provides speed benefits.  deleteall = 1 (true) or 0 (false).
    % You must still pass the handles to all objects you want to delete
    
    if nargin<3             % Default
        deleteall = 0;  
    end;
    
    % handle 2 input cases.
    switch get(hObject(1),'type')
        case 'uimenu'       % Context menu select clear
            h = gco;        % The selected line
        otherwise 
            h = hObject;  
    end;    
    
    % Delete an object and update the legend
    hAx = get(h(1),'Parent');       %Axes handle
    %     hAx = get(gco,'Parent');       %Axes handle
    handles = guidata(hObject(1));  % All handles
    parms = getappdata(hAx,'Parameters');    %Store this so that we can restore legend
    
    if deleteall
        % Remove parameters from list
        parmsnew = {};
        setappdata(hAx,'Parameters',parmsnew);
        
        % Delete objects
        delete(h)
        
        % Update legend
        localUpdateLegend(hAx)
        return
    end;
    
    
    
    %Remove from appdata
    thisparm = get(h,'Tag');
    %     thisparm = get(gco,'Tag');
    ind = strmatch(thisparm,parms);
    
    parmsnew = cell(length(parms)-1,1);
    for ii=1:length(parms)
        if ii<ind
            parmsnew{ii} = parms{ii};
        elseif ii>ind
            parmsnew{ii-1} = parms{ii};
        end;
    end;
    
    setappdata(hAx,'Parameters',parmsnew);
    
    % Delete line
    delete(h)
    %     delete(gco)
    h = flipud(findobj(hAx,'Type','Line'));
    % Update legend
    % if length(parmsnew)>0
    localUpdateLegend(hAx)
    % end;
    
    function hFigureFV = localCreateFindValueGUI(hObject,eventdata,action,parm,mainhandles);
    
    switch action
        case 'init' %Initialize
            hFigureFV = figure('Position',[300 300 150 80], ...
                'MenuBar','none','NumberTitle','off','Name','Find Values', ...
                'Visible','off','HandleVisibility','Callback');%, ...
            %            'CloseRequestFcn',{@localCreateFindValueGUI,'close',[],mainhandles});
            %             'WindowStyle','modal');
            
            movegui(hFigureFV,'center');
            set(hFigureFV,'Visible','on');
            
            hParm = uicontrol(hFigureFV, ...            % Parameter text string
                'Position',[10 50 40 17], ...
                'Style','text', ...
                'String',parm, ...
                'BackgroundColor',get(0,'defaultFigureColor'), ...
                'Tag','Parm');
            hOperator = uicontrol(hFigureFV, ...        % Operator menu
                'Position',[55 50 40 20], ...
                'Style','Popupmenu', ...
                'String',{'==';'<';'>';'<=';'>='}, ...
                'BackgroundColor','white', ...
                'Tag','Operator');        
            hValue = uicontrol(hFigureFV, ...           % Value edit box
                'Position',[100 50 40 20], ...
                'Style','Edit', ...
                'String','', ...
                'BackgroundColor','white', ...
                'Tag','Value');   
            hApply = uicontrol(hFigureFV, ...           % Apply button
                'Position',[25 10 40 20], ...
                'Style','Pushbutton', ...
                'String','Apply', ...
                'Callback',{@localCreateFindValueGUI,'apply',[],mainhandles});   
            hClose = uicontrol(hFigureFV, ...           % Close button
                'Position',[85 10 40 20], ...
                'Style','Pushbutton', ...
                'String','Close', ...
                'Callback',{@localCreateFindValueGUI,'close',[],mainhandles});   
            
            handles = guihandles(hFigureFV);
            guidata(hFigureFV,handles)
            
            
            
        case 'apply'
            handles= guidata(hObject);
            
            parm = get(handles.Parm,'String');
            str = get(handles.Operator,'String');
            opind = get(handles.Operator,'Value');
            operator = str{opind};
            
            value = str2num(get(handles.Value,'String'));
            
            t = mainhandles.data.(parm).time;
            v = mainhandles.data.(parm).values;
            
            a = feval(operator,v,value);
            
            %Time and Value for which the condition is met.
            tfind = t;  tfind(~a) = NaN;
            vfind = v;  vfind(~a) = NaN;
            
            mainhandles.data.(parm).conditional.time = tfind;
            mainhandles.data.(parm).conditional.values = vfind;
            mainhandles.data.(parm).conditional.equation = [parm ' ' operator ' ' num2str(value)];
            
            % Update guidata for main application
            guidata(mainhandles.figure1,mainhandles);
            
            % Change the tag.  This indicates to the caller that something has
            % happened (it ends a waitfor condition)
            set(get(handles.Parm,'Parent'),'Tag',num2str(rand));
            
            
        case 'close'
            %         localCreateFindValueGUI(hObject,eventdata,'apply');
            delete(get(hObject,'Parent'));
            
    end;
    
    function localUpdateLegend(hAx)
    % Update the legend on axes hAx
    % Use the parameter list as the legend strings
    
    parms = getappdata(hAx,'Parameters');
    if ~isempty(parms)
        hLeg = legend(hAx,parms);
    else
        legend(hAx,'off');      %Turn off if plot is empty
    end;    
    
    
    
    % --- Executes during object creation, after setting all properties.
    function DerivedParametersListBox_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to DerivedParametersListBox (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: listbox controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc
        set(hObject,'BackgroundColor','white');
    else
        set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
    end
    
    
    % --- Executes on selection change in DerivedParametersListBox.
    function DerivedParametersListBox_Callback(hObject, eventdata, handles)
    % hObject    handle to DerivedParametersListBox (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hints: contents = get(hObject,'String') returns DerivedParametersListBox contents as cell array
    %        contents{get(hObject,'Value')} returns selected item from DerivedParametersListBox
    
    
    % --- Executes on button press in CreateDerivedButton.
    function CreateDerivedButton_Callback(hObject, eventdata, handles)
    % hObject    handle to CreateDerivedButton (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Open a generic edit box to let user type in equation
    
    eqn  = inputdlg('Enter equation, using names from parameter list (ALL CAPS)', ...
        'Create Derived Parameter');
    if isempty(eqn), return, end;
    eqn = eqn{1};       %Break out of cell
    
    % To just evaluate eqn, we need to define individual variables for each parameter.
    % The problem is that each parameter is on a unique time basis.  To get
    % around this, we have stored a field interpvalues in each parameter.  This
    % field contains the data interpolated to a common time basis.  This is
    % done by readsparsecsv.
    parmlist = fieldnames(handles.data);
    
    for ii=1:length(parmlist);
        name = parmlist{ii};
        assignhere(name,handles.data.(name).interpvalues);
    end;
    
    answer = eval(eqn);
    
    % Store results in a cell array within handles
    derivedparameters = handles.derivedparameters;
    new.equation = eqn;
    new.values = answer;
    % Don't need to store time - use handles.commontime
    
    % Add to derived parameter list
    str = get(handles.DerivedParametersListBox,'String');
    str{end+1} = eqn;
    set(handles.DerivedParametersListBox,'String',str);
    
    % Update handles structure
    if isempty(derivedparameters)   %First time only
        handles.derivedparameters = {new};
    else
        handles.derivedparameters = {derivedparameters; new};
    end;
    
    % Alternate approach:
    % Just add derived parameters to bottom of regular parameter list.  One
    % problem, though - the parameter display is not a valid MATLAB variable
    % (or field name).
    
    guidata(hObject, handles);
    
    
    
    
    
    
    function localParameterContextMenuCallback(hObject,eventdata);
    % Callback function for ContextMenu on lines
    fn = get(hObject,'Tag');
    handles = guidata(hObject);
    
    % Get selected parameters
    vals = get(gco,'Value');
    parmlist = get(gco,'String');
    parms = parmlist(vals);
    
    hLine = gco;        %Selected line
    xd = get(hLine,'XData');
    yd = get(hLine,'YData');
    parm = get(hLine,'Tag');
    hAx = get(hLine,'Parent');   %Axes handle
    
    % switch fn
    
    
    % --------------------------------------------------------------------
    function Untitled_2_Callback(hObject, eventdata, handles)
    % hObject    handle to Untitled_2 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    
    function color = localLighten(color)
    % Create a lighter version of a color
    chsv = rgb2hsv(color);
    chsv(2) = .25;     %Reduce luminescence value
    color = hsv2rgb(chsv);
        
    % --------------------------------------------------------------------
    % --------------------------------------------------------------------
    function HelpMain_Callback(hObject, eventdata, handles)
    % hObject    handle to HelpMain (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    
    % --------------------------------------------------------------------
    function HelpMenu_Callback(hObject, eventdata, handles)
    % hObject    handle to HelpMenu (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    thisdir = which(mfilename);
    thisdir = fileparts(thisdir);
    web([thisdir filesep 'private' filesep 'timeseriesviewer_help.html'])
    
    
    % --- Executes during object creation, after setting all properties.
    function TimeSelectPopup_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to TimeSelectPopup (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: popupmenu controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc
        set(hObject,'BackgroundColor','white');
    else
        set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
    end
    
    
    % --- Executes on selection change in TimeSelectPopup.
    function TimeSelectPopup_Callback(hObject, eventdata, handles)
    % Update the axes limits to reflect new time
    
    % time = localGetCurrentTime(handles);
    % set(handles.axes,'XLim',[time(1) time(end)]);
    % set(handles.axes,'XTick',[time(1) mean(time([1 end])) time(end)]);
    
    
    function localUpdateParmlist(varargin)
    if nargin==1
        handles = varargin{1};
    else
        handles = guidata(varargin{1});
    end;
    
    % Updates the listbox to match the current workspace
    vars = evalin('base','who');
    
    % Find candidate variables
    series = localFindSeries;
    
    if isempty(series)      % No valid candidates.  Demo mode
        disp('You have no valid time series in your workspace.  Running in demo mode');
        time1 = 0:.001:1;
        parm1a = sin(4*pi*time1);
        parm1b = rand(size(time1));
        time2 = 0:.035:1.25;
        parm2a = cos(pi*time2);
        parm2b = rand(size(time2));
        
        assignin('base','time1',time1);
        assignin('base','time2',time2);
        assignin('base','parm1a',parm1a);
        assignin('base','parm1b',parm1b);
        assignin('base','parm2a',parm2a);
        assignin('base','parm2b',parm2b);
        
        series = localFindSeries;
    end;
    
    
    % Exclude defined time parameters
    times = get(handles.TimeSelectPopup,'String');
    keepers = ~ismember(series,times);
    series = series(keepers);
    
    
    set(handles.listbox1,'String',series)
    
    
    function series = localFindSeries
    % Find potential series (eligible variables for this application)
    
    vars = evalin('base','whos');
    
    % Keep only 2D numeric real arrays with one singleton dimension (row or
    % column vectors; no matrices)
    series={};
    nkeep = 0;
    foundmatrices = 0;
    for ii=1:length(vars)
        
        % Must be numeric
        if isnumeric(evalin('base',[vars(ii).name]))
            if prod(vars(ii).size)>1    % Not a scalar. Keep going
                % If there is no singleton dimension, make a note and move
                % on.
                if ( vars(ii).size(1)~=1 & vars(ii).size(2)~=1)
                    foundmatrices = 1;
                else
                    nkeep = nkeep + 1;
                    %                     series{nkeep} = vars(ii).name;
                    series{nkeep,1} = [vars(ii).name '  (' num2str(max(vars(ii).size)) ')'];
                end;
            end;
        end;
    end;
    
    if foundmatrices
        warndlg([upper(mfilename) ' only supports row and column vectors. ' ...
                'Please split matrices into multiple variables.']);
    end;
    
    
    % --- Executes on button press in UpdateParametersButton.
    function UpdateParametersButton_Callback(hObject, eventdata, handles)
    % hObject    handle to UpdateParametersButton (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    localUpdateParmlist(handles)
    
    
    function time = localGetCurrentTime(handles);
    % Return vector of currently selected time
    timeslist = get(handles.TimeSelectPopup,'String');
    timeslist = localRemoveLengthFromParms(timeslist);
    timesind = get(handles.TimeSelectPopup,'Value');
    timestr = timeslist{timesind};
    time = evalin('base',timestr);
    
    function P = no_icon;
    % Create icon for mouse pointer indicating target isn't valid
    P=[ 2     2     2     2     2     2     2     2     2     2     2     2     2     2     2     2
        2     2     2     2     2     2     2     2     2     2     2     2     2     2     2     2
        2     2     2     2     2     2     2     2     2     2     2     2     2     2     2     2
        2     2     2     2     2     2     2     1     1     2     2     2     1     2     2     2
        2     2     2     2     2     1     1     2     2     1     1     1     2     2     2     2
        2     2     2     2     1     2     2     2     2     2     1     1     2     2     2     2
        2     2     2     2     1     2     2     2     2     1     2     1     2     2     2     2
        2     2     2     1     2     2     2     2     1     2     2     2     1     2     2     2
        2     2     2     1     2     2     2     1     2     2     2     2     1     2     2     2
        2     2     2     2     1     2     1     2     2     2     2     1     2     2     2     2
        2     2     2     2     1     1     2     2     2     2     2     1     2     2     2     2
        2     2     2     2     1     1     1     2     2     1     1     2     2     2     2     2
        2     2     2     1     2     2     2     1     1     2     2     2     2     2     2     2
        2     2     2     2     2     2     2     2     2     2     2     2     2     2     2     2
        2     2     2     2     2     2     2     2     2     2     2     2     2     2     2     2
        2     2     2     2     2     2     2     2     2     2     2     2     2     2     2     2];
    
    function tlim = localGetAxesLimits(handles);
    % Compute x axis limits
    timeslist = get(handles.TimeSelectPopup,'String');
    timeslist = localRemoveLengthFromParms(timeslist);
    tmin = inf;
    tmax = -inf;
    for ii=1:length(timeslist)
        time = evalin('base',timeslist{ii});
        if min(time) < tmin
            tmin = min(time);
        end;
        if max(time) > tmax
            tmax = max(time);
        end;
    end;
    
    tlim = [tmin tmax];
    
    function parms = localRemoveLengthFromParms(parms);
    % Remove the lengths from the parameter strings.
    for ii=1:length(parms);
        % Find the first blank.
        blank = strfind(parms{ii},' ');
        parms{ii} = parms{ii}(1:blank(1)-1);
    end;
    
    function parms = localAddLengthToParms(parms);
    % Remove the lengths from the parameter strings.
    for ii=1:length(parms);
        L = evalin('base',['length(' parms{ii} ');']);
        parms{ii} = [parms{ii} '  (' num2str(L) ')'];
    end;
    
%     function localClearParameter(hObject,event);
%     % Clear a parameter from the workspace
%     val = get(gco,'Value');
%     parms = get(gco,'String'); 
%     
%     % Strip lengths off of parms
%     parms = localRemoveLengthFromParms(parms);
%     
%     % Clear the parameter
%     evalin('base',['clear ' parms{val}]);
%     
%     % Update the Parameter List
%     localUpdateParmlist(guidata(hObject));
function localTurnOffZoom(handles)
tlim = localGetAxesLimits(handles);
set(handles.axes,'XLim',tlim);

% Set the ticks on last axes, hide on others
NoAx = str2num(get(handles.NoAxesCombo(2),'String'));
set(handles.axes(NoAx),'XTick',[tlim(1) mean(tlim) tlim(2)]);
set(handles.axes(1:NoAx-1),'XTick',[]);
