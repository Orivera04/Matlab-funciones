function out = linkedzoom(varargin)
% linkedzoom: link zooming on all subplots of current figure.
% This function give users the ability to zoom in a given direction  
%   and will force all the subplots of the figure to have the same axis.
%
% Usage:
%   linkedzoom -> Toggles linkedzoom on current figure using default zoom of both x and y.
%   linkedzoom(fig,'ZoomCommand'), where fig is a figure handle applies ZoomCommand to all axes in fig
%   linkedzoom(h,'ZoomCommand'), where h is a vector of axes handles applies ZoomCommand to specified axes
%       ZoomCommand-> 
%                   off     Turns off linkedzoom
%                   onx     link x axis of all subplots of specified fig, leave y axis unmodified
%                   ony     link y axis of all subplots of specified fig, leave x axis unmodified
%                   onxy    link x and y  axis of all subplots of specified fig
%                   onx2    link x axis of all subplots of specified fig, zoom y axis of gca only
%                   ony2    link y axis of all subplots of specified fig, zoom x axis of gca only
%
%   linkedzoom ZoomCommand applies ZoomCommand to the current figure
%
% A few limitations:
%   Double clicking to restore axis limits doesn't work quite as you
%    might expect.  It sets all axes to the limits of the current axes,
%    not to their original values.
%   If you initiate linkedzoom with a handle input, you must
%    continue to use that handle input for subsequent calls.
%    e.q.  linkedzoom(h,'onx'); linkedzoom off 
%    is not a good idea

%   Internal functions calling us again use the following:
%
%                   down    linkedzoom is zooming in
%                   out     linkedzoom is zooming out
%                   clear   linkedzoom is clearing limits of axes
%                   setlimit linkedzoom is setting the limits of axes based on current axes
%                   getlimit linkedzoom returns current limits for current axes.
%                   
%   linkedzoom(fig,[],'ZoomCommand');  % Called from Figure.
%  
switch nargin
case 0
    fig = gcf;
    hAxes = findobj(fig,'Type','Axes');
    
    if isappdata(fig1,'ZOOMFigureState')
        zoomCommand = 'off';
    else
        zoomCommand = 'onxy';
    end;
    
case 1
    if ischar(varargin{1})
        fig = gcf;
        hAxes = findobj(fig,'Type','Axes');
        
        zoomCommand = varargin{1};
    else
        fig = varargin{1};
        
        %Get handles to all involved figures and axes
        try
            [fig,hAxes] = localcheck_handle_input(fig);        
        catch
            error(lasterr);
        end;
        
        
        if isappdata(fig1,'ZOOMFigureState')
            zoomCommand = 'off';
        else
            zoomCommand = 'onxy';
        end;
    end;
case 2
    fig = varargin{1};
    %Get handles to all involved figures and axes
    try
        [fig,hAxes] = localcheck_handle_input(fig);        
    catch
        error(lasterr);
    end;
    
    zoomCommand = lower(varargin{2});
% case 3
%     fig = varargin{1};
%     %Get handles to all involved figures and axes
%     try
%         [fig,hAxes] = localcheck_handle_input(fig);        
%     catch
%         error(lasterr);
%     end;
%     
%     zoomCommand = lower(varargin{3});
case 4
    hAxes = varargin{3};
    fig = get(hAxes,'Parent');
    [junk,ndx] =unique([fig{:}]);     %Convert to array
    fig = [fig{sort(ndx)}];
    %Get handles to all involved figures and axes

    zoomCommand = lower(varargin{4});
otherwise
    errordlg('Unknown arguments sent to linkedzoom.');
    
end;

if (length(hAxes)==1)
    error('Must have multiple plots to use linked zoom');
    linkedzoom(fig,'off');
    return;
end;


fig1 = fig(1);      %Use this for appdata

switch zoomCommand % special cases of zoomCommand ON so remember them and just use on
case {'onx','ony','onxy','onx2','ony2'}
    setappdata(fig1,'ZOOMMode',zoomCommand);
    zoomCommand = 'on';
