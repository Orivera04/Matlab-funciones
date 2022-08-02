function varargout = clustergram(data,varargin)
%CLUSTERGRAM creates a dendrogram and heat map on the same figure.
%
%   CLUSTERGRAM(DATA) creates a dendrogram and heat map from DATA using
%   hierarchical clustering with correlation as the distance metric and
%   average linkage used to generate the hierarchical tree. The clustering
%   is performed on the rows of DATA. The rows of DATA are typically genes
%   and the column are the results from different microarrays.  To cluster
%   the columns instead of the rows, transpose the data using the '
%   operator. 
%
%   CLUSTERGRAM(...,'ROWLABELS',ROWLABELS) uses the contents of cell array
%   ROWLABELS as labels for the rows in DATA. 
%
%   CLUSTERGRAM(...,'COLUMNLABELS',COLUMNLABELS) uses the contents of cell
%   array COLUMNLABELS as labels for the columns in DATA. 
%
%   CLUSTERGRAM(...,'PDIST',DISTANCE) allows you to set the distance metric
%   used by PDIST, the function used to calculate pairwise distance between
%   observations. If the distance metric requires extra arguments then
%   these should be passed as a cell array, for example to use the
%   Minkowski distance with exponent P you would use {'minkowski', P}. See
%   the help for PDIST for more details of the available options. The
%   default distance metric for CLUSTERGRAM is 'correlation'. 
%
%   CLUSTERGRAM(...,'LINKAGE',METHOD) allows you to select the linkage
%   method used by LINKAGE, the function used to create the hierarchical
%   cluster tree. See the help for LINKAGE for more details of the 
%   available options. The default linkage method used by CLUSTERGRAM is
%   'average' linkage.
%
%   CLUSTERGRAM(...,'DENDROGRAM',DENDARGS) allows you to pass arguments to
%   the DENDROGRAM, the function used to create the dendrogram. DENDARGS
%   should be a cell arrays of parameter/value pairs that can be passed to
%   DENDROGRAM. See the help for DENDROGRAM for more details of the
%   available options.
%
%   CLUSTERGRAM(...,'COLORMAP',CMAP) allows you to specify the colormap
%   that will be used for the figure containing the clustergram. This will
%   control the colors used to display the heat map. It can be the name or
%   function  handle of a function that returns a colormap, or an M by 3
%   array  containing RGB values. The default is REDGREENCMAP.
%
%   CLUSTERGRAM(...,'SYMMETRICRANGE',FALSE) disables the default behavior
%   of forcing the color scale of the heat map to be symmetric about zero.
%
%   CLUSTERGRAM(...,'DIMENSION',DIM) allows you to specify whether to
%   create a  one-dimensional or two-dimensional clustergram. The options
%   are 1 or 2. The default value is 1. The one-dimensional clustergram
%   will cluster the  rows of the data. The two-dimensional clustergram
%   creates the one-dimensional  clustergram, and then clusters the columns
%   of the row-clustered data.
%
%   CLUSTERGRAM(...,'RATIO',R) allows you to specify the ratio of the space
%   that the dendrogram(s) will use, relative to the size of the heat map,
%   in the X and Y directions. If R is a single scalar value, it is used as
%   the ratio for both directions. If R is a two-element vector, the first
%   element is used for the X ratio, and the second element is used for the
%   Y ratio. The Y ratio is ignored for one-dimensional clustergrams. The
%   default ratio is 1/5. 
%
%   Hold the mouse button down over the image to see the exact values at a
%   particular point.
%
%   Examples:
%
%       load filteredyeastdata; 
%       clustergram(yeastvalues);
%
%       % Add some labels.
%       clustergram(yeastvalues,'ROWLABELS',genes,'COLUMNLABELS',times);
%
%       % Change the clustering parameters.
%       clustergram(yeastvalues,'PDIST','euclidean','LINKAGE','complete');
%
%       % Change the dendrogram color parameter.
%       clustergram(yeastvalues,'ROWLABELS',genes,'DENDROGRAM',{'color',5});
%
%   See also DENDROGRAM, LINKAGE, PDIST, REDGREENCMAP.

% Copyright 2003-2004 The MathWorks, Inc.
% $Revision: 1.14.6.10 $   $Date: 2004/01/24 09:18:13 $

