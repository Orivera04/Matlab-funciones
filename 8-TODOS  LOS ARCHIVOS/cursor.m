function varargout = cursor(varargin)
% CURSOR updates the cursor location in multiple axes/figures.
%
% CURSOR by itself will update the cursor location in all axes in
% the current figure.
%
% CURSOR(AX) updates the cursor locations in the axes defined by AX,
% where AX is a n-element vector of axes handles.  Note that the axes
% do not have to be in the same figure.
%
% CURSOR(FIG) updates the cursor locations all the axes in the figure FIG.
% By adding a figure all of the axes on the figure will be utilized, each will
% have it's own cursor. NOTE: If you add axes using this method, you can only 
% do one figure at a time. Calling this function using this method on another 
% figure, before calling 'off' will have no effect.
%
% Output: the X and Y position in data units where the mouse was clicked
% Author: Andrew Hastings
% Email: thebpf@hotmail.com
% version 1.111805
% Tested on Matlab 6.1

global ax fig

% --------------------------------------------------------------- %
% Initialize variables
% --------------------------------------------------------------- %

action = 'other';
TOLERANCE = 0.05;   % In normalized units to allow the mouse to be
                    % outside of an axis and still be considered 
                    % on the axis. 

% ------------------------------------------------------------------ %
% Parse the arguments passed in.
% ------------------------------------------------------------------ %

if nargin >=1
    if isstr(varargin{1})
        action = varargin{1};
    elseif strcmp(lower(get(varargin{1},'Type')),'axes')
        if isempty(ax)
            ax = varargin{1};
        else
            ax = cat(1,ax,varargin{1});
        end
        fig = get(ax(1),'Parent');
    elseif strcmp(lower(get(varargin{1},'Type')),'figure')
        fig = varargin{1};        
    end
end

% Make sure that only figures that are using cursor are selected. 
% This statment is used after a cursor('off'). If two figures had been using cursor
% the one on top (currentFigure) would be 'off' and we wouldn't be able to access the 
% cursor on the one underneath unless we first check the ButtonDownFcn.
if isempty(fig) & strcmp(lower(get(gcf,'WindowButtonDownFcn')),'cursor(''down'')')
    fig = gcf;
end

% Check to see if we are still using the cursor.
% If so then set the WindowButton...Fcn's which can get reset for some reason.
% The ButtonDownFcn is the only one that doesn't get reset.
try
    if strcmp(lower(get(fig,'WindowButtonDownFcn')),'cursor(''down'')') & isempty(get(fig,'WindowButtonMotionFcn'))
        set(fig,'WindowButtonMotionFcn','cursor(''move'')', ...
                'WindowButtonUpFcn','cursor(''up'')');			
    end
catch
    fig = [];
    ax = [];
end

% This check is required if the figure using cursor was closed but cursor was never turned off,
% and cursor is envoked on a new figure.
try
    test = get(ax(1));    
catch
    ax=[];
end

% --------------------------------------------------------------- %
% Get list of axes in the figure.
% --------------------------------------------------------------- %
if ~isempty(fig) & isempty(ax)
    ax = findobj(fig,'Type','Axes');
    % The following line(s) removes any axes we don't want to have the crosshairs on.
    if ~isempty(ax)
        ax = ax(~strcmp(get(ax,'Tag'), 'Colorbar'));
    else
        fig = [];
    end
end

% --------------------------------------------------------------- %
% The WindowButton...Fcn controls.
% --------------------------------------------------------------- %
switch lower(action)
    case {'down', 'move', 'up'}

        % See if the user clicked on an axis if so, which axis did the user click on.        
        i = [];
        if ~isempty(ax)
            i = find(ax==gca);
        end
        
        if ~isempty(i)           
            cp = get(fig,'CurrentPoint');
            fig = get(ax(i),'Parent');            
            theUnits = get(ax(i),'Units');					
            set(fig,'Units',theUnits);						% Set the units for the figure and axes the same, should be noramlized.
            axisPosition = get(ax(i),'Position');   		

            % See if the mouse click was on an axes            
            flag = cp(1) > axisPosition(1)-TOLERANCE & cp(1) < (axisPosition(1)+axisPosition(3)+TOLERANCE) & ...
                   cp(2) > axisPosition(2)-TOLERANCE & cp(2) < (axisPosition(2)+axisPosition(4)+TOLERANCE);
           
            if flag
                cpa = get(ax(i),'CurrentPoint');		% Where in the axes was the mouse clicked.
                axlim = get(ax(i),'XLim');  		
                aylim = get(ax(i),'YLim');				

                X = cpa(2,1);							% Get the X front component.
                Y = cpa(2,2);							% Get the Y front component.  
  
                if X < 0					
                    X = 0;									
                elseif X > axlim(2)
                    X = axlim(2);
                end
 
                if Y < 0
                    Y = 0;
                elseif Y > aylim(2)
                    Y = aylim(2);
                end
 
                % Move the cursor to the point clicked on.
                hline = findobj(ax(i), 'Type','line','Tag','Horizontal Cursor');
                set(hline,'YData',[Y Y],'XData',axlim);						
                vline = findobj(ax(i), 'Type','line','Tag','Vertical Cursor');
                set(vline,'XData',[X X],'YData',aylim);		

                if strcmp(action,'up')
                    varargout{1} = [X,Y];               
                end        
            end
        end
        
        
    case 'off'
        % Only turn the cursors off in the current figure.
        if ~isempty(fig)
            if gcf == fig
                hline = findobj(fig, 'Type','line','Tag','Horizontal Cursor');
                vline = findobj(fig, 'Type','line','Tag','Vertical Cursor');
                delete(hline);
                delete(vline);
                set(fig,'WindowButtonDownFcn','',...
                        'WindowButtonMotionFcn','', ...
                        'WindowButtonUpFcn','');		
            end
        end
        fig = [];
        ax = [];

    otherwise % First time through there will not be any valid action.
        for i = 1:length(ax)
            axlim = get(ax(i),'XLim');  				    % X-limits for the current axes
            aylim = get(ax(i),'YLim');					    % Y-limits for the current axes
     
            X = axlim(1)+(axlim(2)-axlim(1))/2; 			% Inital X position in middle of axis.
            Y = aylim(1)+(aylim(2)-aylim(1))/2;	    		% Inital Y position in middle of axis.
    
            % --------------------------------------------------------------- %
            % Draw the inital crosshair.
            % --------------------------------------------------------------- %

            fig = get(ax(i),'Parent');

            % Check to see if the lines already exist.
            hline = findobj(ax(i),'Type','line','Tag','Horizontal Cursor');
            vline = findobj(ax(i),'Type','line','Tag','Vertical Cursor');	    

            % Add the lines if they do not already exist
            if isempty(vline) & isempty(hline)
                axes(ax(i));
                hline = line('XData',get(ax(i),'XLim'),'YData',[Y Y], ...
                             'EraseMode','xor','Tag','Horizontal Cursor');
                vline = line('XData',[X X],'YData',get(ax(i),'YLim'), ...
                             'EraseMode','xor','Tag','Vertical Cursor');
            end

            % Set the WindowButton...Fcn of the figure
            set(fig,'WindowButtonDownFcn','cursor(''down'')',...
                    'WindowButtonMotionFcn','cursor(''move'')', ...
                    'WindowButtonUpFcn','cursor(''up'')');			
            
        end
end


  