end;

%
% set some things we need for zoomCommands
%

if ismember(gcf,fig)
    ax=get(gcf,'currentaxes');
else
    ax = get(fig1,'currentaxes');
end;

if ~ismember(ax,hAxes)
    return
end;



% if isappdata(fig1,'ZOOMAxesHandles');
%     hAxes = getappdata(fig1,'ZOOMAxesHandles');
% else
%     hAxes = [];
% end;
rbbox_mode = 0;

%
% Switch on zoomCommand
%
switch zoomCommand
case 'off'
    % turn zoom off
    state = getappdata(fig1,'ZOOMFigureState');
    if ~isempty(state)
        % since we didn't set the pointer,
        % make sure it does not get reset
        ptr = get(fig1,'pointer');
        % restore figure and non-uicontrol children
        % don't restore uicontrols because they were restored
        % already when zoom was turned on
        uirestore(state,'nouicontrols');
        set(fig1,'pointer',ptr)
        
        % Remove all appdata we set         
        if isappdata(fig1,'ZOOMFigureState')
            rmappdata(fig1,'ZOOMFigureState');
        end
        % get rid of on state appdata if it exists
        % the non-existance of this appdata
        % indicates that zoom is off.
        if isappdata(fig1,'ZoomOnState')
            rmappdata(fig1,'ZoomOnState');
        end
%        if isappdata(fig1,'ZOOMAxesHandles');
            %hAxes = getappdata(fig1,'ZOOMAxesHandles');
            for c= 1:length(hAxes)
                if isappdata(get(hAxes(c),'ZLabel'),'ZOOMAxesData')
                    rmappdata(get(hAxes(c),'ZLabel'),'ZOOMAxesData')
                end;
            end
%            rmappdata(fig1,'ZOOMAxesHandles');
            %       end;
        if isappdata(fig1,'ZOOMMode');
            rmappdata(fig1,'ZOOMMode');
        end;
        
        %Sloppy cleanup, to get any figures without appdata
            set(fig,'windowbuttondownfcn','', ...
        'windowbuttonupfcn','', ...
        'windowbuttonmotionfcn','');

    end
    % done, go home.
    return
    
case 'down'
    % Activate axis that is clicked in
    allAxes = hAxes;
    ZOOM_found = 0;
    
    % this test may be causing failures for 3d axes
    for i=1:length(allAxes)
        ax=allAxes(i);
        ZOOM_Pt1 = get(ax,'CurrentPoint');
        xlim = get(ax,'xlim');
        ylim = get(ax,'ylim');
        if (xlim(1) <= ZOOM_Pt1(1,1) & ZOOM_Pt1(1,1) <= xlim(2) & ...
                ylim(1) <= ZOOM_Pt1(1,2) & ZOOM_Pt1(1,2) <= ylim(2))
            ZOOM_found = 1;
            fig_temp = get(ax,'Parent');
            set(fig_temp,'currentaxes',ax);
            break
        end
    end
    
    if ZOOM_found==0
        return
    end
    
    % Check for selection type
    selection_type = get(gcf,'SelectionType');
    zoomMode = getappdata(fig1,'ZOOMFigureMode');
    if isempty(zoomMode) | strcmp(zoomMode,'in');
        switch selection_type
        case 'normal'
            % Zoom in
            m = 1;
            scale_factor = 2; % the default zooming factor
        case 'open'
            % Zoom all the way out
            linkedzoom(hAxes,'out');
            return;
        otherwise
            % Zoom partially out
            m = -1;
            scale_factor = 2;
        end
    elseif strcmp(zoomMode,'out')
        switch selection_type
        case 'normal'
            % Zoom partially out
            m = -1;
            scale_factor = 2;
        case 'open'
            % Zoom all the way out
            linkedzoom(hAxes,'out');
            return;
        otherwise
            % Zoom in
            m = 1;
            scale_factor = 2; % the default zooming factor
        end
    else % unrecognized zoomMode
        return
    end
    
    ZOOM_Pt1 = localget_currentpoint(ax);
    ZOOM_Pt2 = ZOOM_Pt1;
    center = ZOOM_Pt1;
    
    if (m == 1)
        % Zoom in
        units = char(get(fig,'units'));units = units(1,:);  %Keep first value
        set(fig,'units','pixels')
        
        rbbox([get(gcf,'currentpoint') 0 0],get(gcf,'currentpoint'),gcf);
        
        ZOOM_Pt2 = localget_currentpoint(ax);
        set(fig,'units',units)
        
        % Note the currentpoint is set by having a non-trivial up function.
        if min(abs(ZOOM_Pt1-ZOOM_Pt2)) >= ...
                min(.01*[diff(localget_xlim(ax)) diff(localget_ylim(ax))]),
            % determine axis from rbbox 
            a = [ZOOM_Pt1;ZOOM_Pt2]; a = [min(a);max(a)];
            
            % Undo the effect of localget_currentpoint for log axes
            if strcmp(get(ax,'XScale'),'log'),
                a(1:2) = 10.^a(1:2);
            end
            if strcmp(get(ax,'YScale'),'log'),
                a(3:4) = 10.^a(3:4);
            end
            rbbox_mode = 1;
        end
    end
    % Limits is stored in appdata so no need to store it again,
    % but it is returned anyway.
    limits = linkedzoom(hAxes,'getlimits');
    
