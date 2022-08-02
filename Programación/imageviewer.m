function imageviewer(dirname)

%IMAGEVIEWER  Interactively pan and zoom images on the computer.
%   IMAGEVIEWER starts a GUI for opening image files and interactive
%   panning and zooming.
%
%   IMAGEVIEWER(DIRNAME) starts the GUI with DIRNAME as the initial
%   directory.
%
%   The GUI allows you to navigate through your computer and quickly view
%   image files. It also allows you to interactively explore your images by
%   panning (clicking and drag), zooming (right-click and drag), and
%   centering view (double-clicking).
%

% Copyright 2006 The MathWorks, Inc.

% VERSIONS:
%   v1.0 - first version. (was pictureviewer.m)
%   v1.1 - convert to nested functions. (Nov 13, 2006)
%   v1.2 - bug fix to deal with different image types (Nov 15, 2006)
%   v1.3 - bug fix for centering, sorting of image files.
%          add resize window feature.
%          change FINDOBJ to FINDALL (Nov 16, 2006)
%   v1.4 - cosmetic changes to the GUI.
%          a better timer management. (Dec 2, 2006)
%
% Jiro Doke
% April 2006

verNumber = '1.4';

if nargin == 0
  dirname = [];
else
  if ~ischar(dirname) || ~isdir(dirname)
    error('Invalid input argument.\n  Syntax: %s(DIRNAME)', upper(mfilename));
  end
end

delete(findall(0, 'type', 'figure', 'tag', 'ImageViewer'));

bgcolor1 = [.8 .8 .8];
bgcolor2 = [.7 .7 .7];
txtcolor = [.3 .3 .3];

figH = figure(...
  'units'                         , 'normalized', ...
  'busyaction'                    , 'queue', ...
  'color'                         , bgcolor1, ...
  'deletefcn'                     , @stopTimerFcn, ...
  'doublebuffer'                  , 'on', ...
  'handlevisibility'              , 'callback', ...
  'interruptible'                 , 'on', ...
  'menubar'                       , 'none', ...
  'name'                          , upper(mfilename), ...
  'numbertitle'                   , 'off', ...
  'outerposition'                 , [.1 .1 .8 .8], ...
  'resize'                        , 'on', ...
  'resizefcn'                     , @resizeFcn, ...
  'tag'                           , 'ImageViewer', ...
  'toolbar'                       , 'none', ...
  'visible'                       , 'off', ...
  'defaultaxesunits'              , 'pixels', ...
  'defaulttextfontunits'          , 'pixels', ...
  'defaulttextfontname'           , 'Verdana', ...
  'defaulttextfontsize'           , 12, ...
  'defaultuicontrolunits'         , 'pixels', ...
  'defaultuicontrolfontunits'     , 'pixels', ...
  'defaultuicontrolfontsize'      , 10, ...
  'defaultuicontrolfontname'      , 'Verdana', ...
  'defaultuicontrolinterruptible' , 'off');

uph(1) = uipanel(...
  'units'                     , 'pixels', ...
  'backgroundcolor'           , bgcolor1, ...
  'parent'                    , figH, ...
  'bordertype'                , 'beveledin', ...
  'tag'                       , 'versionPanel');
uicontrol(...
  'style'                     , 'text', ...
  'foregroundcolor'           , txtcolor, ...
  'backgroundcolor'           , bgcolor1, ...
  'horizontalalignment'       , 'center', ...
  'fontweight'                , 'bold', ...
  'string'                    , sprintf('Ver %s', verNumber), ...
  'parent'                    , uph(1), ...
  'tag'                       , 'versionText');
uph(2) = uipanel(...
  'units'                     , 'pixels', ...
  'backgroundcolor'           , bgcolor1, ...
  'parent'                    , figH, ...
  'bordertype'                , 'beveledin', ...
  'tag'                       , 'statusPanel');
uicontrol(...
  'style'                     , 'text', ...
  'foregroundcolor'           , txtcolor, ...
  'backgroundcolor'           , bgcolor1, ...
  'horizontalalignment'       , 'right', ...
  'fontweight'                , 'bold', ...
  'string'                    , '', ...
  'parent'                    , uph(2), ...
  'tag'                       , 'statusText');
uph(3) = uipanel(...
  'units'                     , 'pixels', ...
  'bordertype'                , 'etchedout', ...
  'fontname'                  , 'Verdana', ...
  'fontweight'                , 'bold', ...
  'title'                     , 'View', ...
  'titleposition'             , 'centertop', ...
  'backgroundcolor'           , bgcolor1, ...
  'parent'                    , figH, ...
  'tag'                       , 'frame1');
uicontrol(...
  'style'                     , 'text', ...
  'string'                    , '', ...
  'horizontalalignment'       , 'center', ...
  'fontweight'                , 'bold', ...
  'fontsize'                  , 12, ...
  'backgroundcolor'           , bgcolor1, ...
  'foregroundcolor'           , [.2, .2, .2], ...
  'parent'                    , uph(3), ...
  'tag'                       , 'ZoomCaptionText');
uicontrol(...
  'style'                     , 'pushbutton', ...
  'backgroundcolor'           , bgcolor2, ...
  'string'                    , 'Full', ...
  'fontweight'                , 'bold', ...
  'callback'                  , @resetView, ...
  'enable'                    , 'off', ...
  'tooltipstring'             , 'View full image', ...
  'parent'                    , uph(3), ...
  'tag'                       , 'ResetViewBtn1');
