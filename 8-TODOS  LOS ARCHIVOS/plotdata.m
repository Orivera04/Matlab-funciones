function [hDataFig, hSpreadsheet] = plotdata(varargin)
% plotdata Displays raw data of figure plots in a separate spreadsheet figure
%
% Syntax:
%    [hDataFig, hSpreadsheet] = plotdata
%    [hDataFig, hSpreadsheet] = plotdata(hPlotFig)
%    [hDataFig, hSpreadsheet] = plotdata(figureName, sheetName, xdata, ydata, xAxisName, yHeaders, ...)
%
% Description:
%    PLOTDATA(hPlotFig) scans the supplied figure handle for any plot axes;
%    for each plot axes found, a new spreadsheet is created with the plot
%    data values (X & Y, not Z). The data is displayed in the color of the
%    plot's original color. If the plot lines have a tag name or DisplayName
%    property (also used by legend), these are used as data column headers.
%    Note that all data vectors (xdata, ydata) must be the same length. 
%    If the plot or subplot(s) have titles, these are used as sheet names.
%    Data stats may be turned on/off using the checkbox at the bottom.
%    Data may be sorted, filtered, modified and exported to Excel -
%    explore the many options available in the top toolbar!
%    If the Excel plug-in is unavailable, tab-based Java tables are used.
%
%    PLOTDATA() is equivalent to PLOTDATA(gcf), scanning the currently
%    active figure.
%
%    PLOTDATA(figureName, sheetName,xdata,ydata,xAxisName,yHeaders, ...)
%    enables direct data display. Parameters #2-6 may be repeated: each set
%    (5 parameters each) will create a separate spreadsheet.
%
%    hDataFig = PLOTDATA(...) returns a handle to the data (spreadsheet)
%    figure
%
%    [hDataFig, hSpreadsheet] = PLOTDATA(...) also returns a handle to the
%    spreadsheet object - either an Excel ActiveX, or a Java tabbed-pane.
%
% Examples:
%    x=0:.01:10; ydata=[sin(x);cos(x)];
%    hFig=figure; plot([x;x]',ydata');
%    plotdata;  % scan the current figure for raw data (2 data lines)
%    plotdata(hFig);  % scan the selected figure handle
%    plotdata('title','sheet #1',1:3,magic(3),'X data',{'1','2','3'});
%
% Known issues/limitations:
%    1. Works best with Excel Web Component. This is available on any PC
%       that has Excel installed, or can be downloaded for free from
%       microsoft.com and used (read-only) even if Excel is not installed!
%    2. If the Excel plug-in is unavailable (e.g., on Linux), tab-based
%       Java tables are used but these provide more limited functionality.
%       When resizing java-based figure tables may become misplaced in their
%       container: resize again by a very small amount to snap into place.
%    3. Requires all plot lines in an axis to have the same xdata.
%       This limitation will be removed in a future version of PlotData.
%    4. Works on Matlab 7+. Might work on Matlab 6.5. Fails on Matlab 6.0
%
% Bugs and suggestions:
%    Please send to Yair Altman (altmany at gmail dot com)
%
% Change log:
%    2007-06-23: Added hSpreadsheet return arg; used Java tables if Excel is unavailable
%    2007-06-20: First version posted on <a href="http://www.mathworks.com/matlabcentral/fileexchange/loadAuthor.do?objectType=author&mfx=1&objectId=1096533#">MathWorks File Exchange</a>
%
% See also:
%    OfficeDoc (on <a href="http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=15192">MathWorks File Exchange</a>)

% Programmed by Yair M. Altman: altmany(at)gmail.com
% $Revision: 1.2 $  $Date: 2007/06/23 23:18:43 $

  try
      % Creates a new figure (or re-use existing one)
      hFig = findall(0,'tag','PlotDataFig');
      iconpath = [matlabroot, '/toolbox/matlab/icons/'];
      if isempty(hFig)
          % Prepare the figure
          hFig = figure('tag','PlotDataFig', 'menuBar','none', 'toolBar','none', 'Name','Plot data', 'NumberTitle','off', 'handleVisibility','off', 'IntegerHandle','off', 'filename','', 'ResizeFcn',@figResizeFcn);
          try
              % Set the Window icon
              jFig = get(hFig,'JavaFrame');
              figIcon = javax.swing.ImageIcon([iconpath 'profiler.gif']);
              jFig.setFigureIcon(figIcon);
          catch
              % never mind...
          end
      else
          clf(hFig);
          figure(hFig);   % bring to front
      end

      % Fix the ActiveX tags, position etc.
      acx = initSpreadsheet(hFig, varargin{:});

      % Return the data figure handle, if requested
      if nargout
          hDataFig = hFig;
          hSpreadsheet = acx;
      end
  catch
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