case 'on',
    state = getappdata(fig1,'ZOOMFigureState');
    if isempty(state),
        % turn off all other interactive modes
        h=@linkedzoom;
        state = uiclearmode(fig1,'docontext',h,fig,'off');
        
        % restore button down functions for uicontrol children of the figure
        uirestore(state,'uicontrols');
        setappdata(fig1,'ZOOMFigureState',state);
    end
    % We use handles to function so that we can use this mfile as a local function
    %
    h=@linkedzoom;
    set(fig,'windowbuttondownfcn',{h,hAxes,'down'}, ...
        'windowbuttonupfcn','ones;', ...
        'windowbuttonmotionfcn','','buttondownfcn','',...
        'interruptible','on');
    set(ax,'interruptible','on')
    % set an appdata so it will always be possible to 
    % determine whether or not zoom is on and in what
    % type of 'on' stat it is.
    % this appdata will not exist when zoom is off
    setappdata(fig1,'ZoomOnState','on');
%     if isappdata(fig1,'ZOOMAxesHandles');
%         hAxes = getappdata(fig1,'ZOOMAxesHandles');
%     else
%         hAxes = [];
%     end;
%     if isempty(hAxes) 
%         hchildren = get(fig,'Children');
%         for c= 1:length(hchildren)
%             if strcmp('axes',get(hchildren(c),'Type'))
%                 hAxes = [hAxes,hchildren(c)];
%             end;
%         end
%         setappdata(fig1,'ZOOMAxesHandles',hAxes);
%     end;
    linkedzoom(hAxes,'setlimits');
    return
    
case 'out',
    limits = linkedzoom(hAxes,'getlimits');
    center = [sum(localget_xlim(ax))/2 sum(localget_ylim(ax))/2];
    m = -inf; % Zoom totally out
case 'clear',
    for c= 1:length(hAxes)
        if isappdata(get(hAxes(c),'ZLabel'),'ZOOMAxesData')
            rmappdata(get(hAxes(c),'ZLabel'),'ZOOMAxesData')
        end;
    end
    return;    
    
case 'setlimits',
    state = getappdata(fig1,'ZOOMFigureState');
    for c= 1:length(hAxes)
        axes(hAxes(c));
        % Limits is stored in appdata so no need to store it again,
        % but it is returned anyway.
        limits = linkedzoom(hAxes,'getlimits');
    end;
    return;    
    