uicontrol(...
  'style'                     , 'pushbutton', ...
  'backgroundcolor'           , bgcolor2, ...
  'string'                    , '100%', ...
  'fontweight'                , 'bold', ...
  'callback'                  , @resetView, ...
  'enable'                    , 'off', ...
  'tooltipstring'             , 'View true size', ...
  'parent'                    , uph(3), ...
  'tag'                       , 'ResetViewBtn2');
uicontrol(...
  'style'                     , 'pushbutton', ...
  'backgroundcolor'           , bgcolor2, ...
  'string'                    , 'Help', ...
  'fontweight'                , 'bold', ...
  'callback'                  , @helpBtnCallback, ...
  'enable'                    , 'on', ...
  'parent'                    , figH, ...
  'tag'                       , 'HelpBtn');
uicontrol(...
  'style'                     , 'togglebutton', ...
  'backgroundcolor'           , bgcolor2, ...
  'string'                    , 'File Info', ...
  'fontweight'                , 'bold', ...
  'callback'                  , @fileInfoBtnCallback, ...
  'enable'                    , 'off', ...
  'parent'                    , figH, ...
  'tag'                       , 'FileInfoBtn');
uph(4) = uipanel(...
  'units'                     , 'pixels', ...
  'backgroundcolor'           , bgcolor1, ...
  'parent'                    , figH, ...
  'bordertype'                , 'beveledin', ...
  'tag'                       , 'CurrentDirectoryPanel');
uicontrol(...
  'style'                     , 'text', ...
  'backgroundcolor'           , bgcolor1, ...
  'horizontalalignment'       , 'left', ...
  'parent'                    , uph(4), ...
  'tag'                       , 'CurrentDirectoryEdit');
uicontrol(...
  'style'                     , 'pushbutton', ...
  'string'                    , '...', ...
  'backgroundcolor'           , bgcolor1, ...
  'callback'                  , @chooseDirectoryCallback, ...
  'parent'                    , figH, ...
  'tag'                       , 'ChooseDirectoryBtn');

% Up Directory Icon
map = [0 0 0;bgcolor1;1 1 0;1 1 1];
upDirIcon = uint8([
  1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
  1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
  1 1 1 0 0 0 0 0 1 1 1 1 1 1 1 1
  1 1 0 3 2 3 2 3 0 1 1 1 1 1 1 1
  1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1
  1 0 2 3 2 3 2 3 2 3 2 3 2 3 2 0
  1 0 3 2 3 2 0 2 3 2 3 2 3 2 3 0
  1 0 2 3 2 0 0 0 2 3 2 3 2 3 2 0
  1 0 3 2 0 0 0 0 0 2 3 2 3 2 3 0
  1 0 2 3 2 3 0 3 2 3 2 3 2 3 2 0
  1 0 3 2 3 2 0 2 3 2 3 2 3 2 3 0
  1 0 2 3 2 3 0 0 0 0 0 3 2 3 2 0
  1 0 3 2 3 2 3 2 3 2 3 2 3 2 3 0
  1 0 2 3 2 3 2 3 2 3 2 3 2 3 2 0
  1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
  1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
  ]);
rgbIcon = ind2rgb(upDirIcon, map);

uicontrol(...
  'style'                     , 'pushbutton', ...
  'cdata'                     , rgbIcon, ...
  'backgroundcolor'           , bgcolor1, ...
  'callback'                  , @upDirectoryCallback, ...
  'parent'                    , figH, ...
  'tag'                       , 'UpDirectoryBtn');
uicontrol(...
  'style'                     , 'listbox', ...
  'backgroundcolor'           , 'white', ...
  'callback'                  , @fileListBoxCallback, ...
  'fontname'                  , 'FixedWidth', ...
  'parent'                    , figH, ...
  'tag'                       , 'FileListBox');

uph(5) = uipanel(...
  'units'                     , 'pixels', ...
  'bordertype'                , 'etchedout', ...
  'backgroundcolor'           , bgcolor1, ...
  'fontname'                  , 'Verdana', ...
  'fontsize'                  , 10, ...
  'fontweight'                , 'bold', ...
  'title'                     , 'Preview', ...
  'titleposition'             , 'centertop', ...
  'parent'                    , figH, ...
  'tag'                       , 'PreviewImagePanel');

axes(...
  'handlevisibility'          , 'callback', ...
  'parent'                    , uph(5), ...
  'visible'                   , 'off', ...
  'tag'                       , 'PreviewImageAxes');

axes(...
  'box'                       , 'on', ...
  'xtick'                     , [], ...
  'ytick'                     , [], ...
  'handlevisibility'          , 'callback', ...
  'parent'                    , figH, ...
  'tag'                       , 'ImageAxes');

% for drawing the zoom line
axH = axes(...
  'units'                     , 'normalized', ...
  'position'                  , [0 0 1 1], ...
  'box'                       , 'on', ...
  'hittest'                   , 'off', ...
  'xlim'                      , [0 1], ...
  'xtick'                     , [], ...
  'ylim'                      , [0 1], ...
  'ytick'                     , [], ...
  'handlevisibility'          , 'callback', ...
  'visible'                   , 'off', ...
  'parent'                    , figH, ...
  'tag'                       , 'InvisibleAxes');

line(NaN, NaN, ...
  'linestyle'                 , '--', ...
  'linewidth'                 , 2, ...
  'color'                     , 'r', ...
  'parent'                    , axH, ...
  'tag'                       , 'ZoomLine');

