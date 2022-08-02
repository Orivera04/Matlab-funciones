function fire(action)
% FIRE v1.0 Draws fire effect
%
%   The algorithm is very simple. It has few steps:
%   1. Create a matrix M x N
%   2. Do a BLUR effect
%   3. Move matrix one row up
%   4. Create random numbers in las row
%   5. Show matrix 
%   6. Goto 2.
%
%   BLUR effect is done for each cell by calculating mean number of cells
%   arounding it. Please feel free to experiment with source code.
%   
%   Tip:
%   You need to have a real "monster" PC to see the fluid animation.
%   That is because MATLAB is interpreting language and also
%   because I'm lazy (rooky) MATLAB programmer :) 
%
%   Author:   Mladen Jovanovic
%   
%   Date:     16.04.2004
%
%   Info:     21 years old
%             Studing Faculty of sports and physical education
%             University in Belgrade (Serbia) 
%
%   Interest: Biomechanics, motor control and learning, physiology
%             kinesiology, conditioning
%             Martial arts especially Filipino martial arts (JKD-Kali)
%
%   E-Mail:   mladen.jovanovic@istramail.com


% Fire characteristics
WIDTH = 50;
HEIGHT = 50;
COLORS = 100;

% How many pixels is going to be cut from screen
BORDER = 3;

if nargin < 1
   action = 'init';
end;

switch( action )
   case 'init'
        % Create figure
        FigureHandle = figure( ...,
                       'Name', 'Fire',...
                       'NumberTitle', 'Off',...
                       'Visible', 'On', ...
                       'DoubleBuffer','on', ...
                       'Color', [0 0 0], ...
                       'BackingStore','off',...
                       'Units', 'normalized',...
                       'MenuBar', 'none' );
                    
        % Frame            
        uicontrol( ...
            'Style','frame', ...
            'Units','normalized', ...
            'Position',[0.84 0.01 0.15 0.98], ...
            'BackgroundColor',[0.50 0.50 0.50]);
   
        % START button
        uicontrol( ...
             'Style','pushbutton', ...
             'Units','normalized', ...
             'Position',[0.85 0.90 0.13, 0.07], ...
             'String','Start', ...
             'Interruptible','on', ...
             'Callback','fire start', ...
             'Tag', 'Start');
   
        % Stop button
        uicontrol( ...
            'Style','pushbutton', ...
            'Units','normalized', ...
            'Position',[0.85 0.80 0.13, 0.07], ...
            'String','Stop', ...
            'Interruptible','on', ...
            'Callback','fire stop', ...
            'Enable', 'off', ...
            'Tag', 'Stop');
         
         % Color POP-UP
         popupStr=str2mat( 'hot', 'hsv', 'pink', 'cool', 'bone', 'prism', 'flag', 'gray', 'rand');
         uicontrol( ...
            'Style','popup', ...
            'Value',1, ...
            'Units','normalized', ...
            'Position',[0.85 0.6 0.13 0.1], ...
            'String',popupStr, ...
            'Tag', 'ColorMap', ...
            'Callback', 'fire color');
   
          uicontrol( ...
            'Style','text', ...
            'Units','normalized', ...
            'Position', [0.85 0.7 0.13 0.05], ...
            'String','Colormap', ...
            'BackgroundColor',[0.50 0.50 0.50]);
 
         
         % Info button
        uicontrol( ...
            'Style','pushbutton', ...
            'Units','normalized', ...
            'Position',[0.85 0.15 0.13, 0.07], ...
            'String','Info', ...
            'Interruptible','on', ...
            'Callback','fire info', ...
            'Enable', 'on', ...
            'Tag', 'Info');
         
         % Close button
        uicontrol( ...
            'Style','pushbutton', ...
            'Units','normalized', ...
            'Position',[0.85 0.05 0.13, 0.07], ...
            'String','Close', ...
            'Interruptible','on', ...
            'Callback','fire close', ...
            'Enable', 'on', ...
            'Tag', 'Close');

         % AXES
         axes( ...
            'Units','normalized', ...
            'Position',[0.01 0.01 0.82 0.98], ...
            'Visible','off', ...
            'NextPlot','add', ...
            'XLim', [0 WIDTH-(2*BORDER)+1], ...
            'YLim', [0 HEIGHT-(2*BORDER)+1], ...
            'YDir', 'reverse' );
         
         image( zeros( HEIGHT-(2*BORDER), WIDTH-(2*BORDER)), ...
            'Tag', 'FIREBUFFER', ...
            'UserData', 1);
         
         % Set Default colormap
         colormap hot;
             
    case 'start'
       StartHandle = findobj( 'Tag', 'Start' );
       StopHandle = findobj( 'Tag', 'Stop' );
       InfoHandle = findobj( 'Tag', 'Info' );
       CloseHandle = findobj( 'Tag', 'Close' );
       FireBufferHandle = findobj( 'Tag', 'FIREBUFFER' );
       FireBuffer = zeros( HEIGHT, WIDTH );
       
       set( StartHandle, 'Enable', 'off' );
       set( StopHandle, 'Enable', 'on' );
       set( InfoHandle, 'Enable', 'off' );
       set( CloseHandle, 'Enable', 'off' );
       set( FireBufferHandle, 'UserData', 1 );

       flag = 1;
       
       % MAIN LOOP
       while flag
          drawnow;
          
          % BLUR effect
          for i = 2:(HEIGHT-1)
            for j = 2:(WIDTH-1)
              	up = FireBuffer( i-1, j );
	            down = FireBuffer( i+1, j );
                left = FireBuffer( i, j-1 );
	            right = FireBuffer( i, j+1 );
                cell = FireBuffer( i, j );
         
   	            cell = ( up+left+right+down+cell )/5;
                FireBuffer( i, j ) = cell - 1;
            end;
	      end;
          
          % Move buffer up
       	  for i=1:(HEIGHT-1)
		      FireBuffer(i,:) = FireBuffer(i+1,:);   
	      end;
          
          % Create random numbers in last row
          random_line = rand(1, WIDTH) .* COLORS;
       	  FireBuffer( end, :) = random_line;
         
          set( FireBufferHandle, 'CData', FireBuffer((BORDER+1):(HEIGHT-BORDER), ...
                                                     (BORDER+1):(WIDTH-BORDER)) );
          flag = get( FireBufferHandle, 'UserData' );   
       end;
       
    case 'stop' 
       StartHandle = findobj( 'Tag', 'Start' );
       StopHandle = findobj( 'Tag', 'Stop' );
       InfoHandle = findobj( 'Tag', 'Info' );
       CloseHandle = findobj( 'Tag', 'Close' );

       FireBufferHandle = findobj( 'Tag', 'FIREBUFFER' );
              
       set( StartHandle, 'Enable', 'on' );
       set( StopHandle, 'Enable', 'off' );
       set( InfoHandle, 'Enable', 'on' );
       set( CloseHandle, 'Enable', 'on' );
         
       set( FireBufferHandle, 'UserData', 0 );
       
    case 'info'
        helpwin(mfilename);
        
    case 'close'
       delete (gcbf);
       
    case 'color'
       popupHandle = findobj( 'Tag', 'ColorMap' );
       
       colorlabels ={'hot','hsv','pink','cool','bone',...
         'prism','flag','gray',...
         'rand'};
   Value = get( popupHandle, 'Value' );
   if Value == 9
      colormap( rand(COLORS,3) );
   else
      colormap(char(colorlabels(Value)));
   end;
       
end;
         
         
         