case 'getlimits', % Get axis limits
    axz = get(ax,'ZLabel');
    limits = getappdata(axz,'ZOOMAxesData');
    % Do simple checking of userdata
    if size(limits,2)==4 & size(limits,1)<=2, 
        if all(limits(1,[1 3])<limits(1,[2 4])), 
            getlimits = 0; out = limits(1,:);
            return   % Quick return
        else
            getlimits = -1; % Don't munge data
        end
    else
        if isempty(limits)
            getlimits = 1;
        else 
            getlimits = -1;
        end
    end
    
    % If I've made it to here, we need to compute appropriate axis
    % limits.
    
    if isempty(getappdata(axz,'ZOOMAxesData')),
        % Use quick method if possible
        xlim = localget_xlim(ax); xmin = xlim(1); xmax = xlim(2); 
        ylim = localget_ylim(ax); ymin = ylim(1); ymax = ylim(2); 
        
    elseif strcmp(get(ax,'xLimMode'),'auto') & ...
            strcmp(get(ax,'yLimMode'),'auto'),
        % Use automatic limits if possible
        xlim = localget_xlim(ax); xmin = xlim(1); xmax = xlim(2); 
        ylim = localget_ylim(ax); ymin = ylim(1); ymax = ylim(2); 
        
    else
        % Use slow method only if someone else is using the userdata
        h = get(ax,'Children');
        xmin = inf; xmax = -inf; ymin = inf; ymax = -inf;
        for i=1:length(h),
            t = get(h(i),'Type');
            if ~strcmp(t,'text'),
                if strcmp(t,'image'), % Determine axis limits for image
                    x = get(h(i),'Xdata'); y = get(h(i),'Ydata');
                    x = [min(min(x)) max(max(x))];
                    y = [min(min(y)) max(max(y))];
                    [ma,na] = size(get(h(i),'Cdata'));
                    if na>1 
                        dx = diff(x)/(na-1);
                    else 
                        dx = 1;
                    end
                    if ma>1
                        dy = diff(y)/(ma-1);
                    else
                        dy = 1;
                    end
                    x = x + [-dx dx]/2; y = y + [-dy dy]/2;
                end
                xmin = min(xmin,min(min(x)));
                xmax = max(xmax,max(max(x)));
                ymin = min(ymin,min(min(y)));
                ymax = max(ymax,max(max(y)));
            end
        end
        
        % Use automatic limits if in use (override previous calculation)
        if strcmp(get(ax,'xLimMode'),'auto'),
            xlim = localget_xlim(ax); xmin = xlim(1); xmax = xlim(2); 
        end
        if strcmp(get(ax,'yLimMode'),'auto'),
            ylim = localget_ylim(ax); ymin = ylim(1); ymax = ylim(2); 
        end
    end
    
    limits = [xmin xmax ymin ymax];
    if getlimits~=-1, % Don't munge existing data.
        % Store limits ZOOMAxesData
        % store it with the ZLabel, so that it's cleared if the 
        % user plots again into this axis.  If that happens, this
        % state is cleared
        axz = get(ax,'ZLabel');
        setappdata(axz,'ZOOMAxesData',limits);
    end
    
    out = limits;
    return
    
otherwise
    errordlg(['Unknown option: ',zoomCommand,'.']);
end


%
% Actual zoom operation
%

if ~rbbox_mode,
    xmin = limits(1); xmax = limits(2); 
    ymin = limits(3); ymax = limits(4);
    
    if m==(-inf),
        dx = xmax-xmin;
        dy = ymax-ymin;
    else
        dx = diff(localget_xlim(ax))*(scale_factor.^(-m-1)); dx = min(dx,xmax-xmin);
        dy = diff(localget_ylim(ax))*(scale_factor.^(-m-1)); dy = min(dy,ymax-ymin);
    end
    
    % Limit zoom.
    center = max(center,[xmin ymin] + [dx dy]);
    center = min(center,[xmax ymax] - [dx dy]);
    a = [max(xmin,center(1)-dx) min(xmax,center(1)+dx) ...
            max(ymin,center(2)-dy) min(ymax,center(2)+dy)];
    
    % Check for log axes and return to linear values.
    if strcmp(get(ax,'XScale'),'log'),
        a(1:2) = 10.^a(1:2);
    end
    if strcmp(get(ax,'YScale'),'log'),
        a(3:4) = 10.^a(3:4);
    end
    