%% Initialize the displayed spreadsheet object
function acx = initSpreadsheet(hFig, varargin)
      % Note: for help: http://msdn2.microsoft.com/en-us/library/microsoft.office.tools.excel.aspx
      % Requires: C:\PROGRA~1\COMMON~1\MICROS~1\WEBCOM~1\##\OWC##.DLL  (## = 9/10/11/...)
      % Note2: see http://techsupt.winbatch.com/ts/T000001033005F9.html for list of all XLS consts

      %set(hFig,'visible','on');   % for debugging...

      % Set figure name
      setFigureName(hFig, varargin{:});

      % Create (or reset) the spreadsheet object
      acx = createSpreadsheetObject(hFig);

      % If successfully created
      if ~isempty(acx)

          if ~isjava(acx)
              sheets = acx.Sheets;
          end

          % Set the data within the spreadsheet according to input type:
          if nargin<2 | isempty(varargin)  %#ok ML6   % No data - error
              %error('Must supply data to display in table!');
              varargin = {gcf};
          end
          if iscell(varargin) & ~isempty(varargin{1}) & ishandle(varargin{1}(1))  %#ok ML6  % figure handle
              hSrcFig = varargin{1}(1);

              % Place all axes in separate worksheets
              ax = sort(findall(hSrcFig,'type','axes','visible','on'));
              for axIdx = 1 : length(ax)
                  axTag = get(ax(axIdx),'tag');
                  if isempty(axTag) | isempty(strmatch(axTag,{'axLogo','legend'}))  %#ok ML6
                      % Set this axis's data in the current worksheet
                      setWorksheetAxisData(acx,ax(axIdx),axIdx);

                      if ~isjava(acx)
                          % Freeze pane beneath the headers (figure needs to be visible)
                          set(hFig, 'visible','on');
                          freezePane(acx,'C2');

                          % Add a new worksheet for the next data set
                          invoke(sheets,'Add');
                      end
                  end
              end
          else
              % Loop over all input args
              numArgs = length(varargin);
              sheetId = 1;
              setIdx = 1 + (numArgs>0 & ~isempty(varargin{1}) & (ischar(varargin{1}(1)) | isstruct(varargin{1}(1)) | ishandle(varargin{1}(1))));  %#ok ML6
              while setIdx <= numArgs
                  % Note: expected args format is: sheetName, xdata, ydata, xAxisName, yHeaders, ...
                  if ischar(varargin{setIdx})
                      sheetName = varargin{setIdx};
                      setIdx = setIdx + 1;
                  else
                      sheetName = sprintf('sheet%d',sheetId);
                  end

                  % data vals: {xdata, ydata}
                  data = varargin(setIdx:min(numArgs,setIdx+1));
                  setIdx = setIdx + length(data);

                  % headers: {xAxisName, yHeaders}
                  % Note: yHeaders may be a string or a cell array of strings
                  headers = varargin(setIdx:min(numArgs,setIdx+1));
                  %headers(~myCellfun(@ischar,headers)) = [];
                  if ~isempty(headers)
                      if ~ischar(headers{1})
                          headers = {};
                      elseif length(headers)>1 & ~ischar(headers{2}) & ~iscell(headers{2})  %#ok ML6
                          headers(2) = [];
                      end
                  end
                  setIdx = setIdx + length(headers);

                  % Set the data in the worksheet
                  setWorksheetData(acx, sheetName, data{:}, headers{:});

                  if ~isjava(acx)
                      % Freeze pane beneath the headers (figure needs to be visible)
                      set(hFig, 'visible','on');
                      freezePane(acx,'C2');

                      % Add a new worksheet for the next data set
                      invoke(sheets,'Add');
                  end
                  sheetId = sheetId + 1;
              end
          end

          % If any data was entered, then the last worksheet is empty and unused, so delete it
          if ~isjava(acx) & sheets.Count > 1  %#ok ML6
              invoke(acx.ActiveSheet,'Delete');
          end
      else
          % Do nothing - ActiveX not created so error msg was displayed
      end  % If ActiveX successfully created