%  More sample data is available from MATLAB Central
% http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=2442&objectType=file
%
%       load naturedata
%       clustergram(data,'ROWLABELS',drugNames,cellLines,{'corr'},{'average'})
%       colormap(jet)

if  nargin < 1
    % get some data -- makeRandomData creates somewhat structured data that
    % looks pretty when clustered
    [data, rowLabels, colLabels ] = makeRandomData;
else
    colLabels = cell(size(data,2),1);
    rowLabels = cell(size(data,1),1);
end

% defaults
clustStruct.data = data;
clustStruct.rowLabels = rowLabels;
clustStruct.colLabels = colLabels;
clustStruct.pdistargs = {'euc'};
clustStruct.linkageargs = {'average'};
clustStruct.dendroargs = {'colorthreshold',0.7};
clustStruct.colormap = redgreencmap(64);
clustStruct.ratio = [1/5 1/5];
clustStruct.onedimension = true;
clustStruct.fullwidth = .72;
clustStruct.fullheight = .85;
clustStruct.zeroCenter = true;
clustStruct.reuse = false;

if nargin > 1
    if rem(nargin,2) == 0
        error('Bioinfo:IncorrectNumberOfArguments',...
            'Incorrect number of arguments to %s.',mfilename);
    end
    okargs = {'rowlabels','columnlabels','pdist','linkage','dendrogram',...
        'colormap','dimension','ratio','symmetricrange','reuse'};
    for j=1:2:nargin-1
        pname = varargin{j};
        pval = varargin{j+1};
        k = strmatch(lower(pname), okargs);
        if isempty(k)
            error('Bioinfo:UnknownParameterName',...
                'Unknown parameter name: %s.',pname);
        elseif length(k)>1
            error('Bioinfo:AmbigousParameterName',...
                'Ambiguous parameter name: %s.',pname);
        else
            switch(k)
                case 1  % rowlabels
                    clustStruct.rowLabels = pval;
                    if isnumeric(rowLabels)
                        clustStruct.rowLabels = cellstr(num2str(clustStruct.rowLabels(:)));
                    end
                case 2  % column labels
                    clustStruct.colLabels = pval;
                    if isnumeric(clustStruct.colLabels)
                        clustStruct.colLabels = cellstr(num2str(clustStruct.colLabels(:)));
                    end
                case 3  % pdist args
                    if iscell(pval)
                        clustStruct.pdistargs = pval;
                    else
                        clustStruct.pdistargs = {pval};
                    end
                case 4  % linkage args
                    if iscell(pval)
                        clustStruct.linkageargs = pval;
                    else
                        clustStruct.linkageargs = {pval};
                    end
                case 5  % dendrogram args
                    if iscell(pval)
                        clustStruct.dendroargs = pval;
                    else
                        clustStruct.dendroargs = {pval};
                    end
                case 6 % colormap
                    
                    validcmap = true;
                    if ischar(pval)
                        cmap = eval(pval);
                    elseif isa(pval,'function_handle')
                        cmap = feval(pval);
                    elseif isnumeric(pval)
                        cmap = pval;
                    else
                        validcmap = false;
                    end
                    
                    if ~validcmap || ndims(cmap) ~= 2 || size(cmap,2) ~= 3
                        error('Bioinfo:InvalidClustergramColormap','Invalid colormap')
                    end
                    
                    clustStruct.colormap = cmap;
                case 7 % dimension args
                    if pval == 2
                        clustStruct.onedimension = false;
                    elseif pval == 1
                        clustStruct.onedimension = true;
                    else
                        error('Bioinfo:InvalidClustergramDimension','Invalid dimension specified: %d',pval);
                    end
                case 8 % ratio args                    
                    numpval = numel(pval);
                    if ~isa(pval,'double') 
                        error('Bioinfo:InvalidClustergramRatioClass','Ratio must be a double.');
                    elseif numpval ~= 1 && numpval ~= 2
                        error('Bioinfo:InvalidClustergramRatioSize','Ratio must have 1 or 2 elements.');
                    elseif ~all(pval > 0 & pval < 1);
                        error('Bioinfo:InvalidClustergramRatioValue','Ratio must be between 0 and 1.')
                    end                    
                    if numpval == 1
                        clustStruct.ratio = [pval pval];
                    else
                        clustStruct.ratio = pval;
                    end
                case 9 % symmetric range -- whether or not to center color range about 0
                    zeroCenterFlag = opttf(pval);
                    if ~isa(pval,'logical') || numel(pval) ~= 1
                        error('Bioinfo:InputOptionNotLogicalScalar','%s must be a logical scalar, true or false.',...
                            upper(char(okargs(k)))); 
                    end   
                    clustStruct.zeroCenter = zeroCenterFlag;
                case 10 % reuse - whether to reuse the same figure
                    if ~isa(pval,'logical') || numel(pval) ~= 1
                        error('Bioinfo:InputOptionNotLogicalScalar','%s must be a logical scalar, true or false.',...
                            upper(char(okargs(k)))); 
                    end
                    clustStruct.reuse = pval;
            end
        end
    end
