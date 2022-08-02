function varargout = eventlabel(varargin);
%eventlabel       Interactive labeling of events on a plot
% Designed to work in a scrolling scope.
%
% This function is provided as an example only.  It has not been
% tested, and therefore, it is not officially supported by The
% MathWorks, Inc.
%
%Input/Output options
% eventlabel            %Turn on, current axis
% eventlabel(state);    %Set state on current axis ('on' or 'off')
% eventlabel('clear')   %Clear all events on current axis
% eventlabel(hAx);      %Turn on specified axis
% eventlabel(state,hAx);    %Set state on specified axis
% eventlabel('clear')   %Clear all events on specified axis
% eventlabel('update',hAx,EventNo,[xnew ynew]);   %Reposition to new coordinates.
% [xnew], or [xnew ynew]
% events = eventlabel;  %Return events structure, current axis
% events = eventlabel(hAx);  %Return events structure, specified axis

% Written by Scott Hirsch
% shirsch@mathworks.com
% Copyright (c) by The MathWorks, Inc. 1985-2003
%


%Parse I/O
msg = nargchk(0,3,nargin);
if nargin==4
    state = varargin{1};
    hAx = varargin{2};
    EventNo = varargin{3};
    coords = varargin{4};
    if ~ishandle(hAx)
        error('Second input argument must be a valid axis handle');
    end;    
    
elseif nargin==2
    state = varargin{1};
    hAx = varargin{2};
    if ~ishandle(hAx)
        error('Second input argument must be a valid axis handle');
    end;
elseif nargin==1
    if ischar(varargin{1})
        state = varargin{1};
        hAx = gca;
    else
        state = 'on';
        hAx = varargin{1};
    end;
else
    state = 'on';
    hAx = gca;
end;

if nargout==1    %Return events structure
    events = getappdata(hAx,'events');
%     rmfield(events,'graphicsdetails');
    varargout{1} = events;
    return
end;

switch state
    case 'on'       % Set the WindowButtonDownFcn
        set(gcf,'WindowButtonDownFcn','eventlabel down')
        set(gcf,'DoubleBuffer','on');       %eliminate flicker
        
        %Create appdata structure storing all events
        graphicsdetails = struct('string',{},'coordinates',{},'labelhandle',{});
        %String - display string
        %coordinates - display coordinates [x,y]
        
        %See if there are any existing events on this axis
        events = getappdata(hAx,'events');
        
        if isempty(events)  %Initialize if it doesn't exist
            events = struct('name',{},'time',{},'graphicsdetails',graphicsdetails);
        end;
        
        setappdata(hAx,'events',events);
        
    case 'down'     % Execute the WindowButtonDownFcn
        htype = get(gco,'Type');
        tag = get(gco,'Tag');
        
        if strcmp(htype,'line') | strcmp(htype,'axes')     %Line or axes - Add text object
            %User-selected point
            cp = get(hAx,'CurrentPoint');
            x = cp(1,1);       %first xy values
            y = cp(1,2);       %first xy values
            
            
            %Prompt user for event name.  Add event label to plot
            %name = inputdlg('Event Name: ');