%% Create spreadsheet object (or reset the existing one, if found)
function hActiveX = createSpreadsheetObject(hFig)
      % If this figure was already open with the ActiveX, do not recreate it
      %if ~isfield(handles,'hActiveX') | isempty(handles.hActiveX) | ~ishandle(handles.hActiveX)  %#ok ML6

          hActiveX = [];
          hFigPos = getPixelPos(hFig);

          % Try to select the latest possible ActiveX component
          version = 15;
          foundFlag = 0;
          while ~foundFlag & (version > 9)  %#ok ML6
              try
                  verStr = num2str(version);
                  actxNameStr = ['OWC' verStr '.Spreadsheet.' verStr];
                  hActiveX = actxcontrol(actxNameStr, [0,0,hFigPos(3:4)], hFig);  % hContainer 2nd output arg is invalid in ML6...
                  foundFlag = 1;
              catch
                  version = version - 1;
              end
          end

          % If not found, error
          if foundFlag

              % Set the control's position to be just inside the container's pixel position
              try
                  set(hFig, 'userdata',hActiveX);
              catch
                  set(hFig, 'userdata',hActiveX.Handle);  % old ML6 format
              end
              %set(hContainer, 'tag','acxSpreadsheetContainer', 'units','normalized', 'position',[0,0,1,1], 'userdata',hActiveX);  % forget ...'parent',hParent... - it creates a GUI overlap bacause of a Matlab bug...  % hContainer is unavailable in ML6...
              %uistack(findall(hFig,'tag','cbStats'),'top');   % doesn't work for an unknown reason
              cbStats = uicontrol('style','checkbox', 'parent',hFig, 'value',1, 'string','Stats', 'units','pixels', 'pos',[210,1,45,15], 'tag','cbStats', 'callback',@cbStats_Callback);  %#ok - cbStats unused
              pause(0.1);  %small delay to let the ActiveX time to render

              % Remove all default worksheets (the ActiveX requires at least one remain visible)
              sheets = hActiveX.Sheets;
              if sheets.Count < 1   % should never happen
                  invoke(sheets,'Add');
              else
                  while hActiveX.Sheets.Count > 1
                      invoke(hActiveX.ActiveSheet,'Delete');
                  end
              end

              % General properties
              hActiveX.DisplayDesignTimeUI = 1;

              % Clear the one visible worksheet
              range = selectRange(hActiveX,'$1:$99999');  %=hActiveX.Range('$1:$99999');
              invoke(range.EntireRow,'Select');
              invoke(hActiveX.Selection,'ClearContents');
              invoke(hActiveX.Selection,'ClearFormats');

          else  % Excel ActiveX plug-in not found

              % TODO: handle error if excel ActiveX not found (maybe use uitable?)
              %hMsg = uicontrol('style','text','string',{'Excel ActiveX','object not found'},'parent',hFig,'units','norm','position',[0,0,1,1],'FontSize',36,'Foreground','r','Background',get(hFig,'color'));
              %hhMsg = handle(hMsg);
              %%hhMsg.Position(4) = 0.5 + hhMsg.Extent(4)/2;  % construct invalid in ML6...
              %hhMsg.Position = [hhMsg.Position(1:3), 0.5 + hhMsg.Extent(4)/2];

              % Create the tab pane
              tp = awtcreate('javax.swing.JTabbedPane');
              [jh,hContainer] = javacomponent(tp, [2,0,hFigPos(3:4)], hFig);  %#ok - jh is unused
              set(hContainer,'units','normalized', 'tag','jTabbedPane', 'userdata',tp, 'visible','on');
              set(hFig, 'userdata',tp);
              sp = schema.prop(handle(tp),'UserData','mxArray');  %#ok - sp is unused
              userdata = struct('container',hContainer, 'tables',handle([]), 'scroll',handle([])); 
              set(tp, 'userdata',userdata);
              hActiveX = tp;  % return tabbedPane to caller
              tp.setTabPlacement(tp.BOTTOM);

          end  % If found a relevant ActiveX
      %end  % if worksheet object does not yet exist

