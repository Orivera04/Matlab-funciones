function interactivemouse(varargin)

%INTERACTIVEMOUSE   Interactive exploration of figures using a mouse.
%   INTERACTIVEMOUSE toggles the interactive mode of the current figure.
%   INTERACTIVEMOUSE ON turns on the interactive mode.
%   INTERACTIVEMOUSE OFF turns off the interactive mode.
%   INTERACTIVEMOUSE RESET sets the 'restore point' to the current view.
%   INTERACTIVEMOUSE RESTORE restores the view to the 'restore point'. The
%     'restore point' is predefined as the original view, unless the
%     current view is set as the 'restore point' with RESET.
%   INTERACTIVEMOUSE RESTORE_ORIG restores the view to the original view
%     (the view before INTERACTIVEMOUSE was initially called on this
%     figure). This 'restore point' is fixed regardless of whether RESET
%     was called or not.
%
%   INTERACTIVEMOUSE(FIG) and INTERACTIVEMOUSE(FIG, OPTION) applies to the
%     figure specified by handle FIG. FIG can be a vector of figure
%     handles. OPTION can be any of the above arguments. The figure(s) can
%     have multiple axes.
%
%   The following features are included in the interactive mode:
%     Pan          : click and drag.
%     Zoom         : right click (or CNTRL-click) and drag.
%     Center View  : double click.
%     Reset View   : <r> with the cursor over the axes region. This resets
%                    'restore point'. (see above note about RESET option)
%     Restore View : <space> with the cursor over the axes region. This
%                    restores to the 'restore point'. (see above note about
%                    RESTORE option)
%     Help window  : <h>
%     Exit mode    : <escape>
%
%   Note about Zoom Feature:
%    (2D views) : the zoom ratio depends on the location of the pointer
%                 with respect to the initial click location. Pressing the
%                 <shift> key ONCE toggles the constrained mode. In
%                 CONSTRAINED mode, the zoom ratio is constrained along
%                 x-axis, y-axis, or xy-axes depending on the pointer
%                 location. The figure window title indicates that
%                 constraint mode is active. If the axes
%                 DataAspectRatioMode is MANUAL, the zoom will always be
%                 constrained to preserve the specified aspect ratio
%                 (PROPORTIONAL mode). This is for working with images.
%                    
%    (3D views) : the zoom is always xyz-constrained (PROPORTIONAL). The
%                 aspect ratios are always preserved.
%
%   In the interactive mode, several figure and axes properties are set,
%   but the current properties are restored when the interactive mode is
%   exited. During interactive mode, the figure name changes to
%   'InteractiveMouse', and the figure is undocked (certain features
%   don't work in docked mode). This works with 2D plots, images, and 3D
%   plots (for the most part).
%   
%   Examples:
%   % Interactively examine high frequency noise
%     x=0:.001:10;
%     y=sin(x)+.01*rand(size(x));
%     plot(x,y)
%     interactivemouse;
%
%   % Multiple axes
%     load clown;
%     subplot(211);image(X);colormap(map);axis image;
%     subplot(212);plot(rand(100,1), '.-');
%     interactivemouse;
%
%   % Use LINKAXES to link multiple axes. (>R13)
%     ax(1)=subplot(211);plot(rand(100,1), 'r.-');
%     ax(2)=subplot(212);plot(rand(100,1), '.-');
%     linkaxes(ax);
%     interactivemouse;
%
%   See also ZOOM, PAN, LINKAXES

%   VERSIONS:
%     v1.0 - first version.
%     v1.1 - minor changes: indicate mode in title
%     v2.0 - constrained zooming based on the movement of the mouse. red
%            indicator line shows the type of zoom
%     v3.0 - allow unconstrained zoom. <shift> key toggles constrained
%            mode. (April 8, 2006)
%     v3.1 - fix aspect ratio bug (April 9, 2006)
%     v3.2 - fix more aspect ratio bugs (April 10, 2006)
%     v3.2.1 - optimize code. clean up documentation. fix ticklabel jitter
%              bug. (April 11, 2006)
%     v3.2.2 - fix help documentation. change the speed of animation during
%              centering and view restoring. add title bar indication for
%              view centering and view restoring. (April 11, 2006)
%     v3.3 - fix bug when calling RESET from command line. Preserve aspect
%            ratio when the DataAspectRatioMode is MANUAL. This makes sense
%            when dealing with images. Display zoom factor on the graph
%            (April 12, 2006)
%     v3.3.1 - the zoom factor displayed on the graph is in relation to the
%              original figure size, as opposed to the current figure size.
%              Make the "invisible axes" actually invisible. Modify help
%              text. (April 14, 2006)
%
%   The author would like to thank Don Riley for helpful comments in
%   improving this code.
%
%   Created in R13
%   Tested up to R2006a
%
%   Jiro Doke
%   March 30, 2006

error(nargchk(0, 2, nargin));

% Default values
opt_all = {'on', 'off', 'reset', 'restore', 'restore_orig'};
opt     = 'toggle';
fH      = get(0, 'currentfigure');

% Error checking and input argument parsing
if nargin > 0
  if nargin == 1

    % A single input must either be NUMERIC (handles) or CHAR (options)
    if ~ischar(varargin{1}) && ~isnumeric(varargin{1})
      error(sprintf('%s:BadInput', mfilename), ...
        'Input must either be figure handles or an optional argument.');
    end

  else

    % One input must be NUMERIC and the other must be CHAR
    if ~(ischar(varargin{1}) && isnumeric(varargin{2})) && ...
        ~(isnumeric(varargin{1}) && ischar(varargin{2}))
      error(sprintf('%s:BadInputs', mfilename), ...
        'Input must be figure handles and an optional argument.');
    end

  end

  % Parse through input arguments
  for iArg = 1:nargin
    var = varargin{iArg};
    if ischar(var)

      % Input must be one of the allowed options
      id = strmatch(lower(var), opt_all, 'exact');
      if isempty(id)
        error(sprintf('%s:BadOption', mfilename), ...
          'Invalid optional argument.');
      else
        opt = opt_all{id};
      end

    else  % isnumeric(var)

      fH = var(:);
      
      % Input must be figure handles
      if ~all(ishandle(fH)) || ...
          ~isequal(unique(cellstr(get(fH, 'type'))), {'figure'})
        error(sprintf('%s:BadHandle', mfilename), ...
          'Invalid figure handle.');
      end

    end
  end

end

% Exit if there are no figures
if isempty(fH)
  return;
end

figProps = {...
  'name', ...
  'doublebuffer', ...
  'keypressfcn', ...
  'interruptible', ...
  'busyaction', ...
  'windowbuttonupfcn', ...
  'windowbuttondownfcn', ...
  'windowbuttonmotionfcn', ...
  'windowstyle', ...
  'pointershapecdata', ...
  'pointershapehotspot', ...
  'pointer'};

axLims = {...
  'xlim', ...
  'ylim', ...
  'zlim', ...
  'cameraviewangle', ...
  'dataaspectratio', ...
  'plotboxaspectratio', ...
  'xtick', ...
  'xticklabel', ...
  'ytick', ...
  'yticklabel', ...
  'ztick', ...
  'zticklabel'};

axModeProps = {...
  'cameraviewanglemode', ...
  'dataaspectratiomode', ...
  'plotboxaspectratiomode', ...
  'xlimmode', ...
  'xtickmode', ...
  'xticklabelmode', ...
  'ylimmode', ...
  'ytickmode', ...
  'yticklabelmode', ...
  'zlimmode', ...
  'ztickmode', ...
  'zticklabelmode'};

axProps = {...
  'hittest', ...
  'buttondownfcn', ...
  'interruptible', ...
  'busyaction', ...
  'visible', ...
  'xcolor', ...
  'ycolor', ...
  'zcolor'};

% Work with each figure
for iFig = 1:length(fH)
  figH = fH(iFig);

  % See if figMouseInteractInfo exists. If it does, the figure is already
  % in interact mode
  stuff = getappdata(figH, 'figMouseInteractInfo');

  switch opt
    case 'on'
      init = true;
    case 'off'
      init = false;
    case 'toggle'
      if isempty(stuff)
        init = true;
      else
        init = false;
      end
  end

  % Get all axes in the figure
  axH = findobj(figH, 'type', 'axes');

  % Do not work with legend axes, and go to next figure if there are no
  % valid axes.
  if isempty(axH)
    continue;
  else
    id = strmatch('legend', cellstr(get(axH, 'tag')), 'exact');
    axH(id) = [];
    if isempty(axH)
      continue;
    end
  end

  % Bring figure into focus
  figure(figH);

  % Work with each axes
  for iAx = 1:length(axH)
    
    if ismember(opt, {'reset', 'restore', 'restore_orig'})
      resetRestoreAxes(axH(iAx), opt);

    else

      if init
        % Store and set current axes properties
        axstuff.axProp = get(axH(iAx), axProps);
        origAx.axLims  = get(axH(iAx), axLims);
        origAx.modes   = get(axH(iAx), axModeProps);
        
        % Treat different combinations of aspect ratios appropriately. For
        % auto settings, let Matlab do its thing. For others, make sure the
        % axes box remains fixed.
        ratioModes = get(axH(iAx), ...
          {'cameraviewanglemode', ...
          'dataaspectratiomode', ...
          'plotboxaspectratiomode'});
        
        if strcmpi(ratioModes{2}, 'manual')
          setappdata(axH(iAx), 'fixedDataAspectRatio', true);
        else
          setappdata(axH(iAx), 'fixedDataAspectRatio', false);
        end
        
        if isequal(ratioModes, {'auto', 'auto', 'auto'})
          % Let Matlab take care of aspect ratios
          ratioArgs = {...
            'cameraviewanglemode'   , 'auto', ...
            'dataaspectratiomode'   , 'auto', ...
            'plotboxaspectratiomode', 'auto'};
        elseif strcmpi(ratioModes{1}, 'manual')
          % Make sure the box size is fixed
          ratioArgs = {...
            'cameraviewangle'     , get(axH(iAx), 'cameraviewangle'), ...
            'dataaspectratiomode' , 'auto', ...
            'plotboxaspectratio'  , get(axH(iAx), 'plotboxaspectratio')};
        else
          % Make sure the box size is fixed
          ratioArgs = {...
            'cameraviewanglemode' , 'auto', ...
            'dataaspectratiomode' , 'auto', ...
            'plotboxaspectratio'  , get(axH(iAx), 'plotboxaspectratio')};
        end
        
        set(axH(iAx), ...
          axProps, ...
          {'on', ...
          {@winBtnDownFcn, figH}, ...
          'off', ...
          'queue', ...
          'on', ...
          'k', ...
          'k', ...
          'k'});
        
        % Set axes children's HitTest property to off
        % The ButtonDownFcn will be set to the axes, so make all axes
        % children unHittable.
        axstuff.chhittest = get(get(axH(iAx), 'children'), 'hittest');
        set(get(axH(iAx), 'children'), 'hittest', 'off');

        % Store axes properties
        setappdata(axH(iAx), 'axesMouseInteractInfo', axstuff);
        setappdata(axH(iAx), 'ratioArgs', ratioArgs);
        
        % Store axes limits as original view and 'restore point'
        if ~isappdata(axH(iAx), 'origAx')
          setappdata(axH(iAx), 'origAx', origAx);
          setappdata(axH(iAx), 'veryfirstAx', origAx);
        end

      else
        % Retrieve axes properties
        axstuff = getappdata(axH(iAx), 'axesMouseInteractInfo');

        if ~isempty(axstuff)
          % Restore axes and children properties
          set(get(axH(iAx), 'children'), ...
            {'hittest'}, cellstr(axstuff.chhittest));
          set(axH(iAx), axProps, axstuff.axProp);

          % Remove stored property data
          rmappdata(axH(iAx), 'axesMouseInteractInfo');
          rmappdata(axH(iAx), 'fixedDataAspectRatio');

        end

      end

    end

  end

  if ~ismember(opt, {'reset', 'restore', 'restore_orig'})
    
    if init

      % Store current figure properties
      stuff = get(figH, figProps);

      % Set figure properties
      set(figH, figProps, ...
        {upper(mfilename), ...
        'on', ...
        {@keyPressFcn, axH}, ...
        'off', ...
        'queue', ...
        @winBtnUpFcn, ...
        '', ...
        '', ...
        'normal', ...
        stuff{end-2}, ...
        [8, 8], ...
        stuff{end}});

      % Store figure properties
      setappdata(figH, 'figMouseInteractInfo', stuff);
      setappdata(figH, 'figUnits', get(figH, 'units'));

    else

      if ~isempty(stuff)
        % Restore figure properties
        set(figH, figProps, stuff);

        % Remove stored property data
        rmappdata(figH, 'figMouseInteractInfo');
      end
    end
  end

end


%--------------------------------------------------------------------------
% resetRestoreAxes
%--------------------------------------------------------------------------
function resetRestoreAxes(axH, opt)
%   This resets or restores the view.
%   RESET sets the current view as the 'restore point'.
%   RESTORE restores the view to the 'restore point'.
%   RESTORE_ORIG restores to the original view.

axLims = {...
  'xlim', ...
  'ylim', ...
  'zlim', ...
  'cameraviewangle', ...
  'dataaspectratio', ...
  'plotboxaspectratio', ...
  'xtick', ...
  'xticklabel', ...
  'ytick', ...
  'yticklabel', ...
  'ztick', ...
  'zticklabel'};

axModeProps = {...
  'cameraviewanglemode', ...
  'dataaspectratiomode', ...
  'plotboxaspectratiomode', ...
  'xlimmode', ...
  'xtickmode', ...
  'xticklabelmode', ...
  'ylimmode', ...
  'ytickmode', ...
  'yticklabelmode', ...
  'zlimmode', ...
  'ztickmode', ...
  'zticklabelmode'};

switch opt
  case 'reset'
    
    titleString = get(get(axH, 'parent'), 'name');
    set(get(axH, 'parent'), ...
      'name', sprintf('%s: Resetting Restore Point', upper(mfilename)));
    
    % Store the current axes limits
    origAx        = getappdata(axH, 'origAx');
    origAx.axLims = get(axH, axLims);
    if ~isappdata(axH, 'origAx');
      % No axes info stored, so also get mode properties
      origAx.modes  = get(axH, axModeProps);
      
      % Also save as the first axes info
      setappdata(axH, 'veryfirstAx', origAx);
    end
    
    setappdata(axH, 'origAx', origAx);
    
    % Flash the axes to cue the user that the view has been reset.
    axW = get(axH, 'linewidth');
    for iL = 1:3
      set(axH, ...
        'linewidth' , 5, ...
        'xcolor'    , 'r', ...
        'ycolor'    , 'r', ...
        'zcolor'    , 'r');
      pause(0.2);
      
      set(axH, ...
        'linewidth' , axW, ...
        'xcolor'    , 'k', ...
        'ycolor'    , 'k', ...
        'zcolor'    , 'k');
      pause(0.2);
    end

    set(get(axH, 'parent'), 'name', titleString);

  case {'restore', 'restore_orig'}
    if strcmp(opt, 'restore_orig')
      origRestore = true;
    else
      origRestore = false;
    end
    
    if origRestore
      % See if original view is stored
      origAx = getappdata(axH, 'veryfirstAx');
    else
      % See if 'restore point' exists
      origAx = getappdata(axH, 'origAx');
    end

    ratioArgs = getappdata(axH, 'ratioArgs');
    
    if ~isempty(origAx)
      xl = xlim(axH); xd = (origAx.axLims{1} - xl)/10;
      yl = ylim(axH); yd = (origAx.axLims{2} - yl)/10;
      zl = zlim(axH); zd = (origAx.axLims{3} - zl)/10;
      
      % Restore only if needed
      if ~(isequal(xd, [0 0]) && isequal(yd, [0 0]) && isequal(zd, [0 0]))
        
        titleString = get(get(axH, 'parent'), 'name');
        set(get(axH, 'parent'), ...
          'name', sprintf('%s: Restoring View...', upper(mfilename)));

        % Animate restore
        for id = [1, 4, 6.5, 7.8, 8.5, 9, 9.3, 9.6, 9.8, 10]

          set(axH, ...
            'xlim'          , xl + xd * id, ...
            'ylim'          , yl + yd * id, ...
            'zlim'          , zl + zd * id, ...
            'xtickmode'     , 'auto', ...
            'xticklabelmode', 'auto', ...
            'ytickmode'     , 'auto', ...
            'yticklabelmode', 'auto', ...
            'ztickmode'     , 'auto', ...
            'zticklabelmode', 'auto');

          if ~isempty(ratioArgs)
            set(axH, ratioArgs{:});
          end

          pause(0.01);
        end

        % Set aspect ratios
        if ~isempty(ratioArgs)
          set(axH, ratioArgs{:});
        end

        if origRestore
          % Restore original axes modes
          set(axH, axLims, origAx.axLims);
          set(axH, axModeProps, origAx.modes);

          % Overwrite current 'restore point'
          setappdata(axH, 'origAx', origAx);
        end

        set(get(axH, 'parent'), 'name', titleString);
        
      end
      
    else
      % If not, set current view as the 'restore point'
      origAx.axLims = get(axH, axLims);
      origAx.modes  = get(axH, axModeProps);
      setappdata(axH, 'origAx', origAx);
      
      if origRestore
        % Also set the first view
        setappdata(axH, 'veryfirstAx', origAx);
      end

    end

end


%--------------------------------------------------------------------------
% keyPressFcn
%--------------------------------------------------------------------------
function keyPressFcn(varargin)
%   The figure accepts 4 types of key presses.
%     <shift> to toggle constrained zoom mode (only in zoom)
%     <r> to reset view.
%     <space> to restore view.
%     <escape> to exit interactive mode.
%     <h> to display help window.

[obj, axH] = splitvar(varargin([1, 3]));

k = get(obj, 'currentkey');

switch k
  
  case 'shift'
    % Toggle constrained zoom mode
    
    wbmf = get(obj, 'windowbuttonmotionfcn');

    if length(wbmf) == 11 && ...  % zoom mode
        ~any(isnan(wbmf{end-3}))  % 2D view
      
      % toggle mode
      wbmf{end-1} = ~wbmf{end-1};
      set(obj, 'windowbuttonmotionfcn', wbmf);
      
    end
  
  case {'r', 'space'}
    % Reset or Restore view

    un = get([0; obj; axH], 'units');
    set([0; obj; axH], 'units', 'pixels');

    p  = get(0  , 'pointerlocation');
    fp = get(obj, 'position');
    fa = get(axH, 'position');
    if iscell(fa)
      fa = vertcat(fa{:});
    end
    set([0; obj; axH], {'units'}, un);

    % Determine whether the cursor is over a particular axes
    axRng = fa(:,[1 2 1 2]) + repmat(fp([1 2 1 2]), size(fa, 1), 1) + ...
      [zeros(size(fa, 1), 2), fa(:,3:4)];

    iAx = find(...
      p(1) > axRng(:, 1) & ...
      p(1) < axRng(:, 3) & ...
      p(2) > axRng(:, 2) & ...
      p(2) < axRng(:, 4));
    
    if ~isempty(iAx)
      switch k
        case 'r'
          resetRestoreAxes(axH(iAx), 'reset');
          
        case 'space'
          resetRestoreAxes(axH(iAx), 'restore');
   
      end
    end

  case 'escape'
    % Exit Interactive Mode

    btn = questdlg({sprintf('Exit %s?', upper(mfilename)), ...
      'The current view will be kept.', ...
      sprintf('Use ''%s RESTORE'' to restore view.', upper(mfilename))}, ...
      sprintf('Exit %s', upper(mfilename)), ...
      'Yes', 'No', 'Yes');

    switch btn
      case 'Yes'
        interactivemouse(obj, 'off');
    end

  case 'h'
    % Display help window

    helpdlg({'PANNING: click and drag', ...
      'ZOOMING: right click and drag. For 2D views, press <shift> to activate constrained zooming', ...
      'CENTERING: double click', ...
      'RESET RESTORE POINT: <r> with the cursor over the axes region', ...
      'RESTORE VIEW: <space> with the cursor over the axes region', ...
      'HELP WINDOW: <h>', ...
      'EXIT MODE: <escape>'}, ...
      sprintf('%s Help Window', upper(mfilename)));
    
end


%--------------------------------------------------------------------------
% winBtnUpFcn
%--------------------------------------------------------------------------
function winBtnUpFcn(varargin)
%   This is called when the mouse is released

obj = varargin{1};

stuff    = getappdata(obj, 'figMouseInteractInfo');
figUnits = getappdata(obj, 'figUnits');
set(obj, ...
  'name'                  , upper(mfilename), ...
  'units'                 , figUnits, ...
  'pointer'               , stuff{end}, ...
  'windowbuttonmotionfcn' , '');

delete(findobj('type', 'axes', 'tag', 'invisibleAxes'));

%--------------------------------------------------------------------------
% winBtnDownFcn
%--------------------------------------------------------------------------
function winBtnDownFcn(varargin)
%   This is called when the mouse is clicked in one of the axes
%   NORMAL clicks will start panning mode.
%   ALT clicks will start zooming mode.
%   OPEN clicks will center the view.

[obj, figH] = splitvar(varargin([1, 3]));

switch get(figH, 'selectiontype')
  case 'normal'
    % Start panning mode

    closedHandPointer = [
      NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
      NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
      NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
      NaN   NaN   NaN   NaN     2     2   NaN     2     2   NaN     2     2   NaN   NaN   NaN   NaN
      NaN   NaN   NaN     2     1     1     2     1     1     2     1     1     2     2   NaN   NaN
      NaN   NaN     2     1     2     2     1     2     2     1     2     2     1     1     2   NaN
      NaN   NaN     2     1     2     2     2     2     2     2     2     2     1     2     1     2
      NaN   NaN   NaN     2     1     2     2     2     2     2     2     2     2     2     1     2
      NaN   NaN     2     1     1     2     2     2     2     2     2     2     2     2     1     2
      NaN     2     1     2     2     2     2     2     2     2     2     2     2     2     1     2
      NaN     2     1     2     2     2     2     2     2     2     2     2     2     2     1     2
      NaN     2     1     2     2     2     2     2     2     2     2     2     2     1     2   NaN
      NaN   NaN     2     1     2     2     2     2     2     2     2     2     2     1     2   NaN
      NaN   NaN   NaN     2     1     2     2     2     2     2     2     2     1     2   NaN   NaN
      NaN   NaN   NaN   NaN     2     1     2     2     2     2     2     2     1     2   NaN   NaN
      NaN   NaN   NaN   NaN     2     1     2     2     2     2     2     2     1     2   NaN   NaN
      ];

    pt = get(obj, 'currentpoint');
    
    set(figH, ...
      'pointer'               , 'custom', ...
      'pointershapecdata'     , closedHandPointer, ...
      'windowbuttonmotionfcn' , ...
      {@winBtnMotionFcn, obj, mean(pt), getappdata(obj, 'ratioArgs')});

  case 'alt'
    % Start zooming mode
    
    set(figH, 'units', 'pixels');

    xl = get(obj, 'xlim'); midX = mean(xl); rngXhalf = diff(xl) / 2;
    yl = get(obj, 'ylim'); midY = mean(yl); rngYhalf = diff(yl) / 2;
    zl = get(obj, 'zlim'); midZ = mean(zl); rngZhalf = diff(zl) / 2;
    
    figPos = get(figH, 'position');

    curPt  = mean(get(obj, 'currentpoint'));
    curPt2 = (curPt-[midX, midY, midZ]) ./ [rngXhalf, rngYhalf, rngZhalf];
    curPt  = [curPt; curPt];
    
    curPt2 = [-(1+curPt2).*[rngXhalf, rngYhalf, rngZhalf];...
      (1-curPt2).*[rngXhalf, rngYhalf, rngZhalf]];
    
    axes(...
      'units'   , 'normalized', ...
      'position', [0 0 1 1], ...
      'box'     , 'on', ...
      'xlim'    , [0 1], ...
      'xtick'   , [], ...
      'ylim'    , [0 1], ...
      'ytick'   , [], ...
      'visible' , 'off', ...
      'tag'     , 'invisibleAxes');
    
    figPt = get(figH, 'currentpoint');    
    
    hText = text(figPt(1) / figPos(3), figPt(2) / figPos(4), ...
      ''                , ...
      'margin'          , 0.1, ...
      'fontunits'       , 'points', ...
      'fontsize'        , 8, ...
      'fontweight'      , 'bold', ...
      'color'           , 'r');

    hLine = line(figPt(1) / figPos(3), figPt(2) / figPos(4), ...
      'linestyle' , '--', ...
      'linewidth' , 2, ...
      'color'     , 'r');
    
    % Determine type of zoom (Free or Proportional)
    % OPT = NAN means proportional.
    if getappdata(obj, 'fixedDataAspectRatio')
    
      % Fixed DataAspectRatio, so do proportional zooming
      opt = NaN;
    
    else
      v = get(obj, 'view');
      if ~isequal(v, fix(v))
        % If v is not a whole number, then it's not a 2D view
        opt = NaN;

      else
        v = round(mod(abs(v / 90), 2) * 90);
        if isequal(v(:), [0;90])
          opt = [1 2];
        elseif isequal(v(:), [90;90])
          opt = [2 1];
        elseif isequal(v(:), [0;0])
          opt = [1 3];
        elseif isequal(v(:), [90;0])
          opt = [2 3];
        else
          opt = NaN;
        end

      end

    end

    % get original axes ranges (for displaying zoom factors)
    origAx = getappdata(obj, 'veryfirstAx');
    rngs = diff(vertcat(origAx.axLims{1:3}), 1, 2);
    
    set(figH, ...
      'windowbuttonmotionfcn' , ...
      {@zoomMotionFcn, ...
      obj, ...
      figPt, ...
      figPos, ...
      curPt, ...
      curPt2, ...
      [hLine, hText], ...
      opt, ...
      getappdata(obj, 'ratioArgs'), ...
      false, ...
      rngs});

  case 'open'
    % Center the view

    ratioArgs = getappdata(obj, 'ratioArgs');

    % Get current units
    un = get([0, figH, obj], 'units');

    pt = get(obj, 'currentpoint');

    set([0, figH, obj], 'units', 'pixels');
    pt2    = get(0    , 'pointerlocation');
    figPos = get(figH , 'position');
    axPos  = get(obj  , 'position');

    xl = get(obj, 'xlim'); midX = mean(xl);
    yl = get(obj, 'ylim'); midY = mean(yl);
    zl = get(obj, 'zlim'); midZ = mean(zl);

    % get distance between cursor and center of axes
    d = norm(pt2 - (figPos(1:2) + axPos(1:2) + axPos(3:4)/2));
    if d > 2  % center only if distance is at least 2 pixels away
      ld = (mean(pt) - [midX, midY, midZ]) / 10;
      pd = ((figPos(1:2) + axPos(1:2) + axPos(3:4) / 2) - pt2) / 10;

      set(figH, ...
        'name', sprintf('%s: Centering...', upper(mfilename)));

      for id = [1, 4, 6.5, 7.8, 8.5, 9, 9.3, 9.6, 9.8, 10]

        % Set axes limits and automatically set ticks
        % Set aspect ratios
        set(obj, ...
          'xlim'          , xl + id * ld(1), ...
          'ylim'          , yl + id * ld(2), ...
          'zlim'          , zl + id * ld(3), ...
          'xtickmode'     , 'auto', ...
          'xticklabelmode', 'auto', ...
          'ytickmode'     , 'auto', ...
          'yticklabelmode', 'auto', ...
          'ztickmode'     , 'auto', ...
          'zticklabelmode', 'auto', ...
          ratioArgs{:});

        % Move pointer with limits
        set(0, 'pointerlocation', pt2 + id * pd);

        pause(0.01);
      end

    end

    % Reset UNITS
    set([0, figH, obj], {'units'}, un);

end


%--------------------------------------------------------------------------
% zoomMotionFcn
%--------------------------------------------------------------------------
function zoomMotionFcn(varargin)
%   This performs the click-n-drag zooming function. The pointer location
%   relative to the initial point determines the amount of zoom (in or
%   out).

persistent zoomInOutPointer rPointer urPointer uPointer 
persistent ulPointer lPointer llPointer dPointer lrPointer

% Power law allows for the inverse to work:
%      C^(x) * C^(-x) = 1
% Choose C to get "appropriate" zoom factor
C = 50;

if isempty(zoomInOutPointer)
  % Define persistent variables (PointerShapeCData)
  [zoomInOutPointer, rPointer, urPointer, ...
    uPointer, ulPointer, lPointer, ...
    llPointer, dPointer, lrPointer] = getPointerCData;
end

[obj, axH, initPt, figPos, curPt, curPt2, hLineText, opt, ...
  ratioArgs, constrainedZoom, origRngs] = splitvar(varargin([1, 3:end]));

pt = get(obj, 'currentpoint');

if all(isnan(opt))   % 3D view

  r          = C ^ ((initPt(2) - pt(2)) / figPos(4));
  newLimSpan   = r.*curPt2; dTemp = diff(newLimSpan);
  pt(1)      = initPt(1);
  textString = sprintf(' %d %%', round(origRngs(1)/dTemp(1)*100));
  alignments = {'left', 'middle'};
  ptr        = zoomInOutPointer;

  proportionalZoom = true;

else                 % 2D view
  
  proportionalZoom = false;
  
  r = ones(2, 3);
  axesNames = {'X', 'Y', 'Z'};

  if ~constrainedZoom
    % Zoom based on location of pointer

    xR           = C ^ ((initPt(1) - pt(1)) / figPos(3));
    yR           = C ^ ((initPt(2) - pt(2)) / figPos(4));
    r(:, opt(1)) = xR;
    r(:, opt(2)) = yR;
    newLimSpan   = r.*curPt2; dTemp = diff(newLimSpan);
    tS           = {axesNames{opt}; ...
      round(origRngs(1)/dTemp(1)*100), round(origRngs(2)/dTemp(2)*100)};
    textString   = sprintf('%c %d %%\n%c %d %%', tS{:});
    alignments   = {'center', 'middle'};
    ptr          = zoomInOutPointer;
    
  else
    % Perform constrained zooming, based on location of pointer
    
    n  = norm(initPt - pt);
    a  = atan2(pt(2) - initPt(2), pt(1) - initPt(1));
    a2 = sign(a) * ceil(abs(a) / (pi / 8));
    a3 = pi/4*round(a/(pi/4));

    switch a2
      case {2, 3, 6, 7, -2, -3, -6, -7} % horizontal & vertical axes
        if abs(initPt(1) - pt(1)) > abs(initPt(2) - pt(2))
          b1 = initPt(1) - pt(1);
          b2 = sign(initPt(2) - pt(2)) * abs(b1);
        else
          b2 = initPt(2) - pt(2);
          b1 = sign(initPt(1) - pt(1)) * abs(b2);
        end
        xR           = C ^ (b1 / figPos(4));
        yR           = C ^ (b2 / figPos(4));
        r(:, opt(1)) = xR;
        r(:, opt(2)) = yR;
        newLimSpan   = r.*curPt2; dTemp = diff(newLimSpan);
        pt           = initPt + [n * cos(a3), n * sin(a3)];
        tS           = {axesNames{opt}; ...
          round(origRngs(1)/dTemp(1)*100), round(origRngs(2)/dTemp(2)*100)};
        textString   = sprintf('%c %d %%\n%c %d %%', tS{:});
        switch a2
          case {2, 3}
            alignments = {'right', 'bottom'};
            ptr        = urPointer;
          case {-6, -7}
            alignments = {'right', 'bottom'};
            ptr        = llPointer;
          case {-2, -3}
            alignments = {'left', 'bottom'};
            ptr        = lrPointer;
          case {6, 7}
            alignments = {'left', 'bottom'};
            ptr        = ulPointer;
        end

      case {0, -1, 1, 8, -8}  % horizontal axes
        xR           = C ^ ((initPt(1) - pt(1)) / figPos(4));
        r(:, opt(1)) = xR;
        newLimSpan   = r.*curPt2; dTemp = diff(newLimSpan);
        pt(2)        = initPt(2);
        textString   = sprintf('%c %d %%', ...
          axesNames{opt(1)}, round(origRngs(1)/dTemp(1)*100));
        alignments   = {'center', 'bottom'};
        if ismember(a2, [0, -1, 1])
          ptr        = rPointer;
        else
          ptr        = lPointer;
        end
      
      case {4, 5, -4, -5}     % vertical axes
        yR = C ^ ((initPt(2) - pt(2)) / figPos(4));
        r(:, opt(2)) = yR;
        newLimSpan   = r.*curPt2; dTemp = diff(newLimSpan);
        pt(1)        = initPt(1);
        textString   = sprintf(' %c %d %%', ...
          axesNames{opt(2)}, round(origRngs(2)/dTemp(2)*100));
        alignments   = {'left', 'middle'};
        if ismember(a2, [4, 5])
          ptr        = uPointer;
        else
          ptr        = dPointer;
        end

    end

  end
  
end

% Determine new limits based on r
lims = curPt + newLimSpan;

% Update axes limits and automatically set ticks
% Set aspect ratios
set(axH, ...
  'xlim'          , lims(:,1), ...
  'ylim'          , lims(:,2), ...
  'zlim'          , lims(:,3), ...
  'xtickmode'     , 'auto', ...
  'xticklabelmode', 'auto', ...
  'ytickmode'     , 'auto', ...
  'yticklabelmode', 'auto', ...
  'ztickmode'     , 'auto', ...
  'zticklabelmode', 'auto', ...
  ratioArgs{:});

% Update zoom indicator line
set(hLineText(1), ...
  'xdata', [initPt(1), pt(1)]/figPos(3), ...
  'ydata', [initPt(2), pt(2)]/figPos(4));

% Update zoom indicator text
set(hLineText(2), ...
  'string'              , textString, ...
  'horizontalalignment' , alignments{1}, ...
  'verticalalignment'   , alignments{2});

% Update zoom pointer
set(obj, ...
  'pointer'           , 'custom', ...
  'pointershapecdata' , ptr);

% Show appropriate title
if constrainedZoom
  set(obj, ...
    'name', sprintf('%s: Zooming... (Constrained)', upper(mfilename)));
elseif proportionalZoom
  set(obj, ...
    'name', sprintf('%s: Zooming... (Proportional)', upper(mfilename)));
else
  set(obj, ...
    'name', sprintf('%s: Zooming... (Free)', upper(mfilename)));
end


%--------------------------------------------------------------------------
% winBtnMotionFcn
%--------------------------------------------------------------------------
function winBtnMotionFcn(varargin)
%   This function is called when click-n-drag (panning) is happening

[obj, axH, xyz, ratioArgs] = splitvar(varargin([1, 3:5]));

pt = get(axH, 'currentpoint');

% Update axes limits and automatically set ticks
% Set aspect ratios
set(axH, ...
  'xlim'          , get(axH, 'xlim') + (xyz(1)-(pt(1,1)+pt(2,1))/2), ...
  'ylim'          , get(axH, 'ylim') + (xyz(2)-(pt(1,2)+pt(2,2))/2), ...
  'zlim'          , get(axH, 'zlim') + (xyz(3)-(pt(1,3)+pt(2,3))/2), ...
  'xtickmode'     , 'auto', ...
  'xticklabelmode', 'auto', ...
  'ytickmode'     , 'auto', ...
  'yticklabelmode', 'auto', ...
  'ztickmode'     , 'auto', ...
  'zticklabelmode', 'auto', ...
  ratioArgs{:});

set(obj, ...
  'name', sprintf('%s: Panning...', upper(mfilename)));


%--------------------------------------------------------------------------
% splitvar
%--------------------------------------------------------------------------
function varargout = splitvar(varargout)
%   This internal function deals cell elements to individual variables.


%--------------------------------------------------------------------------
% getPointerCData
%--------------------------------------------------------------------------
function [zoomInOutPointer, rPointer, urPointer, ...
  uPointer, ulPointer, lPointer, ...
  llPointer, dPointer, lrPointer] = getPointerCData
%   This function returns the different PointerShapeCData

% Custom zoom pointer
zoomInOutPointer = [
  NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
  NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN     2     2   NaN   NaN   NaN   NaN   NaN
  NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN     2     1     1     2   NaN   NaN   NaN   NaN
  NaN   NaN   NaN   NaN   NaN   NaN   NaN     2     2     1     1     2     2   NaN   NaN   NaN
  NaN   NaN   NaN   NaN   NaN   NaN     2     1     1     1     1     1     1     2   NaN   NaN
  NaN   NaN   NaN   NaN   NaN   NaN     2     1     1     1     1     1     1     2   NaN   NaN
  NaN   NaN   NaN   NaN   NaN   NaN   NaN     2     2     1     1     2     2   NaN   NaN   NaN
  NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN     2     1     1     2   NaN   NaN   NaN   NaN
  NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN     2     2   NaN   NaN   NaN   NaN   NaN
  NaN   NaN     2     2     2     2     2     2   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
  NaN     2     1     1     1     1     1     1     2   NaN   NaN   NaN   NaN   NaN   NaN   NaN
  NaN     2     1     1     1     1     1     1     2   NaN   NaN   NaN   NaN   NaN   NaN   NaN
  NaN   NaN     2     2     2     2     2     2   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
  NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
  NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
  NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
  ];

% Right zoom pointer
rPointer = [
  NaN   NaN   NaN   NaN   NaN     2     2   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
  NaN   NaN   NaN   NaN     2     1     1     2   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
  NaN   NaN   NaN     2     2     1     1     2     2   NaN   NaN   NaN   NaN   NaN   NaN   NaN
  NaN   NaN     2     1     1     1     1     1     1     2   NaN   NaN   NaN   NaN   NaN   NaN
  NaN   NaN     2     1     1     1     1     1     1     2   NaN   NaN   NaN   NaN   NaN   NaN
  NaN   NaN   NaN     2     2     1     1     2     2   NaN   NaN   NaN   NaN   NaN   NaN   NaN
  NaN   NaN   NaN   NaN     2     1     1     2   NaN   NaN     2     2   NaN   NaN   NaN   NaN
  NaN   NaN   NaN   NaN   NaN     2     2   NaN   NaN     2     1     1     2   NaN   NaN   NaN
  NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN     2     1     1     1     2   NaN   NaN
  NaN   NaN   NaN     2     2     2     2     2     2     2     2     1     1     1     2   NaN
  NaN   NaN     2     1     1     1     1     1     1     1     1     1     1     1     1     2
  NaN   NaN     2     1     1     1     1     1     1     1     1     1     1     1     1     2
  NaN   NaN   NaN     2     2     2     2     2     2     2     2     1     1     1     2   NaN
  NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN     2     1     1     1     2   NaN   NaN
  NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN     2     1     1     2   NaN   NaN   NaN
  NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN     2     2   NaN   NaN   NaN   NaN
  ];

% Upper right zoom pointer
urPointer = [
  NaN   NaN   NaN     2     2   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
  NaN   NaN     2     1     1     2   NaN   NaN     2     2     2     2     2     2     2   NaN
  NaN     2     2     1     1     2     2     2     1     1     1     1     1     1     2   NaN
    2     1     1     1     1     1     1     2     1     1     1     1     1     1     2   NaN
    2     1     1     1     1     1     1     2     2     2     1     1     1     1     2   NaN
  NaN     2     2     1     1     2     2   NaN     2     1     1     1     1     1     2   NaN
  NaN   NaN     2     1     1     2   NaN     2     1     1     1     2     1     1     2   NaN
  NaN   NaN   NaN     2     2   NaN     2     1     1     1     2     2     1     1     2   NaN
  NaN   NaN   NaN   NaN   NaN     2     1     1     1     2   NaN     2     2     2   NaN   NaN
  NaN   NaN   NaN   NaN     2     1     1     1     2   NaN     2     1     1     2   NaN   NaN
  NaN   NaN   NaN     2     1     1     1     2   NaN     2     2     1     1     2     2   NaN
  NaN   NaN     2     1     1     1     2   NaN     2     1     1     1     1     1     1     2
  NaN   NaN   NaN     2     1     2   NaN   NaN     2     1     1     1     1     1     1     2
  NaN   NaN   NaN   NaN     2   NaN   NaN   NaN   NaN     2     2     1     1     2     2   NaN
  NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN     2     1     1     2   NaN   NaN
  NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN     2     2   NaN   NaN   NaN
  ];

% Up zoom pointer
uPointer = [
  NaN   NaN   NaN   NaN     2     2   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
  NaN   NaN   NaN     2     1     1     2   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
  NaN   NaN     2     1     1     1     1     2   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
  NaN     2     1     1     1     1     1     1     2   NaN   NaN   NaN   NaN   NaN   NaN   NaN
    2     1     1     1     1     1     1     1     1     2   NaN   NaN   NaN   NaN   NaN   NaN
    2     1     1     2     1     1     2     1     1     2   NaN   NaN   NaN   NaN   NaN   NaN
  NaN     2     2     2     1     1     2     2     2   NaN   NaN     2     2   NaN   NaN   NaN
  NaN   NaN   NaN     2     1     1     2   NaN   NaN   NaN     2     1     1     2   NaN   NaN
  NaN   NaN   NaN     2     1     1     2   NaN   NaN     2     2     1     1     2     2   NaN
  NaN   NaN   NaN     2     1     1     2   NaN     2     1     1     1     1     1     1     2
  NaN   NaN   NaN     2     1     1     2   NaN     2     1     1     1     1     1     1     2
  NaN   NaN   NaN     2     1     1     2   NaN   NaN     2     2     1     1     2     2   NaN
  NaN   NaN   NaN     2     1     1     2   NaN   NaN   NaN     2     1     1     2   NaN   NaN
  NaN   NaN   NaN   NaN     2     2   NaN   NaN   NaN   NaN   NaN     2     2   NaN   NaN   NaN
  NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
  NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
  ];

% Upper left zoom pointer
ulPointer = [
  NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN     2     2   NaN   NaN   NaN
  NaN     2     2     2     2     2     2     2   NaN   NaN     2     1     1     2   NaN   NaN
  NaN     2     1     1     1     1     1     1     2     2     2     1     1     2     2   NaN
  NaN     2     1     1     1     1     1     1     2     1     1     1     1     1     1     2
  NaN     2     1     1     1     1     2     2     2     1     1     1     1     1     1     2
  NaN     2     1     1     1     1     1     2   NaN     2     2     1     1     2     2   NaN
  NaN     2     1     1     2     1     1     1     2   NaN     2     1     1     2   NaN   NaN
  NaN     2     1     1     2     2     1     1     1     2   NaN     2     2   NaN   NaN   NaN
  NaN   NaN     2     2   NaN   NaN     2     1     1     1     2   NaN   NaN   NaN   NaN   NaN
  NaN   NaN   NaN   NaN   NaN   NaN   NaN     2     1     1     1     2   NaN   NaN   NaN   NaN
  NaN     2     2     2     2     2     2   NaN     2     1     1     1     2   NaN   NaN   NaN
    2     1     1     1     1     1     1     2   NaN     2     1     1     1     2   NaN   NaN
    2     1     1     1     1     1     1     2   NaN   NaN     2     1     2   NaN   NaN   NaN
  NaN     2     2     2     2     2     2   NaN   NaN   NaN   NaN     2   NaN   NaN   NaN   NaN
  NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
  NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
  ];

% Left zoom pointer
lPointer = [
  NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
  NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
  NaN   NaN   NaN   NaN   NaN   NaN   NaN     2     2     2     2     2     2   NaN   NaN   NaN
  NaN   NaN   NaN   NaN   NaN   NaN     2     1     1     1     1     1     1     2   NaN   NaN
  NaN   NaN   NaN   NaN   NaN   NaN     2     1     1     1     1     1     1     2   NaN   NaN
  NaN   NaN   NaN   NaN   NaN   NaN   NaN     2     2     2     2     2     2   NaN   NaN   NaN
  NaN   NaN   NaN   NaN     2     2   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
  NaN   NaN   NaN     2     1     1     2   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
  NaN   NaN     2     1     1     1     2   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
  NaN     2     1     1     1     2     2     2     2     2     2     2     2   NaN   NaN   NaN
    2     1     1     1     1     1     1     1     1     1     1     1     1     2   NaN   NaN
    2     1     1     1     1     1     1     1     1     1     1     1     1     2   NaN   NaN
  NaN     2     1     1     1     2     2     2     2     2     2     2     2   NaN   NaN   NaN
  NaN   NaN     2     1     1     1     2   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
  NaN   NaN   NaN     2     1     1     2   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
  NaN   NaN   NaN   NaN     2     2   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
  ];

% Lower left zoom pointer
llPointer = [
  NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
  NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
  NaN     2     2     2     2     2     2   NaN   NaN   NaN   NaN     2   NaN   NaN   NaN   NaN
    2     1     1     1     1     1     1     2   NaN   NaN     2     1     2   NaN   NaN   NaN
    2     1     1     1     1     1     1     2   NaN     2     1     1     1     2   NaN   NaN
  NaN     2     2     2     2     2     2   NaN     2     1     1     1     2   NaN   NaN   NaN
  NaN   NaN   NaN   NaN   NaN   NaN   NaN     2     1     1     1     2   NaN   NaN   NaN   NaN
  NaN   NaN     2     2   NaN   NaN     2     1     1     1     2   NaN   NaN   NaN   NaN   NaN
  NaN     2     1     1     2     2     1     1     1     2   NaN   NaN   NaN   NaN   NaN   NaN
  NaN     2     1     1     2     1     1     1     2   NaN   NaN   NaN   NaN   NaN   NaN   NaN
  NaN     2     1     1     1     1     1     2   NaN     2     2     2     2     2     2   NaN
  NaN     2     1     1     1     1     2     2     2     1     1     1     1     1     1     2
  NaN     2     1     1     1     1     1     1     2     1     1     1     1     1     1     2
  NaN     2     1     1     1     1     1     1     2     2     2     2     2     2     2   NaN
  NaN     2     2     2     2     2     2     2   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
  NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
  ];

% Down zoom pointer
dPointer = [
  NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
  NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
  NaN   NaN   NaN   NaN     2     2   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
  NaN   NaN   NaN     2     1     1     2   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
  NaN   NaN   NaN     2     1     1     2   NaN   NaN     2     2     2     2     2     2   NaN
  NaN   NaN   NaN     2     1     1     2   NaN     2     1     1     1     1     1     1     2
  NaN   NaN   NaN     2     1     1     2   NaN     2     1     1     1     1     1     1     2
  NaN   NaN   NaN     2     1     1     2   NaN   NaN     2     2     2     2     2     2   NaN
  NaN   NaN   NaN     2     1     1     2   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
  NaN     2     2     2     1     1     2     2     2   NaN   NaN   NaN   NaN   NaN   NaN   NaN
    2     1     1     2     1     1     2     1     1     2   NaN   NaN   NaN   NaN   NaN   NaN
    2     1     1     1     1     1     1     1     1     2   NaN   NaN   NaN   NaN   NaN   NaN
  NaN     2     1     1     1     1     1     1     2   NaN   NaN   NaN   NaN   NaN   NaN   NaN
  NaN   NaN     2     1     1     1     1     2   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
  NaN   NaN   NaN     2     1     1     2   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
  NaN   NaN   NaN   NaN     2     2   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
  ];

% Lower right zoom pointer
lrPointer = [
  NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN     2     2   NaN   NaN   NaN
  NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN     2     1     1     2   NaN   NaN
  NaN   NaN   NaN   NaN     2   NaN   NaN   NaN   NaN     2     2     1     1     2     2   NaN
  NaN   NaN   NaN     2     1     2   NaN   NaN     2     1     1     1     1     1     1     2
  NaN   NaN     2     1     1     1     2   NaN     2     1     1     1     1     1     1     2
  NaN   NaN   NaN     2     1     1     1     2   NaN     2     2     1     1     2     2   NaN
  NaN   NaN   NaN   NaN     2     1     1     1     2   NaN     2     1     1     2   NaN   NaN
  NaN   NaN   NaN   NaN   NaN     2     1     1     1     2   NaN     2     2     2   NaN   NaN
  NaN   NaN   NaN   NaN   NaN   NaN     2     1     1     1     2     2     1     1     2   NaN
  NaN   NaN   NaN   NaN   NaN   NaN   NaN     2     1     1     1     2     1     1     2   NaN
  NaN     2     2     2     2     2     2   NaN     2     1     1     1     1     1     2   NaN
    2     1     1     1     1     1     1     2     2     2     1     1     1     1     2   NaN
    2     1     1     1     1     1     1     2     1     1     1     1     1     1     2   NaN
  NaN     2     2     2     2     2     2     2     1     1     1     1     1     1     2   NaN
  NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN     2     2     2     2     2     2     2   NaN
  NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
  ];