uicontrol(...
  'style'                     , 'listbox', ...
  'backgroundcolor'           , [.75, .75, 1], ...
  'fontname'                  , 'FixedWidth', ...
  'fontsize'                  , 14, ...
  'visible'                   , 'off', ...
  'enable'                    , 'inactive', ...
  'interruptible'             , 'off', ...
  'busyaction'                , 'queue', ...
  'horizontalalignment'       , 'left', ...
  'parent'                    , figH, ...
  'tag'                       , 'MessageTextBox');

handles             = guihandles(figH);
handles.figPos      = [];
handles.axPos       = [];
handles.lastDir     = dirname;
handles.ImX         = [];
handles.tm          = timer(...
  'name'            , 'image preview timer', ...
  'executionmode'   , 'fixedspacing', ...
  'objectvisibility', 'off', ...
  'taskstoexecute'  , inf, ...
  'period'          , 0.001, ...
  'startdelay'      , 3, ...
  'timerfcn'        , @getPreviewImages);

resizeFcn;

% Show initial directory
showDirectory;

set(figH, 'visible', 'on');


%--------------------------------------------------------------------------
% resizeFcn
%   This resizes the figure window appropriately
%--------------------------------------------------------------------------
  function resizeFcn(varargin)

    set(figH, 'units', 'pixels');
    figPos = get(figH, 'position');

    % figure can't be too small or off the screen
    if figPos(3) < 750 || figPos(4) < 500
      figPos(3) = max([750 figPos(3)]);
      figPos(4) = max([500 figPos(4)]);
      screenSize = get(0, 'screensize');
      if figPos(1)+figPos(3) > screenSize(3)
        figPos(1) = screenSize(3) - figPos(3) - 50;
      end
      if figPos(2)+figPos(4) > screenSize(4)
        figPos(2) = screenSize(4) - figPos(4) - 50;
      end

      set(figH, 'position', figPos);

    end

    set(handles.versionPanel         , 'position', [1, 1, 100, 25]);
    set(handles.versionText          , 'position', [2, 2, 96, 20]);
    set(handles.statusPanel          , 'position', [102, 1, figPos(3)-102, 25]);
    set(handles.statusText           , 'position', [2, 2, figPos(3)-107, 20]);
    set(handles.frame1               , 'position', [figPos(3)-115, figPos(4)-55, 110, 53]);
    set(handles.ZoomCaptionText      , 'position', [5, 22, 100, 17]);
    set(handles.ResetViewBtn1        , 'position', [5, 2, 47, 20]);
    set(handles.ResetViewBtn2        , 'position', [55, 2, 47, 20]);
    set(handles.HelpBtn              , 'position', [figPos(3)-220, figPos(4)-28, 100, 20]);
    set(handles.FileInfoBtn          , 'position', [figPos(3)-220, figPos(4)-50, 100, 20]);
    set(handles.CurrentDirectoryPanel, 'position', [20, figPos(4)-30, 215, 20]);
    set(handles.CurrentDirectoryEdit , 'position', [1, 1, 213, 18]);
    set(handles.ChooseDirectoryBtn   , 'position', [237, figPos(4)-30, 20, 20]);
    set(handles.UpDirectoryBtn       , 'position', [259, figPos(4)-30, 20, 20]);
    set(handles.FileListBox          , 'position', [20, 270, 260, figPos(4)-310]);
    set(handles.PreviewImagePanel    , 'position', [20, 40, 260, 220]);
    set(handles.PreviewImageAxes     , 'position', [5, 5, 245, 190]);
    set(handles.ImageAxes            , 'position', [300, 40, figPos(3)-310, figPos(4)-120]);
    axPos = get(handles.ImageAxes    , 'position');

    textBoxDim  = [400, 200];
    rightMargin = figPos(3)-(axPos(1)+axPos(3));
    topMargin   = figPos(4)-(axPos(2)+axPos(4));
    set(handles.MessageTextBox      , 'position', [figPos(3)-rightMargin-textBoxDim(1), ...
      figPos(4)-topMargin-textBoxDim(2), ...
      textBoxDim]);
    handles.figPos = figPos;
    handles.axPos  = axPos;

    titleStr = get(get(handles.ImageAxes, 'title'), 'string');
    if ~isempty(titleStr)
      % resize image as well
      loadImage(titleStr);
    end

  end