%             %If user cancelled, break out
%             if isempty(name)
%                 return
%             end;
%             
%             name = name{1};     %Break out of cell.
%             th = text(x,y,name);
            th = text(x,y,' ','Editing','on');
            waitfor(th,'String');        %Wait for string to be updated
            name = get(th,'String');
            set(th,'Editing','off')

            %For R13 or higher (MATLAB 6.5), use a background color on the text string
            v=ver('MATLAB');
            v=str2num(v.Version(1:3));
            if v>=6.5
                set(th,'BackgroundColor','y');
            end;
            
            %Add a context menu to the label
            % 1 - Edit
            % 2 - Delete
            mh = uicontextmenu('Tag','TipMenu');
            
            % Define callbacks for context menu items
            %         cb1 = ['name = inputdlg(''Event Name: '');set(gco,''String'',name')];
            cb1 = @localEditCallback;
            cb2 = ['ud = get(gco,''UserData'');delete([gco ud(2)]);'];
            
            % Define the context menu items
            item1 = uimenu(mh, 'Label', 'Edit', 'Callback', cb1);
            item2 = uimenu(mh, 'Label', 'Delete', 'Callback', cb2);
            
            %Associate the context menu with the label
            set(th,'UIContextMenu',mh);
            
            %Find nearest actual time value
            lh = findobj(hAx,'Type','line');        %Any/all lines.  Assume common time basis
            if ~isempty(lh)
                lh = lh(1);     %Keep first one we find
                xd = get(lh,'XData');
                time = local_nearest(x,xd);
            else        %Couldn't find any lines.  Just use the value where the user clicked.
                time= x;
            end;    
            
            %Update event structure
            events = getappdata(hAx,'events');
            EventNo = length(events)+1;
            events(EventNo).name= name;
            events(EventNo).time= time;
            events(EventNo).graphicsdetails.string = name;          %This leaves the option of allowing different display string
            events(EventNo).graphicsdetails.coordinates = [x y];    %Display coordinates
            events(EventNo).graphicsdetails.labelhandle = th;    %Display coordinates
            setappdata(hAx,'events',events);        %Update appdata
            setappdata(th,'EventNo',EventNo);       %Store event number in the text
            
        elseif strcmp(htype,'text')
            set(gco,'EraseMode','xor')
            set(gcf,'WindowButtonMotionFcn','eventlabel move', ...
                'WindowButtonUpFcn','eventlabel up');
        end
        
    case 'move'      % Execute the WindowButtonMotionFcn
        if ~isempty(gco)
            th = gco;
            
            cp = get(hAx,'CurrentPoint');
            pt = cp(1,[1 2]);
            
            x = cp(1,1);       %first xy values
            y = cp(1,2);       %first xy values
            
            set(th,'Position', [x y 0])
            
            %Update coordinates in event structure
            EventNo = getappdata(th,'EventNo');
            events = getappdata(hAx,'events');
            events(EventNo).graphicsdetails.coordinates = [x y];
            setappdata(hAx,'events',events);        %Update appdata
            drawnow
        end;
    case 'up'  % Execute the WindowButtonUpFcn
        htype = get(gco,'Type');
        if strcmp(htype,'text')
            set(gco,'EraseMode','Normal')
            set(gcf,'WindowButtonMotionFcn','')
        end;
        
    case 'update'             %Update the cursor value
        %Reposition the event label
        %Find the event
        events = getappdata(hAx,'events');
        Nevents = length(events);
        
        %Do nothing if invalid event
        if (EventNo<1) | (EventNo>Nevents)
            return
        end;
        
        event = events(EventNo);      
        th = event.graphicsdetails.labelhandle; %Handle to label
        if length(coords)==1    %Specified x only.  Use current y value
            curr_pos = event.graphicsdetails.coordinates;
            coords(2) = curr_pos(2);
        end;
        
        set(th,'Position',[coords 0]);
        
        %Update event structure
        events(EventNo).graphicsdetails.coordinates = coords;
        setappdata(hAx,'events',events);
        
    case 'clear'    %Clear events, but leave eventlabel on
        % Delete all displayed events
        events = getappdata(hAx,'events');
        Nevents = length(events);
        for EventNo = 1:Nevents
            delete(events(EventNo).graphicsdetails.labelhandle);
        end;
        
        % Clear the event structure
        graphicsdetails = struct('string',{},'coordinates',{},'labelhandle',{});
        events = struct('name',{},'time',{},'graphicsdetails',graphicsdetails);
        setappdata(hAx,'events',events);
        
    case 'off'   % Unset the WindowButton...Fcns
        set(gcf,'WindowButtonDownFcn','','WindowButtonUpFcn','')
end


function localEditCallback(obj,event);
name = inputdlg('Event Name: ');
set(obj,'String',name)

events = getappdata(get(obj,'Parent'),'events');
events.name = name;
events.graphicsdetails.string = name;
setappdata(get(obj,'Parent'),'events',events);


function xv=local_nearest(x,xl)
%Inputs:
% x   Selected x value
% xl  Line Data (x)

%Find nearest value of xl to x
%Special Case: Line has a single non-singleton value
if sum(isfinite(xl))==1
    fin = find(isfinite(xl));
    xv = xl(fin);
else
    %Normalize axes
    xlmin = min(xl);
    xlmax = max(xl);
    
    xln = (xl - xlmin)./(xlmax - xlmin);
    xn = (x - xlmin)./(xlmax - xlmin);
    
    %Find nearest point
    a = xln - xn;       %Distance between x and the line
    
    [junk,ind] = min(abs(a));
    
    %Nearest value on the line
    xv = xl(ind);
end;
