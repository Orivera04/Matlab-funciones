function varargout = set(dd,varargin)
% SET Set properties and return the updated object

%One input argument - show valid values
if nargin==1
    strct = struct(dd);     %Temporary structure
    
    strct.DragHandles = '[Array of handles to draggable objects]';
    strct.DropHandles = '[Array of handles to drop targets]';
    strct.DropCallbacks = 'String -or- Function Handle to callback function, OR cell array {} of same';
    strct.DropValidDrag = '{Cell array of handle arrays to draggable objects for each target} -or- ''all''';
    strct.Parent = 'Read Only';
    
    if nargout==0
        strct
    else
        varargout{1} = strct;
    end;
    
    
else    %Set the property
    
    property_argin = varargin;
    while length(property_argin) >= 2,
        prop = property_argin{1};
        val = property_argin{2};
        property_argin = property_argin(3:end);
        switch prop     %Switch through the property we are setting
            case 'DragHandles'
                %Confirm that drag handles are valid handles
                if ~all(ishandle(val))
                    error('DragHandles must be an array of handles');
                else
                    dd.DragHandles = val;
                end;
                
                %Enable dragging on these objects
                
                %There are some choices to make here.  If a uicontrol is
                %set inactive, you can drag it with your left mouse button.
                % But, this doesn't allow you to "use" the control.  This
                % is find for pushbuttons, but not good for popupmenus and
                % listboxes for instance.  If the control is enabled, you
                % have to right-click to drag.  
                %Here's my decision: 
                % Disable only pushbuttons and frames.  This will allow you to drag
                % these with left mouse button.  Others will require
                % right-click.
                
                %First, disable uicontrols
                types = get(val,'Type');
                uis = find(strcmp('uicontrol',types));    %uicontrols
                dis = find(strcmp(get(val(uis),'Style'),'pushbutton') | strcmp(get(val(uis),'Style'),'frame'));
                set(val(uis(dis)),'Enable','inactive');
                
                %If object is an axes, set all children to be draggable,
                %too (so you can click on a line to move the axis, for
                %instance.) If this behavior isn't enabled, you get
                %different behavior when you click on an axes background
                %and when you click on a line.  I need to turn this off if
                %I ever enable dragging of lines from one plot to another.
                
                axs = strcmp('axes',types);
                kids = get(val(axs),'Children');
                if iscell(kids) %When multiple axes
                    kids = vertcat(kids{:})';       %A row vector
                end;
                val = [val kids];
                
                %Set ButtonDownFcn to enable dragging
                set(val,'ButtonDownFcn','dddrag');
                
            case 'DropHandles'
                %Confirm that drop handles are valid handles
                if ~all(ishandle(val))
                    error('DropHandles must be an array of handles');
                else
                    dd.DropHandles = val;
                end;
                
                %Record drop locations.  Put in vertex form (useful for
                %inpolygon, for hit testing when we drag).  End at starting point
                figun = get((get(val(1),'Parent')),'Units');

                for ii=1:length(val)
                    %Put everything in figure's units. This way, uicontrols and
                    %axes will work the same
                    un = get(val(ii),'Units');
                    
                    set(val(ii),'Units',figun);
                    pos = get(val(ii),'Position'); %[xo yo width height]
                    set(val(ii),'Units',un);        %Leave things as you found them!
                    
                    xv = [pos(1) pos(1)+pos(3) pos(1)+pos(3) pos(1)        pos(1)];
                    yv = [pos(2)    pos(2)     pos(2)+pos(4) pos(2)+pos(4) pos(2)];
                end;
                
            case 'DropCallbacks'
                %If a single function handle, repeat for all drop
                %targets
                if ~iscell(val)
                    clbks = {};
                    for ii=1:length(get(dd,'DropHandles'))
                        clbks{ii} = val;
                    end;
                else
                    clbks = val;
                end;
                
                for ii=1:length(clbks)
                    if ~isa(clbks{ii},'function_handle')
                        error('DropCallbacks must be specified as function handles');
                    end;
                end;
                
                dd.DropCallbacks = clbks;
                
            case 'DropValidDrag'
                %Option: 'all' sets all draghandles as valid targets for all
                %drop sites
                if ischar(val)
                    if strcmp(lower(val),'all');
                        sources = get(dd,'DragHandles');
                        validsources = {};
                        for ii=1:length(get(dd,'DropHandles'))
                            validsources{ii} = sources;
                        end;
                        dd.DropValidDrag = validsources;
                    else
                        error('DropValidDrag must be handles or ''all''')
                    end;
                    
                else    %User specified handles individually
                    
                    %Confirm that handles are valid handles
                    if ~iscell(val)
                        error('DropValidDrag must be a cell array of handles');
                    end;
                    
                    for ii=1:length(val)
                        if ~all(ishandle(val{ii}))
                            error('DropValidDrag must be a cell array of handles');
                        end;
                        %Confirm that these are all drag handles
                        if ~all(ismember(val{ii},get(dd,'DragHandles')))
                            error('All DropValidDrag handles must be valid Drag Handles');
                        end;
                    end;
                    
                    
                    dd.DropValidDrag = val;
                end;
            case 'Parent'
                error('Parent is read-only');
        end
    end;
    
    % If DropValidDrag was not specified, add all (equivalent to
    % set(dd,'DropValidDrag','all')
    dvd = get(dd,'DropValidDrag');
    if isempty(dvd)
        
        sources = get(dd,'DragHandles');
        validsources = {};
        for ii=1:length(get(dd,'DropHandles'))
            validsources{ii} = sources;
        end;
        dd.DropValidDrag = validsources;
    end;
    
    %Store latest version in figure
    setappdata(get(dd,'Parent'),'dragndrop',dd);
    
    % Return the object.  If not requested, push updated object back to
    % workspace
    if nargout==1
        varargout{1} = dd;
    elseif nargout==0
        assignin('caller',inputname(1),dd)
    end;
end;