%--------------------------------------------------------------------------
% helpBtnCallback
%   This opens up a help dialog box
%--------------------------------------------------------------------------
  function helpBtnCallback(varargin)

    helpdlg({...
      'Navigate through directories using the list box on the left.', ...
      'Single-click to see the preview.', ...
      'Double-click (list box OR preview image) to open and display image.', ...
      '', 'Click and drag to pan the image.', ...
      'Right click and drag to zoom.', ...
      'Double-click to center view.', ...
      '''Full'' displays the whole image.', ...
      '''100%'' displays the image at the true resolution.', ...
      '''File Info'' displays the current image file info.'}, 'Help');

  end

%--------------------------------------------------------------------------
% fileInfoBtnCallback
%   This displays the file info of the image that's displayed
%--------------------------------------------------------------------------
  function fileInfoBtnCallback(varargin)

    obj = varargin{1};

    if get(obj, 'value')

      % First 9 fields of IMFINFO are always the same
      fnames      = fieldnames(handles.iminfo); fnames = fnames(1:9);
      vals        = struct2cell(handles.iminfo); vals = vals(1:9);

      % Only show file name (not full path)
      [p, n, e]   = fileparts(vals{1});
      vals{1}     = [n e];
      sID         = cellfun('isclass', vals, 'char');
      dID         = cellfun('isclass', vals, 'double');
      fmt         = cell(2, 9);
      fmt(1, :)   = repmat({'%15s: '}, 1, 9);
      fmt(2, sID) = repmat({'%s|'}, 1, length(find(sID)));
      fmt(2, dID) = repmat({'%d|'}, 1, length(find(dID)));
      tmp         = [fnames(:),vals(:)]';
      str         = sprintf([fmt{:}], tmp{:});
      set(handles.MessageTextBox, 'string', str, 'visible', 'on');

    else
      set(handles.MessageTextBox, 'visible', 'off');

    end

  end

%--------------------------------------------------------------------------
% showDirectory
%   This function shows a list of image files in the directory
%--------------------------------------------------------------------------
  function showDirectory(dirname)

    % Reset settings and images
    stopTimer;
    cla(handles.PreviewImageAxes);
    axis(handles.PreviewImageAxes, 'normal');
    clearImageAxes;
    %----------------------------------------------------------------------

    if nargin == 1
      handles.lastDir = dirname;
    else
      if isempty(handles.lastDir)
        handles.lastDir = pwd;
      end
    end

    set(handles.CurrentDirectoryEdit, 'string', ...
      fixLongDirName(handles.lastDir), ...
      'tooltipstring', handles.lastDir);

    % Get image formats
    imf  = imformats;
    exts = [imf.ext];
    d = [];
    for id = 1:length(exts)
      d = [d; dir(fullfile(handles.lastDir, ['*.' exts{id}]))];
    end

    n = sort({d.name});

    d2 = dir(handles.lastDir);
    n2 = {d2.name};
    n2 = n2([d2.isdir]);
    ii1 = strmatch('.', n2, 'exact');
    ii2 = strmatch('..', n2, 'exact');
    n2([ii1, ii2]) = '';

    if isempty(n)
      handles.imageID = [];
      handles.imageNames = {};
      handles.imagePreviews = {};
      runTimer = false;
    else
      handles.imageID = 1:length(n);
      handles.imageNames = n;
      handles.imagePreviews = cell(1,length(n));
      runTimer = true;
    end

    if ~isempty(n2)
      n2 = strcat(repmat({'['}, 1, length(n2)), n2, repmat({']'}, 1, length(n2)));
      n = {n2{:}, n{:}};

      handles.imageID = handles.imageID + length(n2);
    end
    set(handles.FileListBox, 'string', n, 'value', 1);

    if runTimer
      startTimer;
    end

    if ~isempty(handles.imageID)
      set(handles.ImageViewer, 'selectiontype', 'normal');
      set(handles.FileListBox, 'value', handles.imageID(1));
      fileListBoxCallback(handles.FileListBox);
    end

  end

%--------------------------------------------------------------------------
% getPreviewImages
%   This is the TimerFcn for the preview timer object
%--------------------------------------------------------------------------
  function getPreviewImages(varargin)

    try

      id = find(cellfun('isempty', handles.imagePreviews));

      if ~isempty(id)
        set(handles.statusText, 'string', ...
          sprintf('Generating Thumbnails ... %d of %d', ...
          length(handles.imagePreviews)-length(id)+1, ...
          length(handles.imagePreviews)));
        drawnow;
        handles.imagePreviews{id(1)} = ...
          getPreviewImageData(...
          fullfile(get(handles.CurrentDirectoryEdit, 'tooltipstring'), ...
          handles.imageNames{id(1)}));

      else % All previews are generated. Stop timer
        set(handles.statusText, 'string', '');
        stopTimer;

      end

    catch
      return;

    end

  end

%--------------------------------------------------------------------------
% getPreviewImageData
%   This reads in image file for thumbnails
%--------------------------------------------------------------------------
  function x = getPreviewImageData(filename)

    x = readImageFileFcn(filename);
    if ~isnan(x)
      sz = size(x);
      r = [200, 260] ./ sz(1:2);

      % Crude IMRESIZE (non-toolbox)
      xd = round(linspace(1,sz(1), round(sz(1) * min(r))));
      yd = round(linspace(1,sz(2), round(sz(2) * min(r))));
      x = x(xd, yd, :);
    end

  end

%--------------------------------------------------------------------------
% fixLongDirName
%   This truncates the directory string if it is too long to display
%--------------------------------------------------------------------------
  function newdirname = fixLongDirName(dirname)
    % Modify string for long directory names
    if length(dirname) > 20
      [tmp1, tmp2] = strtok(dirname, filesep);
      if isempty(tmp2)
        newdirname = dirname;

      else
        % in case the directory name starts with a file separator.
        id = strfind(dirname, tmp2);
        tmp1 = dirname(1:id(1));
        [p, tmp2] = fileparts(dirname);
        if strcmp(tmp1, p) || isempty(tmp2)
          newdirname = dirname;

        else
          newdirname = fullfile(tmp1, '...', tmp2);
          tmp3 = '';
          while length(newdirname) < 20
            tmp3 = fullfile(tmp2, tmp3);
            [p, tmp2] = fileparts(p);
            if strcmp(tmp1, p)  % reach root directory
              newdirname = dirname;
              %break; % it will break because dirname is longer than 30 chars

            else
              newdirname = fullfile(tmp1, '...', tmp2, tmp3);

            end
          end
        end
      end
    else
      newdirname = dirname;
    end

  end

%--------------------------------------------------------------------------
% fileListBoxCallback
%   This gets called when an entry is selected in the file list box
%--------------------------------------------------------------------------
  function fileListBoxCallback(varargin)

    obj = varargin{1};
    stopTimer;
    val = get(obj, 'value');
    str = cellstr(get(obj, 'string'));

    if ~isempty(str)

      switch get(handles.ImageViewer, 'selectiontype')
        case 'normal'   % single click - show preview

          if str{val}(1) == '[' && str{val}(end) == ']'
            cla(handles.PreviewImageAxes);
            axis(handles.PreviewImageAxes, 'normal');

          else
            id = find(handles.imageID == val);
            if isempty(handles.imagePreviews{id});
              handles.imagePreviews{id} = ...
                getPreviewImageData(...
                fullfile(...
                get(handles.CurrentDirectoryEdit, 'tooltipstring'), ...
                str{val}));
            end

            if ~isnan(handles.imagePreviews{id})
              image(handles.imagePreviews{id}, ...
                'parent', handles.PreviewImageAxes, ...
                'hittest', 'off');
              set(handles.PreviewImagePanel, 'buttondownfcn', @previewImageClickFcn);

            else % unable to load image
              cla(handles.PreviewImageAxes);
              set(handles.PreviewImagePanel, 'buttondownfcn', '');
              text(0.5, 0.5, 'Can''t Load Image', ...
                'parent', handles.PreviewImageAxes, ...
                'horizontalalignment', 'center', ...
                'verticalalignment', 'middle');
              set(handles.PreviewImageAxes, 'xlim', [0 1], 'ylim', [0 1]);

            end

            axis(handles.PreviewImageAxes, 'equal');
            set(handles.PreviewImageAxes, 'visible', 'off');

          end
          startTimer;

        case 'open'   % double click - open image and display

          if str{val}(1) == '[' && str{val}(end) == ']'
            dirname = get(handles.CurrentDirectoryEdit, 'tooltipstring');
            newdirname = fullfile(dirname, str{val}(2:end-1));
            showDirectory(newdirname)

          else
            handles.ImX = [];
            loadImage(fullfile(get(handles.CurrentDirectoryEdit, 'tooltipstring'), str{val}));

            startTimer;
          end
      end

    end

    %----------------------------------------------------------------------
    % previewImageClickFcn
    %   This loads the image when the thumbnail is double-clicked
    %----------------------------------------------------------------------
    function previewImageClickFcn(varargin)

      switch get(handles.ImageViewer, 'selectiontype')

        case 'open'   % double-click

          stopTimer;

          handles.ImX = [];
          loadImage(fullfile(get(handles.CurrentDirectoryEdit, 'tooltipstring'), str{val}));

          startTimer;

      end
    end

  end

%--------------------------------------------------------------------------
% chooseDirectoryCallback
%   This opens a directory selector
%--------------------------------------------------------------------------
  function chooseDirectoryCallback(varargin)

    stopTimer;
    dirname = uigetdir(get(handles.CurrentDirectoryEdit, 'tooltipstring'), ...
      'Choose Directory');
    if ischar(dirname)
      showDirectory(dirname)
    end

  end

%--------------------------------------------------------------------------
% upDirectoryCallback
%   This moves up the current directory
%--------------------------------------------------------------------------
  function upDirectoryCallback(varargin)

    stopTimer;
    dirname = get(handles.CurrentDirectoryEdit, 'tooltipstring');
    dirname2 = fileparts(dirname);
    if ~isequal(dirname, dirname2)
      showDirectory(dirname2)
    end

  end

%--------------------------------------------------------------------------
% resetView
%   This resets the view to "Full" or "100%" magnification
%--------------------------------------------------------------------------
  function resetView(varargin)

    obj = varargin{1};
    stopTimer;
    set(handles.MessageTextBox, 'visible', 'off');
    set(handles.FileInfoBtn, 'value', false);

    switch get(obj, 'string')
      case 'Full'
        xlimit = handles.xlimFull;
        ylimit = handles.ylimFull;

      case '100%'
        xlimit = handles.xlim100;
        ylimit = handles.ylim100;
    end

    xl = xlim(handles.ImageAxes); xd = (xlimit - xl)/10;
    yl = ylim(handles.ImageAxes); yd = (ylimit - yl)/10;

    % Restore only if needed
    if ~(isequal(xd, [0 0]) && isequal(yd, [0 0]))

      set(handles.statusText, 'string', 'Restoring View...');

      % Animate with "good" speed
      for id = [1, 4, 6.5, 7.8, 8.5, 9, 9.3, 9.6, 9.8, 10]

        set(handles.ImageAxes, ...
          'xlim'                , xl + xd * id, ...
          'ylim'                , yl + yd * id, ...
          'cameraviewanglemode' , 'auto', ...
          'dataaspectratiomode' , 'auto', ...
          'plotboxaspectratio'  , handles.pbar);
        set(handles.ZoomCaptionText, 'string', sprintf('%d %%', ...
          round(diff(handles.xlim100)/diff(xl + xd * id)*100)));

        pause(0.01);
      end

      set(handles.statusText, 'string', '');

    end

    startTimer;

  end

%--------------------------------------------------------------------------
% loadImage
%   This loads the selected image and displays it
%--------------------------------------------------------------------------
  function loadImage(filename)

    try
      if isempty(handles.ImX)
        clearImageAxes;
        set(handles.statusText, 'string', 'Loading Image...');
        drawnow;
        [handles.ImX, handles.iminfo] = readImageFileFcn(filename);
      end

      if ~isnan(handles.ImX)
        iH = image(handles.ImX, 'parent', handles.ImageAxes);
        set(iH, 'hittest', 'off');
        axis(handles.ImageAxes, 'equal');
        set(handles.ImageAxes, ...
          'box'             , 'on', ...
          'xtick'           , [], ...
          'ytick'           , [], ...
          'buttondownfcn'   , @winBtnDownFcn, ...
          'interruptible'   , 'off', ...
          'busyaction'      , 'queue', ...
          'handlevisibility', 'callback');
        set(handles.ResetViewBtn1, 'enable', 'on');
        set(handles.ResetViewBtn2, 'enable', 'on');
        set(handles.FileInfoBtn  , 'enable', 'on');
        set(get(handles.ImageAxes, 'title'), ...
          'string'      , sprintf('%s', filename), ...
          'interpreter' , 'none');
        handles.pbar     = get(handles.ImageAxes, 'plotboxaspectratio');
        handles.xlimFull = get(handles.ImageAxes, 'xlim');
        handles.ylimFull = get(handles.ImageAxes, 'ylim');

        % If image is small, show at 100% size
        sz              = size(handles.ImX);
        handles.xlim100 = sz(2)/2 + [-1, 1] * handles.axPos(3)/2;
        handles.ylim100 = sz(1)/2 + [-1, 1] * handles.axPos(4)/2;
        if all(handles.axPos(3:4) > sz([2 1]))
          set(handles.ImageAxes, ...
            'xlim'                , handles.xlim100, ...
            'ylim'                , handles.ylim100, ...
            'cameraviewanglemode' , 'auto', ...
            'dataaspectratiomode' , 'auto', ...
            'plotboxaspectratio'  , handles.pbar);
          set(handles.ZoomCaptionText, 'string', '100 %');

        else
          set(handles.ZoomCaptionText, 'string', sprintf('%d %%', ...
            round(diff(handles.xlim100)/diff(handles.xlimFull)*100)));
        end
      end

    catch
      errordlg({'Could not open image file', lasterr}, 'Error');
      clearImageAxes;

    end

    set(handles.statusText, 'string', '');

  end

%--------------------------------------------------------------------------
% clearImageAxes
%   This clears the image axis
%--------------------------------------------------------------------------
  function clearImageAxes

    cla(handles.ImageAxes);
    axis(handles.ImageAxes, 'normal');
    set(get(handles.ImageAxes, 'title') , 'string'        , '');
    set(handles.ImageAxes               , 'buttondownfcn' , '');
    set(handles.ResetViewBtn1           , 'enable'        , 'off');
    set(handles.ResetViewBtn2           , 'enable'        , 'off');
    set(handles.FileInfoBtn             , 'enable'        , 'off', ...
      'value'         , false);
    set(handles.ZoomCaptionText         , 'string'        , '');
    set(handles.MessageTextBox          , 'visible'       , 'off');
    handles.ImX = [];

  end

%--------------------------------------------------------------------------
% winBtnDownFcn
%   This is called when the mouse is clicked in one of the axes
%   NORMAL clicks will start panning mode.
%   ALT clicks will start zooming mode.
%   OPEN clicks will center the view.
%--------------------------------------------------------------------------
  function winBtnDownFcn(varargin)

    obj = varargin{1};
    stopTimer;
    set(handles.MessageTextBox, 'visible', 'off');
    set(handles.FileInfoBtn, 'value', false);

    switch get(handles.ImageViewer, 'selectiontype')
      case 'normal'
        % Start panning mode

        closedHandPointer = [
          NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN
          NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN
          NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN
          NaN,NaN,NaN,NaN,2  ,2  ,NaN,2  ,2  ,NaN,2  ,2  ,NaN,NaN,NaN,NaN
          NaN,NaN,NaN,2  ,1  ,1  ,2  ,1  ,1  ,2  ,1  ,1  ,2  ,2  ,NaN,NaN
          NaN,NaN,2  ,1  ,2  ,2  ,1  ,2  ,2  ,1  ,2  ,2  ,1  ,1  ,2  ,NaN
          NaN,NaN,2  ,1  ,2  ,2  ,2  ,2  ,2  ,2  ,2  ,2  ,1  ,2  ,1  ,2
          NaN,NaN,NaN,2  ,1  ,2  ,2  ,2  ,2  ,2  ,2  ,2  ,2  ,2  ,1  ,2
          NaN,NaN,2  ,1  ,1  ,2  ,2  ,2  ,2  ,2  ,2  ,2  ,2  ,2  ,1  ,2
          NaN,2  ,1  ,2  ,2  ,2  ,2  ,2  ,2  ,2  ,2  ,2  ,2  ,2  ,1  ,2
          NaN,2  ,1  ,2  ,2  ,2  ,2  ,2  ,2  ,2  ,2  ,2  ,2  ,2  ,1  ,2
          NaN,2  ,1  ,2  ,2  ,2  ,2  ,2  ,2  ,2  ,2  ,2  ,2  ,1  ,2  ,NaN
          NaN,NaN,2  ,1  ,2  ,2  ,2  ,2  ,2  ,2  ,2  ,2  ,2  ,1  ,2  ,NaN
          NaN,NaN,NaN,2  ,1  ,2  ,2  ,2  ,2  ,2  ,2  ,2  ,1  ,2  ,NaN,NaN
          NaN,NaN,NaN,NaN,2  ,1  ,2  ,2  ,2  ,2  ,2  ,2  ,1  ,2  ,NaN,NaN
          NaN,NaN,NaN,NaN,2  ,1  ,2  ,2  ,2  ,2  ,2  ,2  ,1  ,2  ,NaN,NaN
          ];

        xy = get(obj, 'currentpoint');
        set(handles.ImageViewer, ...
          'pointer'               , 'custom', ...
          'pointershapecdata'     , closedHandPointer, ...
          'windowbuttonmotionfcn' , @winBtnMotionFcn);
        set(handles.ImageViewer, 'windowbuttonupfcn', @winBtnUpFcn);

      case 'alt'
        % Start zooming mode

        zoomInOutPointer = [
          NaN,NaN,NaN,2  ,2  ,NaN,NaN,NaN,NaN,NaN,NaN,2  ,2  ,NaN,NaN,NaN
          NaN,NaN,2  ,1  ,1  ,2  ,NaN,NaN,NaN,NaN,2  ,1  ,1  ,2  ,NaN,NaN
          NaN,2  ,1  ,1  ,1  ,1  ,2  ,NaN,NaN,2  ,2  ,1  ,1  ,2  ,2  ,NaN
          2  ,1  ,1  ,1  ,1  ,1  ,1  ,2  ,2  ,1  ,1  ,1  ,1  ,1  ,1  ,2
          2  ,1  ,2  ,1  ,1  ,2  ,1  ,2  ,2  ,1  ,1  ,1  ,1  ,1  ,1  ,2
          NaN,2  ,2  ,1  ,1  ,2  ,2  ,NaN,NaN,2  ,2  ,1  ,1  ,2  ,2  ,NaN
          NaN,NaN,2  ,1  ,1  ,2  ,NaN,NaN,NaN,NaN,2  ,1  ,1  ,2  ,NaN,NaN
          NaN,NaN,NaN,2  ,2  ,NaN,NaN,NaN,NaN,NaN,NaN,2  ,2  ,NaN,NaN,NaN
          NaN,NaN,NaN,2  ,2  ,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN
          NaN,NaN,2  ,1  ,1  ,2  ,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN
          NaN,2  ,2  ,1  ,1  ,2  ,2  ,NaN,NaN,2  ,2  ,2  ,2  ,2  ,2  ,NaN
          2  ,1  ,2  ,1  ,1  ,2  ,1  ,2  ,2  ,1  ,1  ,1  ,1  ,1  ,1  ,2
          2  ,1  ,1  ,1  ,1  ,1  ,1  ,2  ,2  ,1  ,1  ,1  ,1  ,1  ,1  ,2
          NaN,2  ,1  ,1  ,1  ,1  ,2  ,NaN,NaN,2  ,2  ,2  ,2  ,2  ,2  ,NaN
          NaN,NaN,2  ,1  ,1  ,2  ,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN
          NaN,NaN,NaN,2  ,2  ,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN
          ];

        xl = get(obj, 'xlim'); midX = mean(xl); rngXhalf = diff(xl) / 2;
        yl = get(obj, 'ylim'); midY = mean(yl); rngYhalf = diff(yl) / 2;
        curPt  = mean(get(obj, 'currentpoint'));curPt = curPt(1:2);
        curPt2 = (curPt-[midX, midY]) ./ [rngXhalf, rngYhalf];
        curPt  = [curPt; curPt];
        curPt2 = [-(1+curPt2).*[rngXhalf, rngYhalf];...
          (1-curPt2).*[rngXhalf, rngYhalf]];
        initPt = get(handles.ImageViewer, 'currentpoint');
        set(handles.statusText, 'string', 'Zooming...');
        set(handles.ImageViewer, ...
          'pointer'               , 'custom', ...
          'pointershapecdata'     , zoomInOutPointer, ...
          'windowbuttonmotionfcn' , @zoomMotionFcn);
        set(handles.ImageViewer, 'windowbuttonupfcn', @winBtnUpFcn);

      case 'open'
        % Center the view

        set(handles.ImageViewer, 'windowbuttonupfcn', @winBtnUpFcn);

        % Get current units
        un    = get(0, 'units');
        set(0, 'units', 'pixels');
        pt2   = get(0, 'pointerlocation');
        pt    = get(obj, 'currentpoint');
        axPos = get(obj, 'position');
        xl = get(obj, 'xlim'); midX = mean(xl);
        yl = get(obj, 'ylim'); midY = mean(yl);

        % update figure position in case it was moved
        handles.figPos = get(handles.ImageViewer, 'position');

        % get distance between cursor and center of axes
        d = norm(pt2 - (handles.figPos(1:2) + axPos(1:2) + axPos(3:4)/2));

        if d > 2  % center only if distance is at least 2 pixels away
          ld = (mean(pt(:, 1:2)) - [midX, midY]) / 10;
          pd = ((handles.figPos(1:2) + axPos(1:2) + axPos(3:4) / 2) - pt2) / 10;

          set(handles.statusText, 'string', 'Centering...');

          % Animate with "good" speed
          for id = [1, 4, 6.5, 7.8, 8.5, 9, 9.3, 9.6, 9.8, 10]

            % Set axes limits and automatically set ticks
            % Set aspect ratios
            set(obj, ...
              'xlim'                , xl + id * ld(1), ...
              'ylim'                , yl + id * ld(2), ...
              'cameraviewanglemode' , 'auto', ...
              'dataaspectratiomode' , 'auto', ...
              'plotboxaspectratio'  , handles.pbar);

            % Move pointer with limits
            set(0, 'pointerlocation', pt2 + id * pd);

            pause(0.01);
          end

        end

        % Reset UNITS
        set(0, 'units', un);

    end

    %----------------------------------------------------------------------
    % winBtnMotionFcn (nested under winBtnDownFcn)
    %   This function is called when click-n-drag (panning) is happening
    %----------------------------------------------------------------------
    function winBtnMotionFcn(varargin)

      pt = get(handles.ImageAxes, 'currentpoint');

      % Update axes limits and automatically set ticks
      % Set aspect ratios
      set(handles.ImageAxes, ...
        'xlim', get(handles.ImageAxes, 'xlim') + (xy(1,1)-(pt(1,1)+pt(2,1))/2), ...
        'ylim', get(handles.ImageAxes, 'ylim') + (xy(1,2)-(pt(1,2)+pt(2,2))/2), ...
        'cameraviewanglemode' , 'auto', ...
        'dataaspectratiomode' , 'auto', ...
        'plotboxaspectratio'  , handles.pbar);
      set(handles.statusText, 'string', 'Panning...');

    end


    %----------------------------------------------------------------------
    % zoomMotionFcn (nested under winBtnDownFcn)
    %   This performs the click-n-drag zooming function. The pointer
    %   location relative to the initial point determines the amount of
    %   zoom (in or out).
    %----------------------------------------------------------------------
    function zoomMotionFcn(varargin)

      % Power law allows for the inverse to work:
      %      C^(x) * C^(-x) = 1
      % Choose C to get "appropriate" zoom factor
      C                   = 50;
      obj                 = varargin{1};
      pt                  = get(obj, 'currentpoint');
      r                   = C ^ ((initPt(2) - pt(2)) / handles.figPos(4));
      newLimSpan          = r * curPt2; dTemp = diff(newLimSpan);
      pt(1)               = initPt(1);

      % Determine new limits based on r
      lims                = curPt + newLimSpan;

      % Update axes limits and automatically set ticks
      % Set aspect ratios
      set(handles.ImageAxes, ...
        'xlim'                , lims(:,1), ...
        'ylim'                , lims(:,2), ...
        'cameraviewanglemode' , 'auto', ...
        'dataaspectratiomode' , 'auto', ...
        'plotboxaspectratio'  , handles.pbar);

      % Update zoom indicator line
      set(handles.ZoomLine, ...
        'xdata', [initPt(1), pt(1)]/handles.figPos(3), ...
        'ydata', [initPt(2), pt(2)]/handles.figPos(4));
      set(handles.ZoomCaptionText, 'string', sprintf('%d %%', ...
        round(diff(handles.xlim100)/dTemp(1)*100)));

    end

  end


%--------------------------------------------------------------------------
% winBtnUpFcn
%   This is called when the mouse is released
%--------------------------------------------------------------------------
  function winBtnUpFcn(varargin)

    obj = varargin{1};
    set(obj, ...
      'pointer'               , 'arrow', ...
      'windowbuttonmotionfcn' , '');
    set(handles.statusText, 'string', '');
    set(handles.ZoomLine, 'xdata', NaN, 'ydata', NaN);
    set(handles.ImageViewer, 'windowbuttonupfcn', '');

    startTimer;

  end


%--------------------------------------------------------------------------
% startTimer
%   This starts the timer. If the timer object is invalid, it creates a new
%   one.
%--------------------------------------------------------------------------
  function startTimer

    try

      if ~strcmpi(handles.tm.Running, 'on');
        start(handles.tm);
      end

    catch

      handles.tm          = timer(...
        'name'            , 'image preview timer', ...
        'executionmode'   , 'fixedspacing', ...
        'objectvisibility', 'off', ...
        'taskstoexecute'  , inf, ...
        'period'          , 0.001, ...
        'startdelay'      , 3, ...
        'timerfcn'        , @getPreviewImages);
      start(handles.tm);

    end

  end


%--------------------------------------------------------------------------
% stopTimerFcn
%   This gets called when the figure is closed.
%--------------------------------------------------------------------------
  function stopTimerFcn(varargin)

    stop(handles.tm);
    % wait until timer stops
    while ~strcmpi(handles.tm.Running, 'off')
      drawnow;
    end
    delete(handles.tm);

  end


%--------------------------------------------------------------------------
% stopTimer
%   This stops the timer object used for generating image previews
%--------------------------------------------------------------------------
  function stopTimer(varargin)

    stop(handles.tm);

    % wait until timer stops
    while ~strcmpi(handles.tm.Running, 'off')
      drawnow;
    end

    set(handles.statusText, 'string', '');

  end


%--------------------------------------------------------------------------
% readImageFileFcn
%   This function reads in the image file and converts to TRUECOLOR
%--------------------------------------------------------------------------
  function [x, info] = readImageFileFcn(filename)

    try
      [x, mp] = imread(filename);
      info = imfinfo(filename);
      info = info(1);

      switch info.ColorType
        case 'grayscale'
          switch class(x)
            case 'logical'
              x = uint8(x);
              mp = [0 0 0;1 1 1];

            case 'uint8'
              mp = gray(256);

            case 'uint16'
              mp = gray(2^16);

            case {'double','single'}
              cmapsz = size(get(handles.ImageViewer, 'Colormap'), 1);
              mp = gray(cmapsz);

            case 'int16'
              x = double(x)+2^15;
              x = uint16((x-min(x(:)))/(max(x(:))-min(x(:)))*(2^16));
              mp = gray(2^16);

            otherwise
              cmapsz = size(get(handles.ImageViewer, 'Colormap'), 1);
              mp = gray(cmapsz);
          end
          x = ind2rgb(x, mp);

        case 'indexed'
          if isempty(mp)
            mp = info.Colormap;
          end
          x = ind2rgb(x, mp);

        otherwise
      end

    catch
      x = NaN;
      info = [];

    end
  end

end