end

if clustStruct.onedimension
    [hAxes,hImage,hDen] = create1DClustergram(clustStruct);
else
    [hAxes,hImage,hDen] = create2DClustergram(clustStruct);
end

% set the HandleVisibility for the tree lines off
hLines = findobj(hAxes,'Type','line');
set(hLines,'HandleVisibility','off');
 
set(hAxes,'TickLength',[0 0])

if ~clustStruct.reuse
    set(get(hAxes(1),'Parent'),'HandleVisibility','callback');
end

if nargout
    varargout{1} = hAxes;
    varargout{2} = hImage;
    varargout{3} = hDen;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [data, rowLabels, colLabels ] = makeRandomData
%makeRandomData creates some random data 

data = sort(randn(26,4)); 
data = data(randperm(size(data,1)),:);

rowLabels = cellstr([ repmat('Row ',26,1) char(('A' + (0:25))')]);
colLabels = {'Col One','Col Two','Col Three','Col Four'};


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function localMotionCallback(varargin)

hFig = localCleanUpLabel(varargin{1});

imageHandle = varargin{3};
if hittest(hFig) ~= imageHandle
    return
end

htext = varargin{4};

% get the labels from the image's UserData
ud = get(imageHandle,'UserData');
colLabels = ud.colLabels;
rowLabels = ud.rowLabels;

% Cdata is the actual values of the image
cdata = get(imageHandle,'Cdata');
xdata = get(imageHandle,'XData');
ydata = get(imageHandle,'YData');

% get the handle for the axes
imageAxes = get(imageHandle,'parent');

% get the position on the image.
cpAct = get(imageAxes,'CurrentPoint');

% determine where in axes was clicked
x = cpAct(1,1);
y = cpAct(1,2);

% calculate indices into image CData
xind = round(x);
yind = round(y);

try
    % get the value and labels of the current point
    val = num2str(cdata(yind,xind));
    if isempty(rowLabels{yind})
        rowLabel = '';
    else
        rowLabel = rowLabels(yind);
    end
    if isempty(colLabels{xind})
        colLabel = '';
    else
        colLabel = colLabels(xind);
    end 
    
    % create a new text object -- start with it invisible
    textstr = {};
    if ~isempty(val)
        textstr = [textstr {val}];
    end
    if ~isempty(colLabel)
        textstr = [textstr {char(colLabel)}];
    end    
    if ~isempty(rowLabel)
        textstr = [textstr {char(rowLabel)}];
    end       
    
    if isempty(htext) || ~ishandle(htext)
        % give it an off white background, black text and grey border
        htext = text(x,y,textstr,...
                          'Visible','off',...
                          'BackgroundColor', [1 1 0.933333],...
                          'Color', [0 0 0],...
                          'EdgeColor', [0.8 0.8 0.8],...
                          'Tag','ImageDataTip',...
                          'interpreter','none');  
    end

    
    
    % determine the offset in pixels
    set(htext,'position',[x y]);
    xy = [x y];
    %meanxy = [mean(xdata) mean(ydata)];
    meanxy = [mean(xlim(imageAxes)) mean(ylim(imageAxes))];
    setTextLocation(htext,xy,meanxy)
     
    
    % show the text    
    set(htext, 'Visible','on')
    set(hFig,'WindowButtonUpFcn',{@localToggleOff,imageHandle,htext});
catch
    % quietly do nothing if something is out of range
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function varargout = localCleanUpLabel(varargin)
%localCleanUpLabel callback function to remove label from image

% get the handles to the figure, image and axis
if nargin == 0
    hFig = gcbf;
elseif ishandle(varargin{1}) 
    if strcmp('figure',get(varargin{1},'Type'))    
        hFig = varargin{1};
    elseif strcmp('image',get(varargin{1},'Type'))
        hAxes = get(varargin{1},'Parent');
        hFig = get(hAxes,'Parent');
    end
end

% delete the old label if it exists
oldLabel = findobj(hFig,'Tag','ImageDataTip','Type','text');
if ~isempty(oldLabel)
    delete(oldLabel);
end

if nargout
    varargout{1} = hFig;
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function local1DImageButtonCallback(varargin)
% localImageButtonCallback
% shows labels and values at selected point.

% clean up any old labels
hFig = localCleanUpLabel(varargin{1});

imageHandle = findobj(hFig,'type','image','Tag','ClusterGramHeatMap');

% get the labels from the image's UserData
ud = get(imageHandle,'UserData');
colLabels = ud.colLabels;
rowLabels = ud.rowLabels;

% Cdata is the actual values of the image
cdata = get(imageHandle,'Cdata');
xdata = get(imageHandle,'XData');
ydata = get(imageHandle,'YData');

% get the handle for the axes
imageAxes = get(imageHandle,'parent');

% get the position on the image.
cpAct = get(imageAxes,'CurrentPoint');

% determine where in axes was clicked
x = cpAct(1,1);
y = cpAct(1,2);

% calculate indices into image CData
xind = round(x);
yind = round(y);

try
    % get the value and labels of the current point
    val = num2str(cdata(yind,xind));
    if isempty(rowLabels{yind})
        rowLabel = '';
    else
        rowLabel = rowLabels(yind);
    end
    if isempty(colLabels{xind})
        colLabel = '';
    else
        colLabel = colLabels(xind);
    end 
    
    % create a new text object -- start with it invisible
    textstr = {};
    if ~isempty(val)
        textstr = [textstr {val}];
    end
    if ~isempty(colLabel)
        textstr = [textstr {char(colLabel)}];
    end    
    if ~isempty(rowLabel)
        textstr = [textstr {char(rowLabel)}];
    end       
    
    htext = text(x,y,textstr,'visible','off');
    
    % give it an off white background, black text and grey border
    set(htext, 'BackgroundColor', [1 1 0.933333],...
        'Color', [0 0 0],...
        'EdgeColor', [0.8 0.8 0.8],...
        'Tag','ImageDataTip',...
        'interpreter','none');
    
    
    % determine the offset in pixels
    set(htext,'position',[x y]);   
    xy = [x y];
    % meanxy = [mean(xdata) mean(ydata)];
    meanxy = [mean(xlim(imageAxes)) mean(ylim(imageAxes))];
    setTextLocation(htext,xy,meanxy)
     
    
    % show the text    
    set(htext, 'Visible','on')
    set(hFig,'WindowButtonMotionFcn',{@localMotionCallback,imageHandle,htext});    
    set(hFig,'WindowButtonUpFcn',{@localToggleOff,imageHandle,htext});
catch
    % quietly do nothing if something is out of range
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function local2DImageButtonCallback(varargin)
% localImageButtonCallback
% shows labels and values at selected point.

% clean up any old labels
hFig = localCleanUpLabel(varargin{1});

imageHandle = findobj(hFig,'type','image','tag','ClusterGramHeatMap');

% get the labels from the image's UserData
ud = get(imageHandle,'UserData');
colLabels = ud.colLabels;
rowLabels = ud.rowLabels;

% Cdata is the actual values of the image
cdata = get(imageHandle,'Cdata');
xdata = get(imageHandle,'XData');
ydata = get(imageHandle,'YData');

% get the handle for the axes
imageAxes = get(imageHandle,'parent');

% get the position on the image.
cpAct = get(imageAxes,'CurrentPoint');

% determine where in axes was clicked
x = cpAct(1,1);
y = cpAct(1,2);

% calculate indices into image CData
xind = round(x);
yind = floor(y + .5);

try
    % get the value and labels of the current point
    val = num2str(cdata(yind,xind));
    if isempty(rowLabels{yind})
        rowLabel = '';
    else
        rowLabel = rowLabels(yind);
    end
    if isempty(colLabels{xind})
        colLabel = '';
    else
        colLabel = colLabels(xind);
    end    
       
    % create a new text object -- start with it invisible
    textstr = {};
    if ~isempty(val)
        textstr = [textstr {val}];
    end
    if ~isempty(colLabel)
        textstr = [textstr {char(colLabel)}];
    end    
    if ~isempty(rowLabel)
        textstr = [textstr {char(rowLabel)}];
    end       
    
    htext = text(x,y,textstr,'visible','off');
    
    % give it an off white background, black text and grey border
    set(htext, 'BackgroundColor', [1 1 0.933333],...
                   'Color', [0 0 0],...
                   'EdgeColor', [0.8 0.8 0.8],...
                   'Tag','ImageDataTip',...
                   'interpreter','none');    
    
    % determine the offset in pixels
    set(htext,'position',[x y]);
    xy = [x y];
    % meanxy = [mean(xdata) mean(ydata)];
    meanxy = [mean(xlim(imageAxes)) mean(ylim(imageAxes))];
    setTextLocation(htext,xy,meanxy)
     
    % show the text
    set(htext, 'Visible','on')
    set(hFig,'WindowButtonMotionFcn',{@localMotionCallback,imageHandle,htext});
    set(hFig,'WindowButtonUpFcn',{@localToggleOff,imageHandle,htext});
catch
    % quietly do nothing if something is out of range
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [hFig] = localToggleOff(varargin)
%LOCALTOGGLEOFF callback function to remove disable dragging of labels

hFig = varargin{1};

% clean up the labels
localCleanUpLabel;

imageHandle =varargin{3};

ud = get(imageHandle,'UserData');
if ud.onedimension
    set(imageHandle,'ButtonDownFcn',@local1DImageButtonCallback);
else
    set(imageHandle,'ButtonDownFcn',@local2DImageButtonCallback);
end

set(hFig,'WindowButtonMotionFcn','');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function varargout = create1DClustergram(clustStruct)
 
% calculate pairwise distances and linkage
Y1 = pdist(clustStruct.data,clustStruct.pdistargs{:});
Z1 = linkage(Y1,clustStruct.linkageargs{:});

clustergramFigureHandle = [];

if clustStruct.reuse
    % use GCF to find a figure handle to use
    clustergramFigureHandle = gcf;
    % delete the axes
    delete(findall(clustergramFigureHandle,'type','axes'));
    % bring figure forward
    figure(clustergramFigureHandle);
else
    tmp = gcf;
    
    if isempty(findall(gcf,'type','axes'))
        % 
        clustergramFigureHandle = tmp;
        set(clustergramFigureHandle,'Tag','ClustergramFigure');
    else    
        % otherwise, create a new figure each time
        clustergramFigureHandle = figure('Tag','ClustergramFigure');
    end
end

% create dendrogram
[H1, T1, perm1] = dendrogram(Z1,0,clustStruct.dendroargs{:},'orientation','left'); %#ok

dAxes1 = get(H1(1),'Parent');

% make sure the dendrogram is in the proper figure
dAxes1Parent = get(dAxes1,'Parent');
if  clustStruct.reuse && dAxes1Parent ~= clustergramFigureHandle    
    set(dAxes1,'Parent',clustergramFigureHandle)
    delete(dAxes1Parent);
end

hFig = clustergramFigureHandle;
set(hFig,'DoubleBuffer','on',...
    'Tag','ClustergramFigure')

% Move the dendrogram to the left edge of the axes, make the axes larger
fullWidth = clustStruct.fullwidth;
fullHeight = clustStruct.fullheight;

dWidth = fullWidth * clustStruct.ratio(1);
if clustStruct.onedimension
    dHeight = fullHeight;
else
    dHeight = fullHeight * (1 - clustStruct.ratio(2));
end

dPos = [(1 - fullWidth)/2, (1 - fullHeight)/2, dWidth, dHeight];

set(dAxes1,'Position',dPos,...
    'Visible','off',...
    'YTick',[],...
    'XTick',[]);

% use a pretty colormap
set(hFig,'Colormap',clustStruct.colormap);

% we assume that the data is centred around zero 
if clustStruct.zeroCenter
    maxval = max(abs(clustStruct.data(:)));
    minval = -maxval;
else
    maxval = max(clustStruct.data(:));
    minval = min(clustStruct.data(:));
end
% determine the size of the image
nrows = size(clustStruct.data,1);
ncols = size(clustStruct.data,2);

imWidth = fullWidth-dWidth;
imHeight = dHeight;
imPos = [dPos(1) + dPos(3),dPos(2),imWidth,imHeight];

imAxes = axes('Parent',hFig,...
                       'Units','normalized',...
                       'Position',imPos);

hImage1 = imagesc(clustStruct.data(perm1,:),...
                              'Parent',imAxes,...
                              'Tag','ClustergramImage',...
                              [minval,maxval]);     

% Visible set to on by IMAGESC. Set to 'off'
set(imAxes,'Visible','off',...
                  'YDir','normal');

% make sure labels are in a column cell array
if size(clustStruct.rowLabels,2) ~= 1
    clustStruct.rowLabels = clustStruct.rowLabels';
end             

% store the labels in the UserData of the image
ud.rowLabels = clustStruct.rowLabels(perm1);
ud.colLabels = clustStruct.colLabels;

ud.onedimension = clustStruct.onedimension;

set(hImage1,'UserData',ud);

% put labels on the rows
if nrows < 200
    ytickvals = 1:nrows;
else
    ytickvals = [];
end

% put labels on the columns
if ncols < 25
    xtickvals =  1:ncols;
else
    xtickvals = [];
end

% get rid of the original row labels
t = findall(dAxes1,'Type','text','Tag','ClustergramRowLabel');
if ~isempty(t)
    delete(t)
end

% create text objects for labels
set(imAxes,'YTick',ytickvals,...
                  'YTickLabel',clustStruct.rowLabels(perm1),...
                  'XTick',xtickvals,...
                  'XTickLabel',clustStruct.colLabels,...
                  'Visible','on',...
                  'YAxisLocation','right');
              
% now wouldn't it be nice if we could click on the image to and get some
% information about the particular spot.

set(hImage1,'ButtonDownFcn',@local1DImageButtonCallback,'tag','ClusterGramHeatMap')

localSetupLabelsListeners(imAxes,hFig)

set(dAxes1,'NextPlot','replace')

bh = hggetbehavior(dAxes1,'Zoom');
set(bh,'Enable',false);

hYLimLink = linkprop([imAxes dAxes1],'YLim');
setappdata(imAxes,'ClustergramYLimLink',hYLimLink)

if nargout
    varargout{1} = [dAxes1 imAxes];
    varargout{2} = hImage1;
    varargout{3} = H1;
    varargout{4} = perm1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function varargout = create2DClustergram(clustStruct)

% create 1D first, to get axes, dendrogram and permutation index for data
[dAxes1,hImage1,H1,perm1] = create1DClustergram(clustStruct);

% calculate pairwise distances and linkage
Y2 = pdist(clustStruct.data(perm1,:)',clustStruct.pdistargs{:});
Z2 = linkage(Y2,clustStruct.linkageargs{:});

% create a new, invisible figure to hold the second dendrogram, before moving it to the
% existing figure
cgfig2 = figure('Visible','off'); % TODO
[H2, T2, perm2] = dendrogram(Z2,0,clustStruct.dendroargs{:},'orientation','top'); %#ok
hiddenAxes = get(H2(1),'Parent');


hFig1 = get(dAxes1(1),'Parent');
imAxes = get(hImage1,'Parent');
imPos = get(imAxes,'Position');

fullHeight = clustStruct.fullheight;
dHeight = fullHeight * clustStruct.ratio(2);
dPos = [imPos(1),imPos(2) + imPos(4),imPos(3), dHeight];
dAxes2 = axes('Parent',hFig1,...
                       'Units','normalized',...
                       'Position',dPos,...
                       'Visible','off',...
                       'XLim',get(hiddenAxes,'XLim'),...
                       'XTick',[],...
                       'YTick',[]);

                      

% move the dendrogram lines into the original axes
set(H2,'Parent',dAxes2)

% delete the invisible figure
delete(cgfig2);

% delete the existing image
delete(hImage1);

% use a pretty colormap
colormap(clustStruct.colormap);

% we assume that the data is centred around zero 
if clustStruct.zeroCenter
    maxval = max(abs(clustStruct.data(:)));
    minval = -maxval;
else
    maxval = max(clustStruct.data(:));
    minval = min(clustStruct.data(:));
end

% determine the size of the image
nrows = size(clustStruct.data,1);
ncols = size(clustStruct.data,2);

hImage2 = imagesc(clustStruct.data(perm1,perm2),...
    'Parent',imAxes,...
    'Tag','ClustergramImage',...
    [minval,maxval]);     

set(imAxes,'YDir','normal','Visible','off');

% make sure labels are in a column cell array
if size(clustStruct.rowLabels,2) ~= 1
    clustStruct.rowLabels = clustStruct.rowLabels';
end             

% store the labels in the UserData of the image
ud.rowLabels = clustStruct.rowLabels(perm1);
ud.colLabels = clustStruct.colLabels(perm2);

ud.onedimension = clustStruct.onedimension;

set(hImage2,'UserData',ud);

% fixDendrograms(H1,H2,hImage2,clustStruct.ratio);

% put labels on the rows
if nrows < 200
    ytickvals = 1:nrows;
else
    ytickvals = [];
end


% put labels on the columns
if ncols < 200
    xtickvals =  1:ncols;
else
    xtickvals = [];
end

% create text objects for labels
set(imAxes,'YTick',ytickvals,...
                  'YTickLabel',clustStruct.rowLabels(perm1),...
                  'XTick',xtickvals,...
                  'XTickLabel',clustStruct.colLabels(perm2),...
                  'Visible','on',...
                  'YAxisLocation','right');

% now wouldn't it be nice if we could click on the image to and get some
% information about the particular spot.

set(hImage2,'ButtonDownFcn',@local2DImageButtonCallback,'tag','ClusterGramHeatMap')

set(dAxes1,'NextPlot','replace')

bh = hggetbehavior(dAxes2,'Zoom');
set(bh,'Enable',false);

hXLimLink = linkprop([imAxes dAxes2],'XLim');
setappdata(imAxes,'ClustergramXLimLink',hXLimLink);

if nargout
    varargout{1} = [dAxes1 dAxes2 imAxes];
    varargout{2} = hImage2;
    varargout{3} = [H1;H2];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function setTextLocation(htext,xy,meanxy)

    textUnits = get(htext,'Units');
    set(htext,'Units','pixels')

    pixpos = get(htext,'Position');
    
    offsets = [0 0 0];
    
    % determine what quadrant the pointer is in
    quadrant= xy < meanxy;        
    
    if ~quadrant(1) 
        set(htext,'HorizontalAlignment','Right')
        offsets(1) = -4;
    else
        set(htext,'HorizontalAlignment','Left')
        offsets(1) = 16;
    end
    if quadrant(2) 
        set(htext,'VerticalAlignment','Bottom') 
        offsets(2) = 4;
    else
        set(htext,'VerticalAlignment','Top')
        offsets(2) = -4;
    end  
    
    set(htext,'Position',pixpos + offsets);
    set(htext,'Units',textUnits);
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function localSetupLabelsListeners(imAxes,hFig)  
% helper function to setsup listeners for the ylables, so we can detect if
% we would need to change the fontsize
hgp     = findpackage('hg');
axesC   = findclass(hgp,'axes');
figureC = findclass(hgp,'figure');
XLimListener = handle.listener(imAxes,axesC.findprop('XLim'),...
               'PropertyPostSet',{@localXLabelsListener,imAxes});
% listens when the Ylim of axes has changed
YLimListener = handle.listener(imAxes,axesC.findprop('YLim'),...
               'PropertyPostSet',{@localYLabelsListener,hFig,imAxes});           

% store the listeners
setappdata(hFig,'ClustergramListeners',[XLimListener YLimListener]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function localXLabelsListener(hSrc,event,imAxes)

%get(hSrc)
newXLim = get(event,'NewValue');

hImage = findobj(imAxes,'Type','image');
ud = get(hImage,'UserData');

if diff(newXLim) < 4 && ~isempty(ud) && isstruct(ud)
    xtickvals = ceil(newXLim(1)):floor(newXLim(2));
    xticklabels =  ud.colLabels(xtickvals); 
else
    xtickvals = [];
    xticklabels = '';
end

set(imAxes,'XTick',xtickvals,'XTickLabel',xticklabels);

   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function localYLabelsListener(hSrc,event,hFig,imAxes)
% Auto sizes the ylabels
ratio = max(get(hFig,'Position').*[0 0 0 1])/diff(get(imAxes,'YLim'));
set(imAxes,'Fontsize',min(9,ceil(ratio/1.5)));    % the gold formula
