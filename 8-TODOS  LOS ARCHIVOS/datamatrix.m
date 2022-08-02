function [hFig, hMatrix] = datamatrix(varargin)
%DATAMATRIX display a color-coded image of a data matrix with programmable data-tips & click callbacks
%   [hFig, hMatrix] = datamatrix(data, xlabels,ylabels,dataTips,callbacks)
%   [hFig, hMatrix] = datamatrix(data, propName,propValue, ...)
%   [hFig, hMatrix] = datamatrix(data, xlabels,ylabels,dataTips,callbacks, propName,propValue,...)
%
%   DATAMATRIX(data) accepts a numeric or logical data matrix (0, 1 or 2D)
%   and presents it in a color-coded image. Complex data is supported by
%   color-coding the data's complex modulus (magnitude). NaN elements are
%   assigned a specific shade of gray to distinguish them.
%
%   The user can specify optional labels, as well as data-tips and/or click
%   callbacks for any or all matrix cells. These optional parameters can be
%   specified either directly (format #1 above) or via order-indifferent
%   case-insensitive property-value pairs (format #2). The latter format
%   enables some extra parameterized control (see details below).
%   The formats may also be mixed by specifying valid propName/Value pairs
%   following the direct args (format #3). Note: all direct args must always
%   precede any supplied propName.
%
%   [hFig,hMatrix] = DATAMATRIX(...) returns a handle to the generated
%   figure as well as to the color-coded data matrix (an image object).
%
%   Inputs:
%       data      - mandatory matrix of logical or numeric values
%       xlabels   - optional cell array of X labels (strings)
%                   empty cell array (=default) means {'A','B',...}
%       ylabels   - optional cell array of Y labels (strings)
%                   empty cell array (=default) means {'1','2',...}
%       dataTips  - optional cell matrix of data-tips (strings)
%                   empty cell array (=default) means using standard tips
%       callbacks - optional cell matrix of callbacks (strings)
%                   empty cell array (=default) means no callbacks
%       propName  - one or more of the following property name/value pairs:
%         'xlabels'   - optional cell array of X labels (strings)
%         'ylabels'   - optional cell array of Y labels (strings)
%         'xrotation' - optional numeric value of xlabels rotation (degrees)
%                       default: 0 for 1-letter labels, 90 for others
%                       Note: 45 is space-saving but looks a bit fuzzy
%         'yrotation' - optional numeric value of xlabels rotation (default=0)
%         'dataTips'  - optional cell matrix of data-tips (strings)
%                       Note: Matlab 7+ only (Matlab 6 does not support data tips)
%         'callbacks' - optional cell matrix of callbacks (strings, func handles or callback cell arrays)
%                       Note: Matlab 7+ only
%         'minData'   - optional minimal value of color-coding (same type as data)
%         'maxData'   - optional maximal value of color-coding (same type as data)
%         'xtitle'    - optional x-axis title (string)
%         'ytitle'    - optional y-axis title (string)
%         'color'     - optional color: control shade colors (between white
%                       and this color) - string or [r,g,b] numeric array
%                       default = 'red' = [255,0,0] = [1,0,0]
%
%   Outputs:
%     hFig    - handle to generated figure
%     hMatrix - handle to generated data matrix (an image object)
%
%   Examples:
%     [hFig, hMatrix] = datamatrix(magic(3));
%     datamatrix(magic(3),{'alpha','beta','gamma'},{'row 1','row 2','row3'});
%     datamatrix(magic(3),'xlabels',{'alpha','beta','gamma'},'xrotation',30,'xtitle','My data');
%     datamatrix([i,2-i,nan;1,2*i,3],'ylabels',{'ert','tyu'});        % test complex data
%     datamatrix([true,true,false;false,true,false],'color','m');     % test logical data
%     datamatrix([1,2,3;4,nan,5;7,6,8],'color',[.5,.73,.85]);         % 2nd color format; NaN
%     datamatrix(magic(3),'datatips',{'row#1/col#1','row#1/col#2'});  % datatips (2 elements only)
%     datamatrix(magic(3),'mindata',6,'callbacks',{'12',{@disp,34}}); % callbacks; data clamp
%
%   Class support:
%     int*, single, double, complex*, logical
%     (on applicable Matlab versions: old versions don't support some classes)
%
%   Warning:
%      This code relies in part on undocumented and unsupported Matlab
%      functionality. It works on Matlab 6+, but use at your own risk!
%      Some features (e.g., data-tips) are unavailable on old Matlab versions.
%
%   Bugs and suggestions:
%      Please send to Yair Altman (altmany at gmail dot com)
%
%   Change log:
%     2007-Aug-30: First version posted on <a href="http://www.mathworks.com/matlabcentral/fileexchange/loadAuthor.do?objectType=author&mfx=1&objectId=1096533#">MathWorks File Exchange</a>

% Programmed by Yair M. Altman: altmany(at)gmail.com
% $Revision: 1.1 $  $Date: 2007/08/31 01:23:35 $

  try
      %dbstop if error
      hFig = [];
      hMatrix = [];

      % Process input arguments
      paramsStruct = processArgs(varargin{:});

      % Present the data
      [hFig, hMatrix] = presentData(paramsStruct);

  % Error handling
  catch
      %handleError;
      v = version;
      if v(1)<='6'
          err.message = lasterr;  % no lasterror function...
      else
          err = lasterror;
      end
      try
          err.message = regexprep(err.message,'Error using ==> [^\n]+\n','');
      catch
          try
              % Another approach, used in Matlab 6 (where regexprep is unavailable)
              startIdx = findstr(err.message,'Error using ==> ');
              stopIdx = findstr(err.message,char(10));
              for idx = length(startIdx) : -1 : 1
                  idx2 = min(find(stopIdx > startIdx(idx)));  %#ok ML6
                  err.message(startIdx(idx):stopIdx(idx2)) = [];
              end
          catch
              % never mind...
          end
      end
      if isempty(findstr(mfilename,err.message))
          % Indicate error origin, if not already stated within the error message
          err.message = [mfilename ': ' err.message];
      end
      if v(1)<='6'
          while err.message(end)==char(10)
              err.message(end) = [];  % strip excessive Matlab 6 newlines
          end
          error(err.message);
      else
          rethrow(err);
      end
  end

%% Internal error processing
function myError(id,msg)
    v = version;
    if (v(1) >= '7')
        error(id,msg);
    else
        % Old Matlab versions do not have the error(id,msg) syntax...
        error(msg);
    end
%end  % myError  %#ok for Matlab 6 compatibility


%% Process optional arguments
function paramsStruct = processArgs(varargin)

    % Ensure we got a 2D numeric/logical data matrix
    if ~nargin
        myError('YMA:datamatrix:missingData','Must supply data matrix as first argument');
    end
    paramsStruct.data = varargin{1};
    if ~isnumeric(paramsStruct.data) & ~islogical(paramsStruct.data)  %#ok Matlab 6
        myError('YMA:datamatrix:invalidData','Data must be numeric or logical');
    elseif numel(size(paramsStruct.data)) > 2
        myError('YMA:datamatrix:multiDimData','Data dimensions may not exceed 2');
    end

    % Get the properties in either direct or P-V format
    [directArgs, pvPairs] = parseparams(varargin(2:end));

    % Process direct parameters
    if length(directArgs) > 0,  paramsStruct.xlabels   = directArgs{1};  end  %#ok
    if length(directArgs) > 1,  paramsStruct.ylabels   = directArgs{2};  end
    if length(directArgs) > 2,  paramsStruct.datatips  = directArgs{3};  end
    if length(directArgs) > 3,  paramsStruct.callbacks = directArgs{4};  end

    % Now process the optional P-V params
    try
        % Initialize
        paramName = [];

        supportedArgs = {'xlabels','ylabels','datatips','callbacks',...
                         'xrotation','yrotation','mindata','maxdata',...
                         'xtitle','ytitle','color'};
        while ~isempty(pvPairs)

            % Ensure basic format is valid
            paramName = '';
            if ~ischar(pvPairs{1})
                myError('YMA:datamatrix:invalidProperty','Invalid property passed to datamatrix');
            elseif length(pvPairs) == 1
                myError('YMA:datamatrix:noPropertyValue',['No value specified for property ''' pvPairs{1} '''']);
            end

            % Process parameter values
            paramName  = pvPairs{1};
            paramValue = pvPairs{2};
            %paramsStruct.(lower(paramName)) = paramValue;  % no good on ML6...
            paramsStruct = setfield(paramsStruct, lower(paramName), paramValue);  %#ok ML6
            pvPairs(1:2) = [];
            if ~any(strcmpi(paramName,supportedArgs))
                url = 'matlab:help datamatrix';
                urlStr = getHtmlText(['<a href="' url '">' strrep(url,'matlab:','') '</a>']);
                myError('YMA:datamatrix:invalidProperty',...
                        ['Unsupported property - type "' urlStr ...
                         '" for a list of supported properties']);
            end
        end  % loop pvPairs

        % Process color arg
        if isfield(paramsStruct,'color')
            paramsStruct = processColor(paramsStruct);
        else
            paramsStruct.color = [1,0,0];  % default = red
        end

        % Update & check min/max data
        if ~isfield(paramsStruct,'mindata'),  paramsStruct.mindata = min(paramsStruct.data(:));  end
        if ~isfield(paramsStruct,'maxdata'),  paramsStruct.maxdata = max(paramsStruct.data(:));  end
        if ~strcmp(class(paramsStruct.mindata),class(paramsStruct.data))
            myError('YMA:datamatrix:invalidProperty','mindata must be the same type as data');
        elseif ~strcmp(class(paramsStruct.maxdata),class(paramsStruct.data))
            myError('YMA:datamatrix:invalidProperty','maxdata must be the same type as data');
        elseif numel(paramsStruct.mindata) ~= 1
            myError('YMA:datamatrix:invalidProperty','mindata must be a single value the same type as data');
        elseif numel(paramsStruct.maxdata) ~= 1
            myError('YMA:datamatrix:invalidProperty','maxdata must be a single value the same type as data');
        elseif paramsStruct.maxdata <= paramsStruct.mindata
            myError('YMA:datamatrix:invalidProperty','maxdata must be greater than mindata');
        end

        % Check args
        if isfield(paramsStruct,'xlabels') & ~iscellstr(paramsStruct.xlabels)  %#ok ML6
            myError('YMA:datamatrix:invalidProperty','xlabels must be a cell array of strings');
        elseif isfield(paramsStruct,'xlabels') & length(paramsStruct.xlabels) ~= size(paramsStruct.data,2)  %#ok ML6
            myError('YMA:datamatrix:invalidProperty','mismatch between # data cols & # xlabels');
        elseif isfield(paramsStruct,'ylabels') & ~iscellstr(paramsStruct.ylabels)  %#ok ML6
            myError('YMA:datamatrix:invalidProperty','ylabels must be a cell array of strings');
        elseif isfield(paramsStruct,'ylabels') & length(paramsStruct.ylabels) ~= size(paramsStruct.data,1)  %#ok ML6
            myError('YMA:datamatrix:invalidProperty','mismatch between # data rows & # ylabels');
        elseif isfield(paramsStruct,'ylabels') & length(paramsStruct.ylabels) ~= size(paramsStruct.data,1)  %#ok ML6
            myError('YMA:datamatrix:invalidProperty','mismatch between # data rows & # ylabels');
        elseif isfield(paramsStruct,'xrotation') & (~isnumeric(paramsStruct.xrotation) | numel(paramsStruct.xrotation)~=1)  %#ok ML6
            myError('YMA:datamatrix:invalidProperty','xrotation must be a scalar numeric value (degrees)');
        elseif isfield(paramsStruct,'yrotation') & (~isnumeric(paramsStruct.yrotation) | numel(paramsStruct.yrotation)~=1)  %#ok ML6
            myError('YMA:datamatrix:invalidProperty','yrotation must be a scalar numeric value (degrees)');
        elseif isfield(paramsStruct,'callbacks') & ~iscell(paramsStruct.callbacks)  %#ok ML6
            myError('YMA:datamatrix:invalidProperty','callbacks must be a cell array of strings, func handles or callback cell arrays');
        elseif isfield(paramsStruct,'xtitle') & ~ischar(paramsStruct.xtitle)  %#ok ML6
            myError('YMA:datamatrix:invalidProperty','xtitle must be a cell array of strings');
        elseif isfield(paramsStruct,'ytitle') & ~ischar(paramsStruct.ytitle)  %#ok ML6
            myError('YMA:datamatrix:invalidProperty','ytitle must be a cell array of strings');
        end
    catch
        if ~isempty(paramName),  paramName = [' ''' paramName ''''];  end
        myError('YMA:datamatrix:invalidProperty',['Error setting datamatrix property' paramName ':' char(10) lasterr]);
    end
%end  % processArgs  %#ok for Matlab 6 compatibility

%% Strip HTML tags for Matlab 6
function txt = getHtmlText(txt)
    v = version;
    if v(1)<='6'
        leftIdx  = findstr(txt,'<');
        rightIdx = findstr(txt,'>');
        if length(leftIdx) ~= length(rightIdx)
            newLength = min(length(leftIdx),length(rightIdx));
            leftIdx  = leftIdx(1:newLength);
            rightIdx = leftIdx(1:newLength);
        end
        for idx = length(leftIdx) : -1 : 1
            txt(leftIdx(idx) : rightIdx(idx)) = [];
        end
    end
%end  % getHtmlText  %#ok ML6

%% Process color argument
function paramsStruct = processColor(paramsStruct)
    try
        % Convert color names to RBG triple (0-1) if not already in that format
        if isempty(paramsStruct.color)
            paramsStruct.color = [1,0,0];  % =red
        elseif ischar(paramsStruct.color)
            switch lower(paramsStruct.color)
                case {'y','yellow'},   paramsStruct.color = [1,1,0];
                case {'m','magenta'},  paramsStruct.color = [1,0,1];
                case {'c','cyan'},     paramsStruct.color = [0,1,1];
                case {'r','red',''},   paramsStruct.color = [1,0,0];  % empty '' also sets red color
                case {'g','green'},    paramsStruct.color = [0,1,0];
                case {'b','blue'},     paramsStruct.color = [0,0,1];
                case {'w','white'},    paramsStruct.color = [1,1,1];
                case {'k','black'},    paramsStruct.color = [0,0,0];
                otherwise,  myError('YMA:datamatrix:invalidColor', ['Invalid color specified: ' color]);
            end
        elseif ~isnumeric(paramsStruct.color) | length(paramsStruct.color)~=3  %#ok ML6
            myError('YMA:datamatrix:invalidColor', ['Invalid color specified: ' paramsStruct.color]);
        end

        % Convert decimal RGB format (0-255) to fractional format (0-1)
        if max(paramsStruct.color) > 1
            paramsStruct.color = paramsStruct.color / 255;
        end
    catch
        myError('YMA:datamatrix:invalidColor',['Invalid color specified: ' lasterr]);
    end
%end  % processColor  %#ok ML6

%% Present data in a color-coded matrix
function [hFig, hMatrix] = presentData(paramsStruct)
    hMatrix = [];  %#ok in case of error

    % Start a new figure
    hFig = figure;
    set(hFig, 'name','Data matrix', 'number','off', 'visible','on', 'pointer','fleur');

    % Prepare colormap
    cm = colormap('gray');   % = shades of gray: black=0, white=1
    clen = length(cm);
    cm2 = ((1-cm)+repmat(paramsStruct.color,clen,1)).^0.2;  % color shades: white=0, color=1
    cm2(cm2>1)=1;

    % Special cell color for NaNs (see doc colormap, colormapeditor)
    cm2(1,:) = 0.8*[1,1,1];  % special color = light gray
    cm2(2,:) = cm2(1,:);

    % Prepare colored matrix data
    span = paramsStruct.maxdata - paramsStruct.mindata;
    cdata = double(paramsStruct.data - paramsStruct.mindata) / double(span);
    if ~isreal(paramsStruct.data)
        cdata = abs(cdata);
    end
    cdata(cdata <= 0) = 0;       % clamp low  values to min color intensity = white
    cdata = 3 + floor(cdata*(clen-2));
    cdata(cdata > clen) = clen;  % clamp high values to max color intensity
    cdata(isnan(cdata)) = 1;     % NaNs = special gray color

    % Prepare colorbar tick labels
    if isnumeric(paramsStruct.data)
        numGaps = 10;
        delta = span / numGaps;
        try
            if isinteger(paramsStruct.data)  %#ok ML6
                delta = max(1,delta);
                %numGaps = min(span,numGaps);
            end
        catch
            % never mind - probably an old matlab version without int* support
        end
        ticklabels = paramsStruct.mindata : delta : paramsStruct.maxdata;
        if ticklabels(end) ~= paramsStruct.maxdata  % might happen for int data
            ticklabels(end+1) = paramsStruct.maxdata;
        end
        numGaps = length(ticklabels) - 1;
        %tickvalues = [1,0.5+(2:(clen-2)/numGaps:clen)];
        valuesFrac = double(ticklabels - paramsStruct.mindata) / double(span);
        tickvalues = [1,2.5+floor(valuesFrac*(clen-2))];
        ticklabels = mat2cell(ticklabels,1,ones(1,numGaps+1));
        ticklabels = cellfun(@num2str,ticklabels,'un',0);
        ticklabels = {'NaN', ticklabels{:}};
    else
        ticklabels = {'false','true'};  % no NaNs in a logical matrix, or else it is converted to double...
        tickvalues = [1,2];
        cdata(cdata == 3) = 1;
        cdata(cdata == clen) = 2;
        cm2([1:2,4:end-1],:) = [];
    end

    % Display data in figure window
    axData = axes('parent',hFig, 'tag','axData');
    hMatrix = image(cdata,'CDataMapping','direct', 'ButtonDownFcn','', 'tag','dataMatrix', 'parent',axData);
    caxis([paramsStruct.mindata-eps, paramsStruct.maxdata]);

    % Colormap is finally ready - display in a colorbar
    colormap(cm2);
    hc = colorbar;  %#ok
    set(hc,'ytick',tickvalues, 'ytickLabel',ticklabels, 'FontSize',8);
    %zoom on;

    % Display the labels (if specified)
    if isfield(paramsStruct,'xtitle')
        xlabel(paramsStruct.xtitle);
    end
    if isfield(paramsStruct,'ytitle')
        hYlabel = ylabel(paramsStruct.ytitle);
        ylabelPos = get(hYlabel,'pos');
        set(hYlabel,'VerticalAlignment','top','pos',[size(cdata,2)+0.5 ylabelPos(2:3)]);
    end
    [numRows,numCols] = size(paramsStruct.data);

    % Set default labels
    if ~isfield(paramsStruct,'ylabels')
        ylabels = mat2cell(1:numRows,1,ones(1,numRows));
        paramsStruct.ylabels = cellfun(@num2str,ylabels,'un',0);
    end
    if ~isfield(paramsStruct,'xlabels')
        paramsStruct.xlabels = cellfun(@n2a,mat2cell(1:numCols,1,ones(1,numCols)),'un',0);
    end
    if ~isfield(paramsStruct,'xrotation')
        paramsStruct.xrotation = 0;
        if max(cellfun(@length,paramsStruct.xlabels)) > 1  % multi-char labels: vertical orientation
            paramsStruct.xrotation = 90;
        end
    end
    if ~isfield(paramsStruct,'yrotation')
        paramsStruct.yrotation = 0;
    end

    %set(hi,'cdata',rand(13,24))
    %set(axData,'pos',get(axData,'pos')-[0,0.03,0,0]);
    set(axData, 'xtick',[], 'ytick',[], 'tag','axData')
    try
        set(axData, 'outerpos',[.05,0,1,.95]);

        % Decrease axis width, for all colorbar tick labels to fit in window
        %axPos = get(axData,'position');
        %axPos(3) = axPos(3) - 0.02;
        %set(axData, 'position',axPos);
        set(axData, 'Position',[0.15,0.06,0.70,0.85]);
    catch
        % unsupported on old Matlab versions - never mind
    end
    commonProps = {'Interpreter','none', 'FontSize',8};
    htx = text(1:numCols,repmat(0.5-0.01*numRows,1,numCols), paramsStruct.xlabels, commonProps{:}, 'tag','xlabels', 'rotation',paramsStruct.xrotation);  %#ok
    hty = text(repmat(0.5-0.01*numCols,1,numRows),1:numRows, paramsStruct.ylabels, commonProps{:}, 'tag','ylabels', 'rotation',paramsStruct.yrotation, 'horizontal','right');  %#ok
    set(axData,'UserData',paramsStruct);

    % Add the <Data> button
%    uicontrol('String','View data','tag','btData','callback',@btData_Callback,'units','norm','position',[.15,.005,.12,.05],'tooltip','View results data in table format');

    % Data cursor setup
    try
        cursorObj = datacursormode(hFig);
        set(cursorObj, 'enable','on', 'UpdateFcn',@dataTipsTxt);

        % Mouse movements callbacks
        set(hFig, 'ButtonDownFcn',get(hFig,'WindowButtonDownFcn'));
        set(hFig, 'WindowButtonMotionFcn',@onMouseMove_Callback);
        %set(hFig,'WindowButtonDownFcn',  @onMouseDown_Callback);
        set(hFig, 'visible','on');
        pause(0.2);

        % The following hack only works in Matlab 7.2+
        if str2double(regexprep(version,'^(\d+\.\d+).*','$1')) >= 7.2
            modeMgr = get(hFig,'ModeManager');
            modeMgr.CurrentMode.WindowButtonDownFcn{1} = @onMouseDown_Callback;
            modeMgr.CurrentMode.ButtonDownFilter = @true;  % Pass mouse-clicks to *MY* callback
            warning off MATLAB:uitools:uimode:callbackerror %because ButtonDownFilter sends extra params...
        end
    catch
        % unsupported on old Matlab versions - never mind
    end
%end  % presentData  %#ok ML6

%% --- Convert col # format to 'A','B','C' format
% Thanks Brett Shoelson, via CSSM
function colStr = n2a(c)
      t = [floor((c-1)/26)+64, rem(c-1,26)+65];
      if (t(1)<65), t(1) = []; end
      colStr = char(t);

%% --- Executes on mouse click within the matrix image
function onMouseDown_Callback(hObject, varargin)  %#ok
      hFig = ancestor(hObject,'figure');  % should already be the figure handle, but just in case...
      if ~strcmpi(get(hFig,'selectiontype'),'normal')
          hgfeval(get(hFig,'ButtonDownFcn'),hFig,[]);
      else
          st = dbstack;
          %disp({st.name})
          if isempty(strmatch('onMouseMove_Callback',{st.name}))
              % Button clicked, not mouse movement
              hImage = findall(hFig, 'tag','dataMatrix');
              image_Callback(hImage);
          end
      end

%% --- Called on mouse cursor movement
function onMouseMove_Callback(hFig,varargin)   %#ok
% hFig    handle to figure
  %try
      %return;

      % Get the figure's main axes
      hAxes = get(hFig,'currentAxes');
      if isempty(hAxes)
          return;  % should never happen
      end
      
      % Get the current cursor point
      cp = get(hAxes,'CurrentPoint');
      cx = round(cp(1,1));
      cy = round(cp(1,2));
      
      % Check if the cursor is within the axes limits
      inMatrixFlag = 1;
      xlim = get(hAxes,'xlim');
      ylim = get(hAxes,'ylim');
      if (xlim(1)<cx & cx<xlim(2))  %#ok ML6
          dy = min(0.5, 0.05 * (ylim(2)-ylim(1)));
          updateGuideline(hAxes,[1,1,1,1]*cx,[ylim(1),cy-dy,cy+dy,ylim(2)],'x-guide');
      else
          inMatrixFlag = 0;
          set(findall(hAxes,'tag','x-guide'), 'visible','off');
      end
      if (ylim(1)<cy & cy<ylim(2))  %#ok ML6
          %updateGuideline(hAxes,xlim,[1,1]*cy,'y-guide');
          dx = min(0.5, 0.05 * (xlim(2)-xlim(1)));
          updateGuideline(hAxes,[xlim(1),cx-dx,cx+dx,xlim(2)],[1,1,1,1]*cy,'y-guide');
      else
          inMatrixFlag = 0;
          set(findall(hAxes,'tag','y-guide'), 'visible','off');
          if cy>ylim(2)
              set(findall(hAxes,'tag','x-guide'), 'visible','off');
          end
      end
      if cx>xlim(2)
          set(findall(hAxes,'tag','y-guide'), 'visible','off');
      end

      % If cursor is within the matrix
      cursorObj = datacursormode(hFig);
      if inMatrixFlag
          % Update the data tip (if shown) by simulating a MouseButtonDown event
          hImage = findall(hAxes, 'tag','dataMatrix');
          %set(hImage, 'ButtonDownFcn',@image_Callback);
          if strcmp(cursorObj.Enable,'on')
              % This doesn't work... :(((
              %cursorObj.sendMouseEvent('ButtonDown',hImage);
              % ...so try something else:
              hgfeval(get(hFig,'ButtonDownFcn'),hFig,[]);

              % ...Not enough: in Matlab 7.4 we also need the following
              modeMgr = get(hFig,'ModeManager');
              modeMgr.CurrentMode.WindowButtonDownFcn{1} = @onMouseDown_Callback;
              hgfeval(modeMgr.CurrentMode.WindowButtonDownFcn,hFig,[]);
          else
              set(hImage, 'ButtonDownFcn',@image_Callback);
          end
      else
          % Otherwise, remove all data tips
          cursorObj.removeAllDataCursors;
      end
  %catch
  %    handleError;
  %    return
  %end

%% --- Prepare/update axes guideline
function updateGuideline(hAxes,x,y,tag)
  hGuideline = findall(hAxes,'tag',tag);
  if ~isempty(hGuideline)
      set(hGuideline(1), 'xdata',x(1:2), 'ydata',y(1:2), 'visible','on');
      set(hGuideline(2), 'xdata',x(3:4), 'ydata',y(3:4), 'visible','on');
  else
      line(x(1:2), y(1:2), 'tag',tag, 'linestyle',':', 'color','k', 'HandleVisibility','off');
      line(x(3:4), y(3:4), 'tag',tag, 'linestyle',':', 'color','k', 'HandleVisibility','off');
  end

%% --- Generate Data Tip text
% Note: datacursor/datatip functions are located at: %MATLABROOT%\toolbox\matlab\graphics\@graphics\@datacursor\*.m
% ^^^^  and at:                                      %MATLABROOT%\toolbox\matlab\graphics\@graphics\@datatip\*.m
function txt = dataTipsTxt(empt,event_obj)  %#ok
  try
      if ~ishandle(event_obj),  return;  end
      pos = floor(get(event_obj,'Position'));

      % Clamp to axis limits (needed because onMouseMove_Callback() below messes the default datatip callback)
      hFig = ancestor(get(event_obj,'target'),'figure');
      hAxes = findall(hFig, 'tag','axData');
      xlim = get(hAxes,'xlim');
      ylim = get(hAxes,'ylim');
      if pos(1)<xlim(1),  pos(1)=xlim(1)+0.5;  end
      if pos(1)>xlim(2),  pos(1)=xlim(2)-0.5;  end
      if pos(2)<ylim(1),  pos(2)=ylim(1)+0.5;  end
      if pos(2)>ylim(2),  pos(2)=ylim(2)-0.5;  end
      pos = floor(pos);
      %cp = get(hAxes, 'CurrentPoint');
      %disp(floor([pos cp(1,1:2)]))

      %containerObj = event_obj.Target;
      %while ~isempty(containerObj) && ~strcmp(get(containerObj,'Type'),'figure')
      %    containerObj = get(containerObj,'Parent');
      %end
      %if ~isempty(containerObj)
      %    handles = guidata(containerObj);
      %    dataIdx = find(handles.data(:,1)==pos(1));
      %else
      %    dataIdx = [];
      %end
      %if isempty(dataIdx)
      
      % Get the Image object (note: can't use 'target' directly because of the guide lines)
      %hImage = get(event_obj,'target');
      hImage = findall(hFig, 'tag','dataMatrix');

      % Get the current object & analysis names
      hAx = get(hImage,'parent');
      paramsStruct = get(hAx,'userdata');

      % Set the tooltip text based on the currrent position and image value
      %cdata = get(hImage,'cdata');
      %curData = cdata(pos(2),pos(1));
      curData = paramsStruct.data(pos(2),pos(1));
      if isnumeric(curData)
          dataStr = num2str(curData,3);
      elseif islogical(curData)
          dataStr = char(java.lang.Boolean(curData));
      end
      txt = {['Row: ',  paramsStruct.ylabels{pos(2)}], ...  % ['obj' num2str(pos(1))]], ...
             ['Col: ',  paramsStruct.xlabels{pos(1)}], ...  % ['an'  num2str(pos(2))]], ...
             ['Data: ', dataStr]};

      % Display the tooltip message, if available (wrap long lines)
      if isfield(paramsStruct,'datatips')
          datatip = paramsStruct.datatips{pos(2),pos(1)};
          if ~isempty(datatip)
              newline = double(char(java.lang.System.getProperty('line.separator')));
              newline = newline(end);
              msg = strrep(datatip,'; ',[';' newline]);
              if iscell(msg)
                  msg = regexprep(msg,'(.)$',['$1' sprintf('\n\n')]);
                  msg = [msg{:}];
              end
              msg = regexprep(msg, {'^(.)','\n+$'},{'\n$1',''});  % separator newline before msg, but none at the end
              newlineIdx = find(msg==newline);
              spans = [0, newlineIdx, length(msg)];
              MAX_WIDTH = 50;
              for spanIdx = 1 : length(spans)-1
                  wrapIdx = spans(spanIdx);
                  spanEndIdx = spans(spanIdx+1);
                  rem = msg(wrapIdx+1:spanEndIdx);
                  spaceIdx = wrapIdx + find(rem==' ');
                  while length(rem) > MAX_WIDTH
                      wrapIdx = spaceIdx(find(spaceIdx>wrapIdx & spaceIdx<=wrapIdx+MAX_WIDTH, 1, 'last'));
                      if ~isempty(wrapIdx)
                          msg(wrapIdx) = newline;
                          rem = msg(wrapIdx+1:spanEndIdx);
                      else
                          rem = '';
                      end
                  end
              end
              txt{end+1} = '';  % seperator
              txt{end+1} = msg;
          end
      end
  catch
      %handleError;
      return;
  end

%% --- Executes on mouse click within the matrix image
function image_Callback(hImage, varargin)  %#ok
  try
      % Get the clicked location point
      hAx = get(hImage,'parent');
      cp = get(hAx, 'CurrentPoint');
      cx = round(cp(1,1));
      cy = round(cp(1,2));

      % Ensure the clicked location is within the results matrix...
      xlim = get(hAx,'xlim');
      ylim = get(hAx,'ylim');
      if ~(xlim(1)<cx & cx<xlim(2) & ylim(1)<cy & cy<ylim(2))  %#ok ML6
          return;
      end

      % Open all reports saved for this analysis/object combination
      paramsStruct = get(hAx,'UserData');
      callback = paramsStruct.callbacks{cy,cx};
      hgfeval(callback);
  catch
      %handleError;
      return;
  end

%% --- mat2cell support for Matlab 6 (simplified for performance)
function cellData = mat2cell(matData,varargin)
      [numRows,numCols] = size(matData);
      cellData{numRows,numCols} = matData(1);  % pre-allocate
      for rowIdx = 1 : numRows
          for colIdx = 1 : numCols
              cellData{rowIdx,colIdx} = matData(rowIdx,colIdx);
          end
      end

%% --- cellfun replacement for Matlab 6
function cellData = cellfun(func,cell,varargin)
  try
      % Call builtin cellfun function if possible (Matlab 7.1+)
      % Note: use hgfeval not feval to filter out partial support on Matlab 6
      % ^^^^  that may cause a SEGV crash...
      cellData = hgfeval(@cellfun,func,cell,varargin{:});
  catch
      % Probably an old Matlab version with limited cellfun support
      if nargin > 2  % 'un'...
          cellData = {};
          for cellIdx = 1 : length(cell)
              cellData{cellIdx} = feval(func,cell{cellIdx});
          end
      else
          cellData = [];
          for cellIdx = 1 : length(cell)
              cellData(cellIdx) = feval(func,cell{cellIdx});
          end
      end
  end