%% Set the data within the spreadsheet according to supplied axis
function setWorksheetAxisData(acx, ax, axIdx)
      % Set the worksheet name according to the axis title (remove all invalid chars)
      sheetName = regexprep(get(get(ax,'title'),'string'), '[\\{}]', '');
      if isempty(sheetName)
          sheetName = get(ancestor(ax,'figure'),'name');
      end
      if isempty(sheetName)
          %sheetName = 'Plot data';
          sheetName = ['Axis #' num2str(axIdx)];
      end

      % Loop over all axes plot lines
      % TODO: handle non-'type'='line' datum (annotations etc.)
      %hLines = findall(ax,'type','line');
      %hLines = sort(findall(ax,'-not','type','axes','-not','type','text'));
      hLines = sort(get(ax,'child'));
      numLines = length(hLines);
      if (numLines == 0)
          return;  % no data lines - skip this worksheet
      end
      validIdx = 1;
      for lineIdx = 1 : numLines
          hLine = hLines(lineIdx);
          newXData = get(hLine,'xdata')';
          if lineIdx>1 & ~isequal(size(newXData),size(xdata{1}))  %#ok ML6
              continue;  % All data vectors must be the same length
          end
          xdata{:,validIdx} = newXData;  %#ok mlint
          ydata{:,validIdx} = get(hLine,'ydata')';  %#ok mlint
          seriesName = strrep(get(hLine,'tag'),'\','');
          if isempty(seriesName) & isprop(hLine,'DisplayName')  %#ok ML6
              seriesName = strrep(get(hLine,'DisplayName'),'\','');
          end
          yHeaders{:,validIdx} = seriesName;  %#ok mlint
          if isprop(hLine,'color')
              color(validIdx) = getBGR(get(hLine,'color'));  %#ok
          else
              color(validIdx) = getBGR([0,0,0]);  %#ok mlint
          end
          validIdx = validIdx + 1;
      end

      % Get the X-axis name
      xAxisNames = get(get(ax,'XLabel'),{'string','userdata'});
      xAxisName = regexprep(strcat(xAxisNames{:}), '[\\{}]', '');

      % Set the data in the worksheet
      setWorksheetData(acx, sheetName, xdata, ydata, xAxisName, yHeaders, color);


%% Freeze pane beneath the headers
function freezePane(acx,cell)
      %acx.Range(cell).Select;
      selectRange(acx,cell);
      iter = 1;
      maxIter = 10;
      thisWin = acx.ActiveWindow;
      thisWin.FreezePanes = 1;
      while (iter < maxIter & ~thisWin.FreezePanes)  %#ok ML6
          pause(0.05);
          iter = iter + 1;
          thisWin.FreezePanes = 1;
      end

%% convert color from Matlab to Microsoft decimal BGR format (a number)
function bgrColor = getBGR(color)
      bgrColor = sum(floor(color*255) .* (256.^[0,1,2]));

%% convert color from Microsoft decimal BGR format to HTML hexa RGB format (a string)
function rgbColorStr = getRGB(color)
      bgrColorStr = dec2hex(color);
      rgbColorStr = bgrColorStr(:,[5,6,3,4,1,2]);

%% Get pixel position of an HG object (replacement for getpixelposition() in ML6)
function pos = getPixelPos(hObj)
    try
        % getpixelposition is unvectorized unfortunately! 
        pos = getpixelposition(hObj);
    catch
        % Matlab 6 did not have getpixelposition nor hgconvertunits so use the old way...
        pos = getPos(hObj,'pixels');
    end

%% Get position of an HG object in specified units
function pos = getPos(hObj,units)
    % Matlab 6 did not have hgconvertunits so use the old way...
    oldUnits = get(hObj,'units');
    if strcmpi(oldUnits,units)  % don't modify units unless we must!
        pos = get(hObj,'pos');
    else
        set(hObj,'units',units);
        pos = get(hObj,'pos');
        set(hObj,'units',oldUnits);
    end

%% Set worksheet data
function setWorksheetData(acx, titleStr, xdata, ydata, xAxisName, yHeaders, color)
      % Initialize
      if nargin<2,  titleStr = 'Plot data';  end
      if nargin<3,  xdata = [];  end
      if nargin<4,  ydata = [];  end
      if nargin<5 | isempty(xAxisName),  xAxisName = 'X data';  end  %#ok ML6

      % Args sanity check
      if ~ischar(titleStr)
          error('Args supplied to plotdata appear to be incorrect - please read help');
      end

      % Set the worksheet name
      sheetName = titleStr;
      retryIdx = 0;
      renameFlag = 1;
      panel = [];
      while renameFlag
          try
              if ~isjava(acx)
                  set(acx.ActiveSheet,'Name',sheetName);
              else
                  panel = javax.swing.JPanel;  % Double-buffered, Flow layout
                  acx.addTab(sheetName,panel);
              end
              renameFlag = 0;
          catch
              % will get here if the sheet name already exists, so we must rename it...
              retryIdx = retryIdx + 1;
              sheetName = [titleStr ' (' num2str(retryIdx) ')'];
              if retryIdx>10  % something large enough but still limited...
                  rethrow(lasterror);
              end
          end
      end
      if (retryIdx>0)
          %disp(['Sheet "' titleStr '" already exists - renaming "' sheetName '"']);
      end

      % Hide gridlines
      if ~isjava(acx)
          set(acx.ActiveWindow,'DisplayGridlines',0);
          set(get(acx.Cells,'Font'), 'Size',8);
      else
          % TODO
      end

      % Cell-ize
      if ~iscell(xdata) | isscalar(xdata{1}),  xdata = {xdata};  end  %#ok ML6
      if ~iscell(ydata) | isscalar(ydata{1}),  ydata = {ydata};  end  %#ok ML6
      if isempty(xdata) | isempty(xdata{1})  %#ok ML6
          %error(['No X data in "' titleStr '"']);
          xdata = cellstr(repmat(' ',length(ydata{1}),1));
      end

      % Set data column-wise
      if (size(xdata{1},1) < size(xdata{1},2)) & ~ischar(xdata{1}) & ~iscell(xdata{1}),  xdata = {xdata{1}'};  end  %#ok ML6
      if (size(ydata{1},1) < size(ydata{1},2)) & ~ischar(ydata{1}) & ~iscell(ydata{1}),  ydata = {ydata{:}'};  end  %#ok ML6
      numLines = length(ydata) * size(ydata{1},2);
      if (numel(ydata) == 1)
          newData = {};
          for colIdx = 1 : numLines
              newData{colIdx} = ydata{1}(:,colIdx);  %#ok mlint
          end
          ydata = newData;
      end

      % Default headers = 'Field #...'
      if nargin<6,  yHeaders = {};  end
      if ~iscell(yHeaders),  yHeaders = {yHeaders};  end
      for fieldIdx = 1 : numLines
          if fieldIdx > length(yHeaders) | isempty(yHeaders{fieldIdx})  %#ok ML6
              yHeaders{fieldIdx} = ['Field #' num2str(fieldIdx)];
          end
      end

      % Simple processing for Java table...
      if isjava(acx)
          % Prepare the data table
          columnNames = [xAxisName, yHeaders];
          userdata = get(acx, 'userdata');
          hContainer = userdata.container;
          ppos = getPixelPos(hContainer);
          tpos = ppos(3:4); %-[4,15];
          colWidth = (tpos(1)-55) / length(columnNames);
          [ett table] = prepareJTable(columnNames,colWidth,hContainer, [xdata(:,1),ydata]);

          % Enable multiple row selection, auto-column resize, and auto-scrollbars
          table.setName(sheetName);
          table.setPreferredScrollableViewportSize(java.awt.Dimension(tpos(1)-20,16))
          table.setSelectionMode(javax.swing.ListSelectionModel.MULTIPLE_INTERVAL_SELECTION);
          %table.setAutoResizeMode(table.AUTO_RESIZE_SUBSEQUENT_COLUMNS)
          sp = com.mathworks.widgets.spreadsheet.SpreadsheetScrollPane(table);
          tableSize = java.awt.Dimension(tpos(1)-5,tpos(2)-35);
          sp.setPreferredSize(tableSize);
          sp.setVerticalScrollBarPolicy(sp.VERTICAL_SCROLLBAR_AS_NEEDED);      %_ALWAYS
          sp.setHorizontalScrollBarPolicy(sp.HORIZONTAL_SCROLLBAR_AS_NEEDED);  %_ALWAYS
          %sp.setRowHeader([]);  % removes problematic row headers (at left of table)

          % Loop over all data fields and set the column colors
          if nargin > 6
              columns = table.getColumnModel;
              color = getRGB(color);
              columns.getColumn(0).setHeaderValue(['<html><b>' xAxisName '</b></html>']);
              for fieldIdx = 1 : length(yHeaders)
                  columns.getColumn(fieldIdx).setHeaderValue(['<html><b><font color="#' color(fieldIdx,:) '">' yHeaders{fieldIdx} '</font></b></html>']);
              end
          end

          % Add the table to the tab pane
          panel.add(sp);

          % Store table & ScrollPane for use in resizing
          userdata.tables(end+1) = handle(table);
          userdata.scroll(end+1) = handle(sp);
          set(acx, 'userdata',userdata);

          % Set the focus, to force an immediate repaint
          acx.requestFocus;
          drawnow;
          return;
      end

      % Default color = Black
      if nargin<7
          color(1:numLines) = getBGR([0,0,0]);  % [0,0,0] = Black
      end

      %[R,C] = size(data);
      C = numLines + 1;
      if ischar(xdata{1,1})
          R = size(xdata,1);
      else
          R = length(xdata{1});
      end

      % Set headers into the spreadsheet
      % TODO: handle case of non-aligned x-data (i.e., xdata(:,1)~=xdata(:,2))
      %acx.Range(['B1:' nn2an(1,C+1)]).Select;
      selection = selectRange(acx,['B1:' nn2an(1,C+1)]);
      selection.Value = [xAxisName yHeaders];
      set(selection.Font,'Bold',1);
      set(selection.Font,'Color',hex2dec('0000FF'));  % Red
      set(invoke(selection.Border,'Item',4), 'Weight',3);
      selection.HorizontalAlignment = -4108;  % =xlCenter

      % Insert the stats section
      statNames = {'min';'max';'average';'median';'stdev';'counta'};
      numStats = length(statNames);
      setWorksheetStats(acx, C, statNames);

      % Set the actual data
      % TODO: handle case of non-aligned x-data (i.e., xdata(:,1)~=xdata(:,2))
      %data = mat2cell(data, repmat(1,1,R), repmat(1,1,C));
      %acx.Range(['B' num2str(2+numStats) ':' nn2an(R+numStats,C+1)]).Value = data;
      
      % X column data:
      if ~ischar(xdata{1,1}) & ~iscell(xdata{1,1})  %#ok ML6
          xdata = mat2cell(xdata{1}(:,1), repmat(1,1,R), 1);
      end
      %acx.Range([nn2an(2+numStats,2) ':' nn2an(R+1+numStats,2)]).Value = xdata;
      range = selectRange(acx,[nn2an(2+numStats,2) ':' nn2an(R+1+numStats,2)]);
      range.Value = xdata;

      % Y column(s) data:
      if (numLines > 0)
          if (size(ydata{1},1) == R)
              for lineIdx = 1 : numLines
                  % Enter the data
                  data = ydata{:,lineIdx};
                  if ~iscell(data)
                      data = mat2cell(data, repmat(1,1,R), 1);
                  end

                  % Empty & NaN cells are NOT accepted by XLS ActiveX => 1x0 single...
                  [data{cellfun('isempty', data)}] = deal(single(zeros(1,0)));
                  %nanIdx = cellfun(@(x)(~isempty(x) & isnumeric(x) & isnan(x)), data);  %#ok ML6 - annonymous funcs invalid in ML6
                  nanIdx = [];
                  for cellIdx = length(data) : -1 : 1
                      x = data{cellIdx};
                      nanIdx(cellIdx) = ~isempty(x) & isnumeric(x) & isnan(x);  %#ok mlint
                  end
                  nanIdx(nanIdx==0) = [];  %#ok mlint
                  [data{nanIdx}] = deal(single(zeros(1,0)));

                  % Set the data into the relevant worksheet cell range
                  %acx.Range([nn2an(2+numStats,lineIdx+2) ':' nn2an(R+1+numStats,lineIdx+2)]).Select;
                  selection = selectRange(acx,[nn2an(2+numStats,lineIdx+2) ':' nn2an(R+1+numStats,lineIdx+2)]);
                  selection.Value = data;
                  set(selection.Font,'Color',color(lineIdx));

                  % Fix stats formulae in case of non-finite numeric values (Inf, NaN, ...)
                  numericIdx = myCellfun(@isnumeric, data);
                  if all(numericIdx)
                      [data{cellfun('isempty', data)}] = deal(0);  % empty cells are ok => set to 0=finite
                      isf = myCellfun(@isfinite, data);
                      if ~all(isf)
                          ed = diff(isf);
                          ed(find(ed==1)+1) = -2;  % start position of finite-data spans
                          edg = find(ed<0);
                          if ~isempty(edg)
                              if (ed(edg(1))==-1),  edg = [1,edg];  end;  %#ok mlint
                              if (ed(edg(end))==-2),  edg(end+1) = length(data);  end  %#ok mlint
                              edg = edg + 1 + length(statNames);
                              %rcPos = arrayfun(@(n)([n2a(lineIdx+2) num2str(n)]),edg,'uniformoutput',0);  % annonymous funcs invalid in ML6
                              rcPos = {};
                              for arrayIdx = length(edg) : -1 : 1
                                  rcPos{arrayIdx} = [n2a(lineIdx+2) num2str(edg(arrayIdx))];  %#ok mlint
                              end
                              spansStr = '';
                              for idx = 1 : 2 : length(edg)
                                  if ~isempty(spansStr),  spansStr(end+1)=',';  end  %#ok mlint
                                  spansStr = [spansStr, rcPos{idx} ':' rcPos{idx+1}];  %#ok mlint
                              end
                              setWorksheetStats(acx, C, statNames, lineIdx+2, spansStr);
                          end
                      end
                  end
              end
          else
              error('X (%d) and Y (%d) lengths mismatch in "%s"', R, size(ydata{1},1), titleStr);
          end
      else
          disp(['No Y data in "' titleStr '"']);
      end

      % Set focus on top-left (A1) cell
      %acx.Range('A1').Select;
      selectRange(acx,'A1');

%% Prepare java data table
function [tablePeer table] = prepareJTable(columnNames,colWidth,hContainer,data)
      persistent jideTableUtils

      % Prepare the data table
      numCols = length(columnNames);
      if nargin < 4
          %data = mat2cell(magic(numCols),ones(1,numCols),ones(1,numCols));
          %data = [data;data;data];
          %for rowIdx = 1 : size(data,1)
          %    data{rowIdx,1} = java.lang.Boolean(mod(rowIdx,2));  % checkbox = boolean
          %    data{rowIdx,2} = int16(data{rowIdx,2});             % ID = int16
          %    data{rowIdx,3} = 0.5 + data{rowIdx,3};              % double
          %    data{rowIdx,4} = ['yes' num2str(data{rowIdx,3})];   % string
          %end
          data = mat2cell(zeros(0,numCols),ones(1,0),ones(1,numCols));
      else
          data = cell2mat(data);
          data = mat2cell(data,ones(1,size(data,1)),ones(1,size(data,2)));
      end
      %tablePeer = uitable(hFig, 'NumRows',0, 'Data',data, 'ColumnNames',colNames);
      %table = JTable(2,numCols);
      %table = JTable({},colNames);
      data_model = javax.swing.table.DefaultTableModel;
      data_model.setColumnCount(numCols);
      tablePeer = com.mathworks.hg.peer.UitablePeer(data_model);
      tablePeer.setData(data);
      table = tablePeer.getTable();

      % Auto-resize columns
      try
          % Try JIDE features - see http://www.jidesoft.com/products/JIDE_Grids_Developer_Guide.pdf
          if isempty(jideTableUtils)
              com.mathworks.mwswing.MJUtilities.initJIDE;
              jideTableUtils = eval('com.jidesoft.grid.TableUtils;');  % prevent JIDE alert by run-time (not load-time) evaluation
          end
          jideTableUtils.autoResizeAllColumns(table);
      catch
          % JIDE is probably unavailable - never mind...
      end

      % Fix for JTable focus bug : see http://bugs.sun.com/bugdatabase/view_bug.do;:WuuT?bug_id=4709394
      % Taken from: http://xtargets.com/snippets/posts/show/37
      table.putClientProperty('terminateEditOnFocusLost', java.lang.Boolean.TRUE);

      % We want to use sorter, not data model...
      % unfortunately, UitablePeer expects DefaultTableModel (not TableSorter) so we need a modified UitablePeer class
      % however, UitablePeer is a Matlab class, so instead let's use a modified TableSorter and attach it to the Model
      % Note: TableSorter is available for download at http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=14225
      if ~isempty(which('TableSorter'))
          sorter = TableSorter(data_model);
          table.setModel(sorter);
          tablePeer.setTableModel(sorter);
          sorter.setTableHeader(table.getTableHeader());
          table.getTableHeader.setToolTipText('<html>&nbsp;<b>Click</b> to sort up; <b>Shift-click</b> to sort down<br>&nbsp;<b>Ctrl-click</b> (or <b>Ctrl-Shift-click</b>) to sort secondary&nbsp;<br>&nbsp;<b>Click again</b> to change sort direction<br>&nbsp;<b>Click a third time</b> to return to unsorted view<br>&nbsp;<b>Right-click</b> to select entire column</html>');
      end

      % Some more administrative stuff...
      tablePeer.setUIContainer(hContainer);
      tablePeer.setColumnNames(columnNames);
      pause(.1);  % pause a bit otherwise the next line might run before all headers were set
      tablePeer.setColumnWidth(colWidth);

      % hide grid-lines
      table.setGridColor(java.awt.Color.white);

%% General worksheet stats, which are good for all input source types
function setWorksheetStats(acx, numCols, statNames, colNum, spanStr)
      % Stats column and data area
      numStats = length(statNames);
      endRow = num2str(1+numStats);
      %acx.Range(['A2:A' endRow]).Value = statNames;
      range = selectRange(acx,['A2:A' endRow]);
      range.Value = statNames;
      col = acx.Columns(1);
      invoke(col,'AutoFit');  % auto fit entire table (BEFORE any data is inserted!)
      startCol = 'B';
      endCol = n2a(numCols+1);
      if nargin>3
          startCol = n2a(colNum);
          endCol = startCol;
      end
      if nargin<5
          spanStr = ['b' num2str(2+numStats) ':b65536'];
      end

      % Repeat for all requested stats (one beneath the other)
      for statIdx = 1 : numStats
          rowStr = num2str(1+statIdx);
          %acx.Range([startCol rowStr ':' endCol rowStr]).Formula = ['=' statNames{statIdx} '(' spanStr ')'];
          range = selectRange(acx,[startCol rowStr ':' endCol rowStr]);
          range.Formula = ['=' statNames{statIdx} '(' spanStr ')'];
      end

      % Solid border line beneath bottom stat line
      %acx.Range([startCol endRow ':' endCol endRow]).Border.Item(4).Weight = 3;
      range = selectRange(acx,[startCol endRow ':' endCol endRow]);
      set(invoke(range.Border,'Item',4),'Weight',3);

      % Silver color for all stats
      %acx.Range([startCol '2:' endCol endRow]).Font.Color = hex2dec('C0C0C0');  % silver
      range = selectRange(acx,[startCol '2:' endCol endRow]);
      set(range.Font,'Color',hex2dec('C0C0C0'));  % silver

%% Convert RC format to 'A1' format
function cr = nn2an(r,c)
      cr = [n2a(c), num2str(r)];

%% Convert col # format to 'A','B','C' format
% Thanks Brett Shoelson, via CSSM
function colStr = n2a(c)
      t = [floor((c-1)/26)+64, rem(c-1,26)+65];
      if (t(1)<65), t(1) = []; end
      colStr = char(t);

%% Set figure name
function setFigureName(hFig, varargin)
      % If valid source plot figure handle, dataStruct or a simple name
      if nargin>1 & iscell(varargin) & ~isempty(varargin{1})  %#ok ML6
          if ishandle(varargin{1}(1))  % figure handle
              hSrcFig = varargin{1}(1);
              set(hFig,'Name', get(hSrcFig,'Name'));
          elseif ischar(varargin{1})  % figure name
              set(hFig,'Name', varargin{1});
          else
              %error(['Very odd input to plotdata: ' char(varargin{1})]);
          end
      else
          % Do nothing - error message will be presented shortly after
      end

%% Executes on button press in cbStats.
function cbStats_Callback(varargin)  %#ok
      % Hint: get(hObject,'Value') returns toggle state of cbStats
      newValue = get(gcbo,'Value');

      % Loop over all worksheets
      hActiveX = get(gcbf, 'UserData');
      if isnumeric(hActiveX)
          hActiveX = activex(hActiveX);  % old ML6 format
      end
      sheets = hActiveX.Sheets;
      for sheetIdx = 1 : sheets.Count
          thisSheet = invoke(sheets,'Item',sheetIdx);

          % Show/hide Column A (stats headers)
          %thisSheet.Range('A:A').EntireColumn.Hidden = ~newValue;
          range = selectRange(thisSheet,'A:A');
          set(range.EntireColumn,'Hidden',~newValue);

          % Show/hide rows #2-N (stats data)
          range = selectRange(thisSheet,'A2');
          lastCell = invoke(range,'End','xlDown');
          numStats = min(50,lastCell.Row);
          %statRows = thisSheet.Range(['$2:$' num2str(numStats)]).EntireRow;
          range = selectRange(thisSheet,['$2:$' num2str(numStats)]);
          statRows = range.EntireRow;
          statRows.Hidden = ~newValue;
          invoke(statRows,'Select');  % displays the rows when unhiding (setting Hidden=0 is not enough...)

          % If stats were unhidden, then display column A (otherwise you'd need to scroll left...)
          if newValue
              %thisSheet.Range('A1').Select;
              selectRange(thisSheet,'A1');
          else
              %thisSheet.Range('B1').Select;
              selectRange(thisSheet,'B1');
          end
      end

%% Cellfun replacement for old Matlab versions
function results = myCellfun(func, data)
      v = version;
      if str2double(v(1:3)) >= 7.1
          results = cellfun(func, data);  %#ok ML6
      else
          results = [];
          for cellIdx = length(data) : -1 : 1
              x = data{cellIdx};
              results(cellIdx) = feval(func,x);  %#ok mlint
          end
          results(results==0) = [];
      end

%% Figure resize callback function (needed for ML6, where the ActiveX container is not available to have its units set to 'normalized')
function figResizeFcn(varargin)
  try
      hFig = gcbf;
      hFigPos = getPixelPos(hFig);
      newPos = [0,0,hFigPos(3:4)];
      hActiveX = get(hFig, 'UserData');
      if isjava(hActiveX)

          % Compute the new table & ScrollPane sizes
          ud = get(hActiveX,'userdata');
          newSizeTp = hActiveX.getSize;
          newWidth  = newSizeTp.getWidth() - 10;
          newHeight = newSizeTp.getHeight() - 17 * (hActiveX.getTabRunCount()+1);
          newSize = java.awt.Dimension(newWidth, newHeight);

          % Loop over all tabs and modify the displayed table & viewport
          matlabVersion = str2double(regexprep(version,'^(\d+\.\d+).*','$1'));
          for tabIdx = 1 : length(ud.tables)
              try
                  ud.tables(tabIdx).getTable.setPreferredScrollableViewportSize(newSize);
              catch
                  ud.tables(tabIdx).setPreferredScrollableViewportSize(newSize);
              end
              ud.tables(tabIdx).revalidate;
              ud.scroll(tabIdx).setPreferredSize(newSize);
              if matlabVersion >= 7.2
                  ud.scroll(tabIdx).setSize(newSize);
              end
          end

          % Modify the table column widths
          %updateTablesWidth(ud.tables,hActiveX);

          % TODO: Fix problem when scrolling right/left and tabs overlap/de-overlap causing less/more available height
          % Note: drawnow or repaint() don't seem to work...
          %start(timer('TimerFcn',@figResizeFcn,'StartDelay',.5));

          % Set the focus, to force an immediate repaint
          pause(0.05);
          hActiveX.requestFocus;
          drawnow;
      elseif ~isempty(hActiveX)
          if isnumeric(hActiveX)
              hActiveX = activex(hActiveX);  % old ML6 format
          end
          move(hActiveX,newPos);  % hActiveX is more readable, but invalid in ML6...
      end
  catch
      % never mind...
  end

%% Matlab6 replacement for the unsupported ActiveX Range interface (failed attempt...)
function rangeObj = selectRange(app,rangeStr)
      rangeObj = invoke(app,'Range',rangeStr);  %Range() is unsupported on ML6...
      %rangeStr = invoke(app,'ConvertFormula',rangeStr,1,-4150,1);  % fails! ConvertFormula() & Goto() only available on XLS server - not ActiveX...
      %invoke(app,'Goto',rangeStr);
      %rangeObj = app.Selection;
      invoke(rangeObj,'Select');