end

% Check for axis equal and update a as necessary
if strcmp(get(ax,'plotboxaspectratiomode'),'manual') & ...
        strcmp(get(ax,'dataaspectratiomode'),'manual')
    ratio = get(ax,'plotboxaspectratio')./get(ax,'dataaspectratio');
    dx = a(2)-a(1);
    dy = a(4)-a(3);
    [kmax,k] = max([dx dy]./ratio(1:2));
    if k==1
        dy = kmax*ratio(2);
        a(3:4) = mean(a(3:4))+[-dy dy]/2;
    else
        dx = kmax*ratio(1);
        a(1:2) = mean(a(1:2))+[-dx dx]/2;
    end
end

% Update circular list of connected axes
%  This is the key to the linked xzoom.
mode = getappdata(fig1,'ZOOMMode');
for c= 1:length(hAxes)
    axz = get(hAxes(c),'ZLabel');
    if ~isappdata(axz,'ZOOMAxesData');
        % If limit is not save yet save it before setting new axes
        fig_temp = get(hAxes(c),'Parent');
        set(fig,'currentaxes',hAxes(c));
        limit = linkedzoom(hAxes,'getlimits');
    end;
    switch mode
    case 'onx'
        set(hAxes(c),'xlim',a(1:2));
        
    case 'ony'
        set(hAxes(c),'ylim',a(3:4));
        
    case 'onxy'
        set(hAxes(c),'xlim',a(1:2));
        set(hAxes(c),'ylim',a(3:4));
    case 'onx2'
        set(hAxes(c),'xlim',a(1:2));
        if (hAxes(c)==ax)
            set(hAxes(c),'ylim',a(3:4));
        end;    
    case 'ony2'
        set(hAxes(c),'ylim',a(3:4));
        if (hAxes(c)==ax)
            set(hAxes(c),'xlim',a(1:2));
        end;
    otherwise
        set(hAxes(c),'xlim',a(1:2));
        set(hAxes(c),'ylim',a(3:4));
    end;
end;        

%
% zoom Helper Functions
%

% --------------------------------------------------------------------
% zoom Helper Functions
function p = localget_currentpoint(ax)
%GET_CURRENTPOINT Return equivalent linear scale current point
p = get(ax,'currentpoint'); p = p(1,1:2);
if strcmp(get(ax,'XScale'),'log'),
    p(1) = log10(p(1));
end
if strcmp(get(ax,'YScale'),'log'),
    p(2) = log10(p(2));
end

% --------------------------------------------------------------------
% zoom Helper Functions
function xlim = localget_xlim(ax)
%GET_XLIM Return equivalent linear scale xlim
xlim = get(ax,'xlim');
if strcmp(get(ax,'XScale'),'log'),
    xlim = log10(xlim);
end

% --------------------------------------------------------------------
% zoom Helper Functions
function ylim = localget_ylim(ax)
%GET_YLIM Return equivalent linear scale ylim
ylim = get(ax,'ylim');
if strcmp(get(ax,'YScale'),'log'),
    ylim = log10(ylim);
end

% --------------------------------------------------------------------
% input checking function
function [fig,hAxes] = localcheck_handle_input(fig)
%See if input was a figure or a vector of axes handles
InputType = get(fig,'Type');
if ~iscell(InputType) InputType = {InputType}; end;

if ~(strcmp(InputType{1},'figure') | strcmp(InputType{1},'axes'))
    errordlg('First Argument must be a valid Figure or Axes handle.');
    return;
end;

%Require all elements to be the same type (figure or axes)
if prod(double(strcmp('figure',InputType)));   %All figures
    hAxes = findobj(fig,'Type','Axes');
elseif prod(double(strcmp('axes',InputType)));     %All axes
    hAxes = fig;
    fig = get(hAxes,'Parent');
    [junk,ndx] =unique([fig{:}]);     %Convert to array
    fig = [fig{sort(ndx)}];
else
    error('Must specify EITHER figures OR axes');
end;
