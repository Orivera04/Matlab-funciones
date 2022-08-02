function varargout = animator(x, y, varargin)

%ANIMATOR  Data animation viewer
%   This GUI tool allows you to animate your data with controls for
%   playback speed and looping.
%
%   ANIMATOR(X, Y) animates the data. The data has to be in one of the
%   following formats. The general form is a 3-D array. 1st dimension is
%   the number of elements in a signal (m). 2nd dimension is the number of
%   lines (n). 3rd dimension is the number of frames (p).
%     1. X can be either an m by 1 (2D) array or an m by n by p (3D) array.
%         If 2D, all frames will use the same X vector
%
%     2. X - m by 1
%        Y - m by n by p
%          (This is for animating n lines, with a single X vector for ALL of
%          p frames)
%
%     3. X - m by 1 by p  OR  m by n by p
%        Y - m by n by p
%          (This is for animating n lines, with a fixed X vector for EACH
%          of the p frames OR X-Y pairs per frame)
%
%     4. X - [] (empty)
%        Y - m by n by p
%          (Y will be animated against it's index 1:m)
%
%   ANIMATOR(X, Y, PARAM1, VALUE1, ...) accepts additional arguments:
%     'axis'     : {'auto'}, 'equal
%     'xlim'     : 'auto', [XMIN, XMAX]. Default uses the full range
%     'ylim'     : 'auto', [YMIN, YMAX]. Default uses the full range
%     'title'    : <title text>
%     'xlabel'   : <xlabel text>
%     'ylabel'   : <ylabel text>
%     'smooth'   : {'off'}, 'on'. Anti-aliasing
%     'frame'    : {1}. Starting frame number
%     'speed'    : {9}. Integer between -10 and 10. 10 is fastest, -10 is
%                  fastest in the reverse direction.
%     'framerate': {1}, 2, 3, 5, 10. Animate every # frames.
%
%   [hLine, hAxes] = ANIMATOR(...) returns the handles for the lines and
%   the axes. This allows for customizing of the objects.
%
% GUI Features:
%   The controls allows you to speed up and slow down (or reverse) the
%   playback. You can pause at any time. You can also drag the time line
%   bar to go to arbitrary frames. Also, use the arrow keys to move between
%   frames (left or right) or change the speed (up or down). Spacebar
%   pauses/starts the animation. In addition to the animation speed, the
%   animation frame interval rate can be set from the menu.
%
%   The animation can be exported to an AVI or an Animated GIF (from the
%   menu). The Animated GIF option requires the Image Processing Toolbox,
%   for converting RGB to Indexed data.
%
%  Example 1:
%     x = (0:.01:10)';
%     y = nan(length(x), 2, 400);
%     for idx = 1:400;
%       y(:, 1, idx) = sin(2*x) + cos(0.25*sqrt(idx)*x);
%       y(:, 2, idx) = -cos(0.7*x) + sin(0.4*sqrt(idx)*x);
%     end
%     animator(x, y);
%
%  Example 2:
%     load animatorSampleData;
%
%     % Vibrating string
%     [hL] = animator(X1,Y1,'ylim',[-.7 .7],'title','Vibrating String','smooth','on');
%     set(hL, 'marker', 'o');
%
%     % Two double-pendulum
%     [hL, hAx] = animator(X2,Y2,'axis','equal','title','Double Double-Pendulum');
%     set(hL, 'LineWidth', 3, 'Marker', '.', 'MarkerSize', 20);
%     set(hAx, 'XGrid', 'on', 'YGrid', 'on');

% Versions:
%   v1.0 - Original version (Aug, 2007)
%   v1.1 - Added option for specifying initial frame and animation speed
%   v2.0 - Added exporting option (AVI or Animated GIF) (Nov, 2007)
%   v2.1 - Added settings dialog for AVI and Animated GIF (Nov, 2007)
%   v2.3 - Refactor functions (Nov, 2007)
%
%   Jiro Doke
%   Copyright 2007 The MathWorks, Inc.

% Error checking
[sigType, numFrames] = errorcheck();

% Check for additional input arguments
if nargin < 3
  args = {};
else
  if mod(nargin-2,2)
    error('Additional arguments must be Param/Value pairs');
  end
  args = varargin;
end
[aspectRatio, xlimit, ylimit, titleText, xlabelText, ylabelText, ...
  isSmooth, frm, RRateID, frameRate] = processArguments(args);

% Define other constants
RRates      = [.01, .02, .05, .075, .1, .2, .5, .75, 1, 2];
RRates      = [-RRates,0,RRates(end:-1:1)]; % pre-defined refresh rates
ptrTypes    = {'hand', 'lrdrag', 'arrow'};  % possible cursor pointers
ptrID       = 3;                            % default pointer
isLoop      = true;                         % repeat on
isPlaying   = true;                         % start playing
isSaving    = false;                        % will be true when exporting
direction   = sign(RRates(RRateID));        % forward(+) or reverse(-)
curRateID   = RRateID;                      % for keeping track of current rate

% Define colormap for the figure
% Use this to create 3D looking time line bars
cm = [
  .3, .3, .3;
  .9, .9, .9;
  .2, .6, .2;
  .8,  1, .8;
  .2, .2, .6;
  .8, .8,  1];

cc1a = [1 2 2 1]; % patch color for PAUSED
cc1b = [3 4 4 3]; % patch color for PLAYING

% Create main GUI
hs = createGUI();

% Create timer object for animation
tm = timer(...
  'ExecutionMode'       , 'fixedrate', ...
  'ObjectVisibility'    , 'off', ...
  'Tag'                 , 'animationTimer', ...
  'StartFcn'            , @mystartFcn, ...
  'StopFcn'             , @mystopFcn, ...
  'TimerFcn'            , @timerUpdateFcn);
if RRateID == 11
  set(tm, 'Period', 0.01           );
else
  set(tm, 'Period', RRates(RRateID));
end

% Start animation timer
start(tm);

% Handle outputs
out = {hs.Lines, hs.MainAxes};
for iVarOut = 1:nargout
  varargout{iVarOut} = out{iVarOut};    %#ok
end

%--------------------------------------------------------------------------
% Function for creating the GUI
  function handles = createGUI()

    % Create figure
    hFig = figure(...
      'Name'                            , 'ANIMATOR', ...
      'Numbertitle'                     , 'off', ...
      'Units'                           , 'pixels', ...
      'DockControls'                    , 'on', ...
      'Toolbar'                         , 'none', ...
      'Menubar'                         , 'none', ...
      'Color'                           , [.8 .8 .8], ...
      'Colormap'                        , cm, ...
      'DoubleBuffer'                    , 'on', ...
      'ResizeFcn'                       , @figResizeFcn, ...
      'KeyPressFcn'                     , @keypressFcn, ...
      'DeleteFcn'                       , @figDeleteFcn, ...
      'Visible'                         , 'off', ...
      'HandleVisibility'                , 'callback', ...
      'WindowButtonMotionFcn'           , @motionFcn, ...
      'Tag'                             , 'MainFigure', ...
      'defaultUIControlBackgroundColor' , [.8 .8 .8], ...
      'defaultAxesUnits'                , 'pixels', ...
      'defaultPatchEdgeColor'           , 'none', ...
      'defaultUIPanelUnits'             , 'pixels');

    % Create menu
    allFrameRates  = [1 2 3 5 10];
    frameChecked   = {'off'; 'off'; 'off'; 'off'; 'off'};
    frameChecked{allFrameRates == frameRate} = 'on';
    hMenu1         = uimenu('Parent',hFig,  'Label','Extra'           );
    hMenu2         = uimenu('Parent',hMenu1,'Label','Animate every...');
    hFrameMenu2(1) = uimenu('Parent',hMenu2,'Label','1 frame'         );
    hFrameMenu2(2) = uimenu('Parent',hMenu2,'Label','2 frames'        );
    hFrameMenu2(3) = uimenu('Parent',hMenu2,'Label','3 frames'        );
    hFrameMenu2(4) = uimenu('Parent',hMenu2,'Label','5 frames'        );
    hFrameMenu2(5) = uimenu('Parent',hMenu2,'Label','10 frames'       );
    hMenu3         = uimenu('Parent',hMenu1,'Label','Export to...'    );
    hFrameMenu3(1) = uimenu('Parent',hMenu3,'Label','AVI'             );
    hFrameMenu3(2) = uimenu('Parent',hMenu3,'Label','Animated GIF'    );
    set(hFrameMenu2, 'Callback' , @changeStepRate );
    set(hFrameMenu2, 'Tag'      , 'FrameRateMenu' );
    set(hFrameMenu2, {'Checked'}, frameChecked    );
    set(hFrameMenu3, 'Callback' , @exportAnimation);
    uimenu('Parent', hMenu1, 'Label', 'Eidt title/labels...', 'Callback', @labelCallback                   );
    uimenu('Parent', hMenu1, 'Label', 'Help...'             , 'Callback', @helpFcn      , 'Separator', 'on');
    uimenu('Parent', hMenu1, 'Label', 'About...'            , 'Callback', @aboutFcn                        );
    
    % Control panel
    hPanel = uipanel(...
      'Parent'          , hFig              , ...
      'BackgroundColor' , [.8 .8 .8]        , ...
      'Tag'             , 'ControlPanelAxes', ...
      'BorderType'      , 'etchedin'        );

    % Time line bar
    hAx = axes(...
      'Parent'          , hPanel        , ...
      'Visible'         , 'off'         , ...
      'Tag'             , 'TimelineAxes', ...
      'XLim'            , [0 1]         , ...
      'YLim'            , [-1 1]        );
    patch([0, 0, 1, 1], [-.5, .5, .5, -.5], [.9 .9 .9], ...
      'Tag'             , 'timeLine', ...
      'ButtonDownFcn'   , @initiateDragFcn, ...
      'Parent'          , hAx);
    patch([0, 0, 0, 0], [-.5, .5, .5, -.5], cc1b, ...
      'HitTest'         , 'off', ...
      'CDataMapping'    , 'direct', ...
      'FaceColor'       , 'interp', ...
      'Tag'             , 'TimelinePatch', ...
      'Parent'          , hAx);

    % Message text boxes
    uicontrol(...
      'Parent'              , hPanel, ...
      'style'               , 'text', ...
      'Tag'                 , 'FrameText', ...
      'HorizontalAlignment' , 'left', ...
      'FontWeight'          , 'Bold');
    uicontrol(...
      'Parent'              , hPanel, ...
      'style'               , 'text', ...
      'Tag'                 , 'StatusText', ...
      'HorizontalAlignment'	, 'right');

    % Playback controls
    hAx2 = axes(...
      'Parent'              , hPanel, ...
      'Visible'             , 'off', ...
      'XLim'                , [ 0 1], ...
      'YLim'                , [-1 1], ...
      'Tag'                 , 'PlaybackAxes');
    patch([0, 0, 1, 1], [-.5, .5, .5, -.5], [5 6 6 5], ...
      'CDataMapping'        , 'direct', ...
      'FaceColor'           , 'interp', ...
      'Parent'              , hAx2);
    line(...
      [  0  0 NaN .25 .25 NaN   .5  .5 NaN .75 .75 NaN .99 .99], ...
      [-.3 .3 NaN -.3  .3 NaN -.75 .75 NaN -.3  .3 NaN -.3  .3], ...
      'Parent', hAx2);
    line([(RRateID-1)/20, (RRateID-1)/20], [-.9, .9], ...
      'LineWidth'           , 4, ...
      'Color'               , [.3 .3 .3], ...
      'Tag'                 , 'speedBar', ...
      'ButtonDownFcn'       , @initiateDragFcn,...
      'Parent'              , hAx2);

    % Load icons for controls
    icons = load(fullfile(fileparts(mfilename), 'animatorIcons.mat'));

    % Create playback control buttons from the icons
    hBtn(1) = axes(...
      'Parent'              , hPanel    , ...
      'Tag'                 , 'slowerAxes');
    hBtn(2) = axes(...
      'Parent'              , hPanel    , ...
      'Tag'                 , 'fasterAxes');
    hBtn(3) = axes(...
      'Parent'              , hPanel    , ...
      'Tag'                 , 'pauseAxes' );
    hBtn(4) = axes(...
      'Parent'              , hPanel    , ...
      'Tag'                 , 'repeatAxes');
    image(icons.rewindCData, ...
      'Parent'              , hBtn(1), ...
      'AlphaData'           , icons.rewindAlpha, ...
      'Tag'                 , 'slowerImage', ...
      'ButtonDownFcn'       , @speedBtnFcn);
    image(icons.fastforwardCData, ...
      'Parent'              , hBtn(2), ...
      'AlphaData'           , icons.fastforwardAlpha, ...
      'Tag'                 , 'fasterImage', ...
      'ButtonDownFcn'       , @speedBtnFcn);
    image(icons.pauseCData, ...
      'Parent'              , hBtn(3), ...
      'AlphaData'           , icons.pauseAlpha, ...
      'Tag'                 , 'pauseImage', ...
      'ButtonDownFcn'       , @speedBtnFcn);
    image(icons.repeatCData, ...
      'Parent'              , hBtn(4), ...
      'AlphaData'           , icons.repeatAlpha, ...
      'Tag'                 , 'repeatImage', ...
      'ButtonDownFcn'       , @speedBtnFcn);
    axis(hBtn, 'off', 'image');
    set(hBtn, {'Tag'}, {'slowerAxes'; 'fasterAxes'; 'pauseAxes'; 'repeatAxes'});

    % Create main axes
    hMainAx = axes('Parent', hFig);

    % Create plot
    switch sigType
      case 1 % x: m by 1, y: m by 1 by p
        hL = plot(hMainAx, x, y(:, :, frm), 'Tag', 'Lines');
        xlim(hMainAx, [min(x), max(x)]);
        ylim(hMainAx, [min(y(:)), max(y(:))]);
      case 2 % x: m by 1, y: m by n by p
        hL = plot(hMainAx, x, cell2mat(y(:,:,frm)), 'Tag', 'Lines');
        xlim(hMainAx, [min(x(:)), max(x(:))]);
        ylim(hMainAx, [min(min(cell2mat(squeeze(y)))), max(max(cell2mat(squeeze(y))))]);
      case 3 % x: m by n by p, y: m by n by p
        hL = plot(hMainAx, cell2mat(x(:,:,frm)), cell2mat(y(:,:,frm)), 'Tag', 'Lines');
        xlim(hMainAx, [min(min(cell2mat(squeeze(x)))), max(max(cell2mat(squeeze(x))))]);
        ylim(hMainAx, [min(min(cell2mat(squeeze(y)))), max(max(cell2mat(squeeze(y))))]);
    end

    % Process additional settings (user-specified)
    if strcmp(aspectRatio, 'equal')             % Aspect ratio
      set(hMainAx, 'DataAspectRatio', [1 1 1]);
    elseif strcmp(aspectRatio, 'auto')
      set(hMainAx, 'DataAspectRatioMode', 'auto');
    end
    if ~isempty(xlimit)                         % X-limits
      if strcmpi(xlimit, 'auto')
        set(hMainAx, 'XLimMode', 'auto');
      else
        set(hMainAx, 'XLim', xlimit);
      end
    end
    if ~isempty(ylimit)                         % Y-limits
      if strcmpi(ylimit, 'auto')
        set(hMainAx, 'YLimMode', 'auto');
      else
        set(hMainAx, 'YLim', ylimit);
      end
    end
    if ~isempty(titleText)                      % Axes title
      title(hMainAx, titleText);
    end
    if ~isempty(xlabelText)                     % Axes x-label
      xlabel(hMainAx, xlabelText);
    end
    if ~isempty(ylabelText)                     % Axes y-label
      ylabel(hMainAx, ylabelText);
    end

    set(hMainAx, 'XColor', [.5 .5 .5], 'YColor', [.5 .5 .5]);
    if strcmp(isSmooth, 'on')
      try
        set(hL, 'LineSmoothing', isSmooth);
      catch
        disp('Anti-aliasing not supported.');
      end
    end

    set(hMainAx, 'Tag', 'MainAxes')
    
    % Make axes invisible from outside
    set(findobj(hFig, 'type', 'axes'), 'HandleVisibility', 'callback');
    
    handles = guihandles(hFig);
    handles.icons = icons;

    set(hFig, 'Visible' , 'on');
    
  end %createGUI

%--------------------------------------------------------------------------
% Called when "Edit title/labels..." menu is selected
  function labelCallback(varargin)    %#ok
    answer = inputdlg({'Title:', 'X-Label:', 'Y-Label:'}, ...
      'Enter labels', 1, {get(get(hs.MainAxes, 'Title'), 'String'), ...
      get(get(hs.MainAxes, 'XLabel'), 'String'), ...
      get(get(hs.MainAxes, 'YLabel'), 'String')});

    if ~isempty(answer)
      title(hs.MainAxes , answer{1});
      xlabel(hs.MainAxes, answer{2});
      ylabel(hs.MainAxes, answer{3});
    end

  end %labelCallback

%--------------------------------------------------------------------------
% Called when "Help..." menu is selected
  function helpFcn(varargin)    %#ok

    helpdlg({'Use the lower right controls to change the refresh rate.', ...
      'Individual frames can be viewed interactively by', ...
      'clicking and dragging on the time line bar.', '', ...
      'The following key controls are available:', ...
      '  Right/Left arrows: step through frames one by one', ...
      '  Up/Down arrows: increase/decrease refresh rate', ...
      '  Spacebar: toggle between run/pause'}, 'Help for Animator');

  end %helpFcn

%--------------------------------------------------------------------------
% Called when "About..." menu is selected
  function aboutFcn(varargin)    %#ok

    helpdlg({'Animator is a tool for visualizing animation data stored in array formats.','','Author:', ...
      '  Jiro Doke (jiro.doke@mathworks.com)', ...
      '  Copyright 2007 The MathWorks, Inc.'}, 'About Animator v1.0');

  end %aboutFcn

%--------------------------------------------------------------------------
% Called when changing the number of animation frame interval
  function changeStepRate(varargin)

    frameRate = str2double(strtok(get(varargin{1}, 'Label')));
    set(hs.FrameRateMenu  , 'Checked', 'off');
    set(varargin{1}       , 'Checked', 'on' );

  end %changeStepRate

%--------------------------------------------------------------------------
% Called when exporting animation to AVI or Animated GIF
  function exportAnimation(varargin)

    % If the animation is playing, pause it.
    if isPlaying
      curRateID = RRateID;
      pauseAnimation();
    end

    switch get(varargin{1}, 'Label')
      case 'AVI'
        isAVI = true;
      case 'Animated GIF'
        isAVI = false;
    end

    if isAVI
      
      % Turn off frame padding warning
      warnState1 = warning('off', 'MATLAB:aviaddframe:frameheightpadded');
      warnState2 = warning('off', 'MATLAB:aviaddframe:framewidthpadded' );
      
      % Get default FPS from the current refresh rate of animation
      opt.fps       = abs(1/(RRates(curRateID)));
      opt.frameRate = frameRate;
      opt.quality   = 75;
      opt.keyFrames = 2.1429;
      settings      = promptSettings('AVI', opt);

      if isempty(settings)  % Cancelled
        return
      end

      % Create AVI file
      mov = avifile(settings.filename);

      try
        mov.Fps            = settings.fps        ;
        mov.Compression    = settings.compression;
        mov.Quality        = settings.quality    ;
        mov.KeyFramePerSec = settings.keyFrames  ;
      catch
        err = lasterror;
        errordlg(err.message, err.identifier);
        mov = close(mov); %#ok
        delete(fname);
        return;
      end

      % Change the title of the figure window
      set(hs.MainFigure, 'Name', 'ANIMATOR - Creating AVI file (press ''q'' to cancel)');

    else
      % Get default delay time from the current refresh rate
      opt.frameDelay = abs(RRates(curRateID));
      opt.frameRate  = frameRate;
      settings       = promptSettings('AnimatedGIF', opt);

      if isempty(settings)  % Cancelled
        return
      end

      % Change the title of the figure window
      set(hs.MainFigure, 'Name', 'ANIMATOR - Creating Animated GIF file (press ''q'' to cancel)');

    end

    % Turn on Saving mode
    isSaving = true;

    % Get the current figure position - for GETFRAME (see below)
    set(hs.MainFigure, 'Units', 'pixels');
    figPos = get(hs.MainFigure, 'Position');

    % Start from the first frame
    frm = 1;
    updateLines();
    f = getframe(hs.MainFigure, [5, 55, figPos(3)-10, figPos(4)-55]);
    if isAVI
      mov = addframe(mov, f);
    else
      try
        [indexCData, cMap] = rgb2ind(f.cdata, double(intmax(class(f.cdata)))+1);
      catch
        errordlg('Requires Image Processing Toolbox...');
        return;
      end
      try
        imwrite(indexCData, cMap, settings.filename, ...
          'WriteMode'     , 'overwrite'             , ...
          'LoopCount'     , Inf                     , ...
          'DisposalMethod', settings.disposalMethod , ...
          'DelayTime'     , settings.frameDelay     );
      catch
        errordlg('Writing to GIF files is not supported in this release of MATLAB');
        return;
      end
    end

    % Loop through all frames until finished
    while true
      frm = frm + settings.frameRate;
      if frm > numFrames  % processed all frames
        frm = numFrames;
        break;
      end
      if ~isSaving        % 'q' was pressed by the user
        break;
      end
      updateLines();
      f = getframe(hs.MainFigure, [5, 55, figPos(3)-10, figPos(4)-55]);
      if isAVI
        mov = addframe(mov, f);
      else
        [indexCData, cMap] = rgb2ind(f.cdata, double(intmax(class(f.cdata)))+1);
        imwrite(indexCData, cMap, settings.filename, ...
          'WriteMode'     , 'append'                , ...
          'DisposalMethod', settings.disposalMethod , ...
          'DelayTime'     , settings.frameDelay     );
      end
    end

    if isAVI
      % Save AVI file
      mov = close(mov); %#ok
      
      % Bring back warning state
      warning(warnState1);
      warning(warnState2);
    end

    if ~isSaving
      msgbox('Cancelled');
      delete(fname);
    else
      msgbox('Done');
    end

    isSaving = false;
    set(hs.MainFigure, 'Name', 'ANIMATOR - Paused');
    
    %----------------------------------------------------------------------
    % Helper function for "exportAnimation" - brings up a dialog box for
    % setting export properties
    function out = promptSettings(animType, options)   %#ok

      out = [];

      switch animType
        case 'AVI'

          handlesList = createDialog4AVI();

        case 'AnimatedGIF'

          handlesList = createDialog4GIF();

      end

      movegui(handlesList.dialogbox, 'center'       );
      set    (handlesList.dialogbox, 'Visible', 'on');
      waitfor(handlesList.dialogbox)


      %--------------------------------------------------------------------
      % Helper function for "promptSettigs" - settings dialog box for AVIs
      function h = createDialog4AVI()

        hF = figure(...
          'Name'                            , 'Animation Settings (AVI)', ...
          'NumberTitle'                     , 'off'                     , ...
          'WindowStyle'                     , 'modal'                   , ...
          'Units'                           , 'pixels'                  , ...
          'Color'                           , [.8 .8 .8]                , ...
          'Position'                        , [0, 0, 500, 230]          , ...
          'Visible'                         , 'off'                     , ...
          'Resize'                          , 'off'                     , ...
          'Tag'                             , 'dialogbox'               , ...
          'defaultUIControlFontName'        , 'Verdana'                 , ...
          'defaultUIControlUnits'           , 'pixels'                  , ...
          'defaultUIControlFontUnits'       , 'pixels'                  , ...
          'defaultUIControlFontSize'        , 12                        , ...
          'defaultUIControlBackgroundColor' , [.8 .8 .8]                );

        if isunix
          compressionTypes  = {'None', 'Other...'};
          compressionVal    = 1;
        else
          compressionTypes  = {'Indeo3', 'Indeo5', 'Cinepak', 'MSVC', 'RLE', 'None', 'Other...'};
          compressionVal    = 2;
        end

        uicontrol(...
          'Style'                           , 'Text'                    , ...
          'Position'                        , [0, 200, 150, 25]         , ...
          'HorizontalAlignment'             , 'right'                   , ...
          'FontWeight'                      , 'bold'                    , ...
          'String'                          , 'File name:'              );
        uicontrol(...
          'Style'                           , 'Text'                    , ...
          'Position'                        , [0, 170, 150, 25]         , ...
          'HorizontalAlignment'             , 'right'                   , ...
          'FontWeight'                      , 'bold'                    , ...
          'String'                          , 'Frames per second:'      );
        uicontrol(...
          'Style'                           , 'Text'                    , ...
          'Position'                        , [0, 140, 150, 25]         , ...
          'HorizontalAlignment'             , 'right'                   , ...
          'FontWeight'                      , 'bold'                    , ...
          'String'                          , 'Frame interval:'         );
        uicontrol(...
          'Style'                           , 'Text'                    , ...
          'Position'                        , [0, 110, 150, 25]         , ...
          'HorizontalAlignment'             , 'right'                   , ...
          'FontWeight'                      , 'bold'                    , ...
          'String'                          , 'Compression:'            );
        uicontrol(...
          'Style'                           , 'Text'                    , ...
          'Position'                        , [0, 80, 150, 25]          , ...
          'HorizontalAlignment'             , 'right'                   , ...
          'FontWeight'                      , 'bold'                    , ...
          'String'                          , 'Quality:'                );
        uicontrol(...
          'Style'                           , 'Text'                    , ...
          'Position'                        , [0,  50, 150, 25]         , ...
          'HorizontalAlignment'             , 'right'                   , ...
          'FontWeight'                      , 'bold'                    , ...
          'String'                          , 'Key frame rate:'         );

        uicontrol(...
          'Style'                           , 'Edit'                    , ...
          'Position'                        , [150, 205, 300, 20]       , ...
          'HorizontalAlignment'             , 'left'                    , ...
          'Enable'                          , 'on'                      , ...
          'BackgroundColor'                 , 'white'                   , ...
          'String'                          , ''                        , ...
          'Callback'                        , @filenameEditCallback     , ...
          'Tag'                             , 'filename'                );
        uicontrol(...
          'Style'                           , 'Pushbutton'              , ...
          'Position'                        , [455, 205, 35, 20]        , ...
          'HorizontalAlignment'             , 'center'                  , ...
          'String'                          , '...'                     , ...
          'Callback'                        , {@setFileNameFcn, 'avi'}  );
        uicontrol(...
          'Style'                           , 'Edit'                    , ...
          'Position'                        , [150, 175, 340, 20]       , ...
          'HorizontalAlignment'             , 'center'                  , ...
          'BackgroundColor'                 , 'white'                   , ...
          'String'                          , options.fps                   , ...
          'Tag'                             , 'fps'                     );
        uicontrol(...
          'Style'                           , 'Edit'                    , ...
          'Position'                        , [150, 145, 340, 20]       , ...
          'HorizontalAlignment'             , 'center'                  , ...
          'BackgroundColor'                 , 'white'                   , ...
          'String'                          , options.frameRate             , ...
          'Tag'                             , 'frameRate'               );
        uicontrol(...
          'Style'                           , 'popupmenu'               , ...
          'Position'                        , [150, 115, 150, 20]       , ...
          'HorizontalAlignment'             , 'center'                  , ...
          'BackgroundColor'                 , 'white'                   , ...
          'String'                          , compressionTypes          , ...
          'Value'                           , compressionVal            , ...
          'Callback'                        , @compressionCallback      , ...
          'Tag'                             , 'compressionType'         );
        uicontrol(...
          'Style'                           , 'Edit'                    , ...
          'Position'                        , [305, 115, 185, 20]       , ...
          'HorizontalAlignment'             , 'center'                  , ...
          'BackgroundColor'                 , 'white'                   , ...
          'Enable'                          , 'off'                     , ...
          'String'                          , '<Enter 4-char code>'     , ...
          'Tag'                             , 'customCompressionType'   );
        uicontrol(...
          'Style'                           , 'Edit'                    , ...
          'Position'                        , [150, 85, 340, 20]        , ...
          'HorizontalAlignment'             , 'center'                  , ...
          'BackgroundColor'                 , 'white'                   , ...
          'String'                          , options.quality               , ...
          'Tag'                             , 'quality'                 );
        uicontrol(...
          'Style'                           , 'Edit'                    , ...
          'Position'                        , [150, 55, 340, 20]        , ...
          'HorizontalAlignment'             , 'center'                  , ...
          'BackgroundColor'                 , 'white'                   , ...
          'String'                          , options.keyFrames             , ...
          'Tag'                             , 'keyFrames'               );

        uicontrol(...
          'Style'                           , 'Pushbutton'              , ...
          'Position'                        , [280, 5, 100, 25]         , ...
          'HorizontalAlignment'             , 'center'                  , ...
          'String'                          , 'Okay'                    , ...
          'Enable'                          , 'off'                     , ...
          'Callback'                        , @okayFcn                  , ...
          'Tag'                             , 'okayBtn'                 );
        uicontrol(...
          'Style'                           , 'Pushbutton'              , ...
          'Position'                        , [390, 5, 100, 25]         , ...
          'HorizontalAlignment'             , 'center'                  , ...
          'String'                          , 'Cancel'                  , ...
          'Callback'                        , 'closereq'                , ...
          'Tag'                             , 'cancelBtn'               );

        h = guihandles(hF);
        guidata(hF, h);

      end %createDialog4AVI

      %--------------------------------------------------------------------
      % Helper function for "promptSettigs" - settings dialog box for
      % Animated GIFs
      function h = createDialog4GIF()

        hF = figure(...
          'Name'                            , 'Animation Settings (Animated GIF)', ...
          'NumberTitle'                     , 'off'                     , ...
          'WindowStyle'                     , 'modal'                   , ...
          'Units'                           , 'pixels'                  , ...
          'Color'                           , [.8 .8 .8]                , ...
          'Position'                        , [0, 0, 500, 170]          , ...
          'Visible'                         , 'off'                     , ...
          'Resize'                          , 'off'                     , ...
          'Tag'                             , 'dialogbox'               , ...
          'defaultUIControlFontName'        , 'Verdana'                 , ...
          'defaultUIControlUnits'           , 'pixels'                  , ...
          'defaultUIControlFontUnits'       , 'pixels'                  , ...
          'defaultUIControlFontSize'        , 12                        , ...
          'defaultUIControlBackgroundColor' , [.8 .8 .8]                );

        uicontrol(...
          'Style'                           , 'Text'                    , ...
          'Position'                        , [0, 140, 150, 25]         , ...
          'HorizontalAlignment'             , 'right'                   , ...
          'FontWeight'                      , 'bold'                    , ...
          'String'                          , 'File name:'              );
        uicontrol(...
          'Style'                           , 'Text'                    , ...
          'Position'                        , [0, 110, 150, 25]         , ...
          'HorizontalAlignment'             , 'right'                   , ...
          'FontWeight'                      , 'bold'                    , ...
          'String'                          , 'Frame delay time (s):'   );
        uicontrol(...
          'Style'                           , 'Text'                    , ...
          'Position'                        , [0, 80, 150, 25]          , ...
          'HorizontalAlignment'             , 'right'                   , ...
          'FontWeight'                      , 'bold'                    , ...
          'String'                          , 'Frame interval:'         );
        uicontrol(...
          'Style'                           , 'Text'                    , ...
          'Position'                        , [0, 50, 150, 25]          , ...
          'HorizontalAlignment'             , 'right'                   , ...
          'FontWeight'                      , 'bold'                    , ...
          'String'                          , 'Disposal method:'        );

        uicontrol(...
          'Style'                           , 'Edit'                    , ...
          'Position'                        , [150, 145, 300, 20]       , ...
          'HorizontalAlignment'             , 'left'                    , ...
          'Enable'                          , 'on'                      , ...
          'BackgroundColor'                 , 'white'                   , ...
          'String'                          , ''                        , ...
          'Callback'                        , @filenameEditCallback     , ...
          'Tag'                             , 'filename'                );
        uicontrol(...
          'Style'                           , 'Pushbutton'              , ...
          'Position'                        , [455, 145, 35, 20]        , ...
          'HorizontalAlignment'             , 'center'                  , ...
          'String'                          , '...'                     , ...
          'Callback'                        , {@setFileNameFcn, 'gif'}  );
        uicontrol(...
          'Style'                           , 'Edit'                    , ...
          'Position'                        , [150, 115, 340, 20]       , ...
          'HorizontalAlignment'             , 'center'                  , ...
          'BackgroundColor'                 , 'white'                   , ...
          'String'                          , options.frameDelay        , ...
          'Tag'                             , 'frameDelay'              );
        uicontrol(...
          'Style'                           , 'Edit'                    , ...
          'Position'                        , [150, 85, 340, 20]        , ...
          'HorizontalAlignment'             , 'center'                  , ...
          'BackgroundColor'                 , 'white'                   , ...
          'String'                          , options.frameRate         , ...
          'Tag'                             , 'frameRate'               );
        uicontrol(...
          'Style'                           , 'popupmenu'               , ...
          'Position'                        , [150, 55, 340, 20]        , ...
          'HorizontalAlignment'             , 'center'                  , ...
          'BackgroundColor'                 , 'white'                   , ...
          'String'                          , {'leaveInPlace', 'restoreBG', 'restorePrevious', 'doNotSpecify'}, ...
          'Value'                           , 4                         , ...
          'Tag'                             , 'disposalMethod'          );

        uicontrol(...
          'Style'                           , 'Pushbutton'              , ...
          'Position'                        , [280, 5, 100, 25]         , ...
          'HorizontalAlignment'             , 'center'                  , ...
          'String'                          , 'Okay'                    , ...
          'Enable'                          , 'Off'                     , ...
          'Callback'                        , @okayFcn                  , ...
          'Tag'                             , 'okayBtn'                 );
        uicontrol(...
          'Style'                           , 'Pushbutton'              , ...
          'Position'                        , [390, 5, 100, 25]         , ...
          'HorizontalAlignment'             , 'center'                  , ...
          'String'                          , 'Cancel'                  , ...
          'Callback'                        , 'closereq'                , ...
          'Tag'                             , 'cancelBtn'               );

        h = guihandles(hF);
        guidata(hF, h);

      end %createDialog4GIF

      %--------------------------------------------------------------------
      % Helper function for "promptSettigs" - Okay Button
      function okayFcn(varargin)
        switch animType
          case 'AVI'
            out.filename       =            get(handlesList.filename             , 'String');
            out.fps            = str2double(get(handlesList.fps                  , 'String'));
            out.frameRate      = str2double(get(handlesList.frameRate            , 'String'));
            compressions       =            get(handlesList.compressionType      , 'String');
            compressionID      =            get(handlesList.compressionType      , 'Value' );
            out.quality        = str2double(get(handlesList.quality              , 'String'));
            out.keyFrames      = str2double(get(handlesList.keyFrames            , 'String'));

            if strcmp(compressions{compressionID}, 'Other...')
              out.compression  =            get(handlesList.customCompressionType, 'String');
            else
              out.compression  = compressions{compressionID};
            end

          case 'AnimatedGIF'
            out.filename       =            get(handlesList.filename             , 'String');
            out.frameDelay     = str2double(get(handlesList.frameDelay           , 'String'));
            out.frameRate      = str2double(get(handlesList.frameRate            , 'String'));
            disposalMethods    =            get(handlesList.disposalMethod       , 'String');
            out.disposalMethod = disposalMethods{get(handlesList.disposalMethod, 'Value')};

        end
        closereq;

      end %okayFcn

      %--------------------------------------------------------------------
      % Helper function for "promptSettigs" - selecting compression type
      % for AVI
      function compressionCallback(varargin)

        if get(varargin{1}, 'Value') <= 6
          set(handlesList.customCompressionType, 'Enable', 'off');
        else
          set(handlesList.customCompressionType, 'Enable', 'on' );
        end
      end %compressionCallback

      %--------------------------------------------------------------------
      % Helper function for "promptSettigs" - selecting file name
      function setFileNameFcn(varargin)


        [filename, pathname] = uiputfile(['*.', varargin{3}], 'Save file as...');
        if ~isnumeric(filename)
          fname = fullfile(pathname, filename);
          set(handlesList.filename, 'String', fname);
          set(handlesList.okayBtn , 'Enable', 'on' );

          setappdata(handlesList.filename, 'currentFilename', fname);
        end
      end %setFileNameFcn

      %--------------------------------------------------------------------
      % Helper function for "promptSettigs" - manual entry of file name
      function filenameEditCallback(varargin)

        thisFilename = get(handlesList.filename, 'String');
        if ~strcmpi(thisFilename, getappdata(handlesList.filename, 'currentFilename'))
          [pname, fname] = fileparts(thisFilename);
          if isempty(pname)               % If directory is not specified, use current directory
            pname = pwd;
          end
          if strcmp(animType, 'AVI')      % Force extension to be correct
            ext = '.avi';
          else
            ext = '.gif';
          end
          if exist(pname, 'dir')
            if exist(fullfile(pname, [fname, ext]), 'file')
              btn = questdlg('Overwrite Warning', 'The file exists. Overwrite?', 'Yes', 'No', 'No');
              if strcmp(btn, 'No')
                set(varargin{1}, 'String', getappdata(handlesList.filename, 'currentFilename'));
                return;
              end
            end
          end

          filename = fullfile(pname, [fname, ext]);
          set(handlesList.filename, 'String', filename);
          setappdata(handlesList.filename, 'currentFilename', filename);
          set(handlesList.okayBtn, 'Enable', 'on');

        end

      end %filenameEditCallback

    end %promptSettings

  end %exportAnimation

%--------------------------------------------------------------------------
% Called when a key is pressed
  function keypressFcn(varargin)    %#ok

    k = get(hs.MainFigure, 'CurrentKey');

    switch k
      case 'rightarrow'     % go to the next frame
        pauseAnimation();
        frm = frm + 1;
        if isLoop && frm > numFrames
          frm = 1;
        else
          frm = min([numFrames, frm]);
        end
        updateLines();

      case 'leftarrow'      % go to the previous frame
        pauseAnimation();
        frm = frm - 1;
        if isLoop && frm < 1
          frm = numFrames;
        else
          frm = max([1, frm]);
        end
        updateLines();

      case 'uparrow'        % speed up the refresh rate
        RRateID = min([length(RRates), RRateID + 1]);
        updateRefreshRate();

      case 'downarrow'      % slow down the refresh rate
        RRateID = max([1, RRateID - 1]);
        updateRefreshRate();

      case 'space'          % toggle play/pause
        if isPlaying
          curRateID = RRateID;
          pauseAnimation();
        else
          RRateID = curRateID;
          start(tm);
        end

      case 'q'              % cancel exporting of animation
        isSaving = false;

    end

  end %keypressFcn

%--------------------------------------------------------------------------
% Called when pause button is pressed
  function pauseAnimation

    RRateID = 11; % this corresponds to zero refresh rate
    set(hs.speedBar, 'XData', [0.5, 0.5]);
    stop(tm);

  end %pauseAnimation

%--------------------------------------------------------------------------
% Called whenever the figure is resized to reposition the components
% "nicely"
  function figResizeFcn(varargin)    %#ok

    set(hs.MainFigure, 'Units', 'pixels');
    figPos   = get(hs.MainFigure, 'Position');
    panelPos = [2, 2, figPos(3)-4, 50];

    set(hs.MainAxes         , 'Position', [65, 100, figPos(3)-90, figPos(4)-130]);
    set(hs.ControlPanelAxes , 'Position', panelPos);
    set(hs.TimelineAxes     , 'Position', [5, panelPos(4)-25, panelPos(3)-130, 20]);
    set(hs.PlaybackAxes     , 'Position', [panelPos(3)-80, 25, 70, panelPos(4)-30]);
    set(hs.FrameText        , 'Position', [5, 2, (panelPos(3)-130)/2, panelPos(4)-35]);
    set(hs.StatusText       , 'Position', [5+(panelPos(3)-130)/2, 2, (panelPos(3)-130)/2, panelPos(4)-35]);
    set(hs.slowerAxes       , 'Position', [panelPos(3)-80 (panelPos(4)-36)/2 16 16]);
    set(hs.fasterAxes       , 'Position', [panelPos(3)-24 (panelPos(4)-36)/2 16 16]);
    set(hs.pauseAxes        , 'Position', [panelPos(3)-52 (panelPos(4)-36)/2 16 16]);
    set(hs.repeatAxes       , 'Position', [panelPos(3)-120 panelPos(4)-23 16 16]);

  end %figResizeFcn

%--------------------------------------------------------------------------
% Called when the time line bar or the speed bar is clicked
  function initiateDragFcn(varargin)

    switch get(varargin{1}, 'Tag')
      case 'speedBar'     % speed control is clicked
        stop(tm);
        set(hs.MainFigure   , 'WindowButtonMotionFcn', @speedFcn);
        setptr(hs.MainFigure, 'closedhand');
      case 'timeLine'     % time line bar is clicked
        pauseAnimation();
        set(hs.MainFigure, 'WindowButtonMotionFcn', @timelineFcn);
        timelineFcn();
    end
    set(hs.MainFigure, 'WindowButtonUpFcn', {@stopDragFcn, get(varargin{1}, 'Tag')});

  end %initiateDragFcn

%--------------------------------------------------------------------------
% Called when the speed control is being dragged
  function speedFcn(varargin)    %#ok

    pt = get(hs.PlaybackAxes, 'CurrentPoint');
    xVal = max([0, min([1, pt(1)])]);
    set(hs.speedBar, 'XData', [xVal, xVal]);

    RRateID = round(xVal*20+1);

  end %speedFcn

%--------------------------------------------------------------------------
% Called when time line bar is being dragged
  function timelineFcn(varargin)    %#ok

    pt = get(hs.TimelineAxes, 'CurrentPoint');
    xVal = max([0, min([1, pt(1)])]);

    frm = max([1, round(numFrames * xVal)]);
    updateLines();

  end %timelineFcn

%--------------------------------------------------------------------------
% Called when the click-n-drag has completed
  function stopDragFcn(varargin)

    set(hs.MainFigure, 'WindowButtonMotionFcn', @motionFcn);
    set(hs.MainFigure, 'WindowButtonUpFcn'    , ''        );

    if strcmp(varargin{3}, 'speedBar')
      updateRefreshRate();
      setptr(hs.MainFigure, 'hand');
    end

  end %stopDragFcn

%--------------------------------------------------------------------------
% Sets the cursor pointer and status text based on pointer location
  function motionFcn(varargin)    %#ok

    loc = get([hs.TimelineAxes, hs.PlaybackAxes, hs.slowerAxes, hs.fasterAxes, hs.pauseAxes, hs.repeatAxes], 'CurrentPoint');
    if isInRect(loc{2}(1,1:2), ...  % mouse over speed control
        [(RRateID - 1)/20 - 0.05, (RRateID - 1)/20 + 0.05, -0.9, 0.9])
      if ptrID ~= 1
        ptrID = 1;
        setptr(hs.MainFigure, ptrTypes{ptrID});
        set(hs.StatusText, 'String', 'Drag to change speed');
      end

    elseif isInRect(loc{1}(1,1:2), [0, 1, -0.8, 0.8]) % mouse over time line bar
      if ptrID ~=2
        ptrID = 2;
        setptr(hs.MainFigure, ptrTypes{ptrID});
        set(hs.StatusText, 'String', 'Drag to select frame');
      end

    elseif isInRect(loc{3}(1,1:2), [1, 16, 1, 16]) % mouse over "slower" icon
      set(hs.StatusText, 'String', 'Slower');

    elseif isInRect(loc{4}(1,1:2), [1, 16, 1, 16]) % mouse over "faster" icon
      set(hs.StatusText, 'String', 'Faster');

    elseif isInRect(loc{5}(1,1:2), [1, 16, 1, 16]) % mouse over pause/play
      if isPlaying
        set(hs.StatusText, 'String', 'Pause');
      else
        set(hs.StatusText, 'String', 'Play');
      end

    elseif isInRect(loc{6}(1,1:2), [1, 16, 1, 16]) % mouse over loop
      if isLoop
        set(hs.StatusText, 'String', 'Turn off Loop');
      else
        set(hs.StatusText, 'String', 'Turn on Loop');
      end

    else                                          % everywhere else
      if ptrID ~= 3
        ptrID = 3;
        setptr(hs.MainFigure, ptrTypes{ptrID});
      end
      set(hs.StatusText, 'String', '');
    end

  end %motionFcn

%--------------------------------------------------------------------------
% Checks to see if pointer is in a rectangular region
  function out = isInRect(xy, rect)

    out = xy(1) > rect(1) && xy(1) < rect(2) && ...
      xy(2) > rect(3) && xy(2) < rect(4);

  end %isInRect

%--------------------------------------------------------------------------
% Updates the timer refresh rate
  function updateRefreshRate

    stop(tm);
    direction = sign(RRates(RRateID));
    if RRateID ~= 11
      curRateID = RRateID;  % store current refresh rate
      tm.Period = abs(RRates(RRateID));
    end
    start(tm);

  end %updateRefreshRate

%--------------------------------------------------------------------------
% Called when the control buttons are pressed
  function speedBtnFcn(varargin)

    switch get(varargin{1}, 'Tag')
      case 'slowerImage'
        RRateID = max([1, RRateID - 1]);
        updateRefreshRate();

      case 'fasterImage'
        RRateID = min([length(RRates), RRateID + 1]);
        updateRefreshRate();

      case 'pauseImage'
        if isPlaying
          curRateID = RRateID;
          pauseAnimation();
          set(hs.StatusText, 'String', 'Play');
        else
          RRateID = curRateID;
          start(tm);
          set(hs.StatusText, 'String', 'Pause');
        end

      case 'repeatImage'
        if isLoop
          set(hs.repeatImage, 'cdata', hs.icons.norepeatCData, 'alphadata', hs.icons.norepeatAlpha);
          set(hs.StatusText, 'String', 'Turn on Loop');
        else
          set(hs.repeatImage, 'cdata', hs.icons.repeatCData, 'alphadata', hs.icons.repeatAlpha);
          set(hs.StatusText, 'String', 'Turn off Loop');
        end
        isLoop = ~isLoop;

        return;

    end

  end %speedBtnFcn

%--------------------------------------------------------------------------
% Called at every timer period
  function timerUpdateFcn(varargin)    %#ok

    % get the new frame
    frm = max([0, min([numFrames + 1, frm + frameRate * direction])]);

    % if isLoop, then loop back if at the end (or first) frame
    if isLoop
      if frm < 1
        frm = numFrames;
      elseif frm > numFrames
        frm = 1;
      end
    end

    % stop if end or speed is zero
    if frm < 1 || frm > numFrames || RRateID == 11
      stop(tm);
      frm = max([1, min([numFrames, frm])]);
    end

    updateLines();

  end %timerUpdateFcn

%--------------------------------------------------------------------------
% Start function for the timer
  function mystartFcn(varargin)    %#ok

    % Change time line bar to green
    set(hs.TimelinePatch, 'CData', cc1b);
    direction = sign(RRates(RRateID));
    if direction > 0
      dd = 'Forward';
    else
      dd = 'Reverse';
    end
    pp = abs(RRates(RRateID));
    set(hs.MainFigure, 'Name', sprintf('ANIMATOR - Refresh Rate: %g sec, %s', pp, dd));
    set(hs.speedBar, 'XData', [(RRateID - 1)/20, (RRateID - 1)/20]);
    isPlaying = true;
    set(hs.pauseImage, 'CData', hs.icons.pauseCData, 'alphadata', hs.icons.pauseAlpha);
    %set(hs.StatusText, 'String', 'Pause');

  end %mystartFcn

%--------------------------------------------------------------------------
% Stop function for the timer
  function mystopFcn(varargin)    %#ok

    % Change time line bar to black
    set(hs.TimelinePatch, 'CData', cc1a);
    set(hs.MainFigure, 'Name', 'ANIMATOR - Paused');
    isPlaying = false;
    set(hs.pauseImage, 'CData', hs.icons.playCData, 'alphadata', hs.icons.playAlpha);
    %set(hs.StatusText, 'String', 'Play');

  end %mystopFcn

%--------------------------------------------------------------------------
% Updates lines based on the signal type
  function updateLines

    switch sigType
      case 1
        set(hs.Lines,  'YData'          , y(:, 1, frm)                  );
      case 2
        set(hs.Lines, {'YData'}         , y(:, :, frm)'                 );
      case 3
        set(hs.Lines, {'XData', 'YData'}, [x(:, :, frm)', y(:, :, frm)']);
    end

    % Update time line slider bar
    set(hs.TimelinePatch , 'XData', [0, 0, frm/numFrames, frm/numFrames]);

    % Update frame number text
    set(hs.FrameText, 'String', sprintf('Frame: %d/%d', frm, numFrames));

  end %updateLines

%--------------------------------------------------------------------------
% Called when figure is closed
  function figDeleteFcn(varargin)    %#ok

    % stop and delete timer object
    stop(tm);
    delete(tm);

  end %figDeleteFcn

%--------------------------------------------------------------------------
% Defines constants/default values and process input arguments
  function [aspectRatio, xlimit, ylimit, titleText, xlabelText, ylabelText, ...
      isSmooth, frm, RRateID, frameRate] = processArguments(args)

    aspectRatio = 'auto';                       % aspectratio is AUTO
    xlimit      = [];                           % no specified xlim
    ylimit      = [];                           % no specified ylim
    titleText   = '';                           % no specified title
    xlabelText  = '';                           % no specified xlabel
    ylabelText  = '';                           % no specified ylabel
    isSmooth    = 'off';                        % no anti-aliasing
    frm         = 1;                            % start at frame 1
    RRateID     = 20;                           % default refresh rate index
    frameRate   = 1;                            % animate every frame

    % Check for additional input arguments
    for iVars = 1:length(args)/2
      val = args{iVars*2};
      switch lower(args{iVars*2-1})
        case 'axis'
          if ischar(val) && ismember(val, {'auto', 'equal'})
            aspectRatio = val;
            continue;
          end
        case 'xlim'
          if isnumeric(val) && isequal(size(val), [1 2])
            xlimit      = val;
            continue;
          end
        case 'ylim'
          if isnumeric(val) && isequal(size(val), [1 2])
            ylimit      = val;
            continue;
          end
        case 'title'
          if ischar(val)
            titleText   = val;
            continue;
          end
        case 'xlabel'
          if ischar(val)
            xlabelText  = val;
            continue;
          end
        case 'ylabel'
          if ischar(val)
            ylabelText  = val;
            continue;
          end
        case 'smooth'
          if ischar(val) && ismember(val, {'on', 'off'})
            isSmooth    = val;
            continue;
          end
        case 'frame'
          if isnumeric(val) && isequal(size(val), [1 1]) && val >=1 && val <= numFrames
            frm         = round(val);
            continue;
          end
        case 'speed'
          if isnumeric(val) && isequal(size(val), [1 1]) && val >=-10 && val <= 10
            RRateID     = round(val + 11);
            continue;
          end
        case 'framerate'
          if isnumeric(val) && isequal(size(val), [1 1]) && ismember(val, [1 2 3 5 10])
            frameRate   = val;
            continue;
          end
        otherwise
          error('Unknown argument: %s', args{iVars*2-1});
      end

      error('Invalid value for ''%s''', args{iVars*2-1});

    end

  end %processArguments

%--------------------------------------------------------------------------
% Error checking
  function [sigType, numFrames] = errorcheck

    if ~isnumeric(x) || ~isnumeric(y)
      error('X and Y must be numeric arrays');
    end
    if ndims(y) ~= 3
      error('Y must be a 3-D array of m (elements) - n (lines) - p (frames)');
    end
    if isempty(x) % if empty, create an index vector
      x = (1:size(y, 1))';
    end

    if ndims(x) == 2                     % X is 2D
      if size(x, 2) == 1                 % X is a column vector
        if size(x, 1) == size(y, 1)      % X and Y has the same # of rows
          if size(y, 2) == 1             % Y is a column vector
            sigType = 1;
          else % size(y, 2) > 2          % Y has multiple columns
            sigType = 2;
            y       = num2cell(y, 1);
          end
          numFrames = size(y, 3);
        else % size(x, 1) ~= size(y, 1)
          error('X and Y must have the same number of rows');
        end
      else % size(x, 2) > 1
        error('If X is 2D, it must be a column vector');
      end
    elseif ndims(x) == 3                % X is 3D
      if size(x, 1) == size(y, 1)       % X and Y has the same # of rows
        if size(x, 2) == 1 || size(x, 2) == size(y, 2)  % X has one column or same as Y
          if size(x, 3) == size(y, 3)   % X and Y has the same # of frames
            sigType   = 3;
            numFrames = size(y, 3);
            x         = num2cell(x, 1);
            y         = num2cell(y, 1);
          else % size(x, 3) ~= size(y, 3)
            error('X and Y must have the same number of frames (3rd dimension)');
          end
        else
          error('X must have exactly one column OR the same number of column as Y');
        end
      else % size(x, 1) ~= size(y, 1)
        error('X and Y must have the same number of rows');
      end
    else % ndims(x) > 3
      error('X must be 2D or 3D');
    end

  end %errorcheck

end %animator