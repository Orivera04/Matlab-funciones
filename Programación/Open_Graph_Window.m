function h=Open_Graph_Window(width, height, name, x_origin, y_origin)
% 
% h=Open_Graph_Window(width, height, name, x_origin, y_origin)
%
% Opens a grphics window, must be called before any other grahics command
%
% Inputs
%        width      - The width of the window in pixels
%        height     - The height of the window in pixels
%        name       - A string for the name of the window
%        x_origin   - The x value for the location on the screen for the window
%        y_origin   - The y value for the location on the screen for the window
% Output
%        h     - Is a handle to the graphics window
%
% Date - 8 Jan 2003
% Author - Lt Col Tom Schorsch
% Modified by Maj Thomas Rathbun


% if the height and width are not supplied then use half the screen size
if nargin == 0 
    scnsize = get(0,'ScreenSize');
    width = scnsize(3)/2;
    height = scnsize(4)/2;
end

% if a name is not supplied use 'MATLAB Graph'
if nargin < 3
    name = 'MATLAB Graph';
end

% if a position is not supplied then 
% center the window in the top half of the screen
if nargin < 5
    scnsize = get(0,'ScreenSize');
    x_origin = (scnsize(3) - width)/2;
    y_origin = (scnsize(4) - height)/2;
end

% create a window 
h=figure;
set(h, 'Position', [x_origin y_origin width height],...
   'Name',name,...
   'NumberTitle','off',...      % turn off the title
   'MenuBar','none',...         % turn off the menu bar
   'Units','pixels',...         % use pixels as the units
   'Resize','off',...           % don't allow the user to resize
   'Color','white',...          % make the background white
   'DoubleBuffer','on');        % for faster flash free rendering

axis([0,width,0,height]);       % set the axes to be the size of the window
set(gca,'Position',[0 0 1 1]);  % use the entire window (set the axes at the window border)
hold on;                        % don't update the axes (resize the window) based on the data
axis off;                       % don't display the axes

% create flags and set to 0
setappdata(gcf,'MouseClicked',0);
setappdata(gcf,'KeyClicked',0);

% set callback for mouse and key operations
set(gcf,'WindowButtonMotionFcn','m=1;');
set(gcf,'WindowButtonDownFcn','setappdata(gcf,''MouseClicked'',1)');
set(gcf,'KeyPressFcn','setappdata(gcf,''KeyClicked'',1)');
set(gcf,'BusyAction','queue');

% create default values
setappdata(gcf,'Color','black');
setappdata(gcf,'Style','-');
setappdata(gcf,'Filled',false);
setappdata(gcf,'Thickness',0.5);
setappdata(gcf,'Rounded',[0,0]);
setappdata(gcf,'Rotation',0);
setappdata(gcf,'HorizontalAlignment','left');
setappdata(gcf,'FontName','Helvetica');
setappdata(gcf,'FontSize',10);
setappdata(gcf,'FontAngle','normal');
setappdata(gcf,'FontWeight','normal');
setappdata(gcf,'VerticalAlignment','middle');

% change default for the next few draw text calls
Set_Default_Value('HorizontalAlignment','center');

% set the initial font size
fs = 48;

% draw the splash screen and hide the text
th(1) = Draw_Text(round(width/2), round(height/2)+30, 'Welcome to MatlabGraph', 'Color',[0,0,1], 'FontSize',fs);
th(2) = Draw_Text(round(width/2), round(height/2)-30, 'Version 1.2', 'Color',[0,0,1], 'FontSize',fs);
Hide_Object(th);

% loop to make sure the text fits on the splash screen
while true
    
    % get the property that tells us the size ofthe bounding box of the
    % text
    p = get(th(1),'Extent');
    
    % if greater than 0 then the text fits
    if p(1) >0
        break
    else
        % make the font size smaller to make it fit and redrawn the text
        fs = fs - 2;
        Delete_Object(th)
        th(1) = Draw_Text(round(width/2), round(height/2)+20, 'Welcome to MatlabGraph', 'Color',[0,0,1], 'FontSize',fs);
        th(2) = Draw_Text(round(width/2), round(height/2)-20, 'Version 1.2', 'Color',[0,0,1], 'FontSize',fs);
        Hide_Object(th);
    end
end

% now that it fits show the text
Show_Object(th);


% make the text fade out by changingthe color
for i = 0:.05:1
        Change_Object_Color(th,[i,i,1])
    pause(0.1)
end
Delete_Object(th)

% resetthe default prop value
setappdata(gcf,'HorizontalAlignment','left');
