function [hOut,hLines] = maimage(maStruct,fieldname,varargin)
%MAIMAGE displays a spatial image of microarray data.
%
%   MAIMAGE(X,FIELDNAME) displays an image of field FIELDNAME from
%   microarray data structure X.
%
%   MAIMAGE(...,'TITLE',TITLE) allows you to specify the title of the plot.
%   The default title is FIELDNAME.
%
%   MAIMAGE(...,'COLORBAR',false) creates an image without displaying a
%   colorbar.
%
%   MAIMAGE(...,Handle Graphics name/value) allows you to pass optional
%   Handle Graphics property name/property value pairs to the function.
%
%   H = MAIMAGE(...) returns the handle of the image.
%
%   [H,HLINES] = MAIMAGE(...) returns the handles of the lines used to
%   separate the different blocks in the image.
%
%   Examples:
%
%       madata = gprread('mouse_a1wt.gpr');
%       maimage(madata,'F635 Median');
%       figure;
%       maimage(madata,'F635 Median - B635','TITLE','Cy5 Channel FG - BG');
%       colormap hot
%
%   See also IMAGESC, MABOXPLOT, MAIRPLOT, MALOGLOG, MALOWESS.

% Copyright 2003-2004 The MathWorks, Inc.
% $Revision: 1.13.6.6 $   $Date: 2004/04/01 15:58:58 $

if ~isstruct(maStruct)
    error('Bioinfo:MAImageNotStruct',...
        'The first input to MAIMAGE must be a microarray structure.')
end

% only supports Affymetrix CEL, GPR, SPOT and ImaGene structure at the moment

if isfield(maStruct,'FullPathName') && ...
        ~isempty(strfind(upper(maStruct.FullPathName),'CEL'))
    % Affymetrix data
    if nargin < 2
        fieldname = 'Intensity';
    end
    maStruct = affytomastruct(maStruct,fieldname);

elseif isfield(maStruct,'Header')&& isfield(maStruct.Header,'Type') && ...
        (~isempty(strfind(maStruct.Header.Type,'GenePix')) ...
        || ~isempty(strfind(maStruct.Header.Type,'SPOT'))...
        || ~isempty(strfind(maStruct.Header.Type,'ImaGene')))
    if nargin < 2
        fieldname = maStruct.ColumnNames{1};
    end
else
    warning('Bioinfo:MAImageNotSupported',...
        'MAIMAGE only supports Affymetrix CEL, GenePix, SPOT and ImaGene format data.');
    if nargin < 2
        fieldname = maStruct.ColumnNames{1};
    end
end

titleString = '';
hgargs = {};
showColorbar = true;
rowLabels = {};
columnLabels = {};
if nargin > 2

    if rem(nargin,2)== 1
        error('Bioinfo:IncorrectNumberOfArguments',...
            'Incorrect number of arguments to %s.',mfilename);
    end
    okargs = {'title','colorbar','rowlabels','columnlabels'};
    for j=1:2:nargin-2
        pname = varargin{j};
        pval = varargin{j+1};
        k = strmatch(lower(pname), okargs); %#ok
        if isempty(k)
            % here we assume that these are handle graphics options
            hgargs{end+1} = pname;
            hgargs{end+1} = pval;
        elseif length(k)>1
            error('Bioinfo:AmbiguousParameterName',...
                'Ambiguous parameter name: %s.',pname);
        else
            switch(k)
                case 1 % title
                    titleString = pval;
                case 2 % colorbar
                    showColorbar = opttf(pval);
                    if isempty(showColorbar)
                        error('Bioinfo:InputOptionNotLogical','%s must be a logical value, true or false.',...
                            upper(char(okargs(k))));
                    end
                case 3 % rowlabels
                    if ~iscellstr(pval)
                        error('Bioinfo:InputOptionNotCellStr','%s must be a cell array of strings.',upper(char(okargs(k))));
                    end
                    if numel(pval) ~= size(maStruct.Indices,1)
                        error('Bioinfo:MAIMAGEIncorrectNumberOfRowLabels','The number of row labels must match the number of rows.');
                    end
                    rowLabels = pval;
                case 4 % columnlabels
                    if ~iscellstr(pval)
                        error('Bioinfo:InputOptionNotCellStr','%s must be a cell array of strings.',upper(char(okargs(k))));
                    end
                    if numel(pval) ~= size(maStruct.Indices,2)
                        error('Bioinfo:MAIMAGEIncorrectNumberOfColumnLabels','The number of column labels must match the number of columns.');
                    end
                    columnLabels = pval;
            end
        end
    end
end



col = find(strcmpi(maStruct.ColumnNames,fieldname));

if isempty(col)
    fields = char(maStruct.ColumnNames);
    fields(:,end+1) = repmat(sprintf('\n'),size(fields,1),1);
    error('Bioinfo:BadMAField',...
        'Unknown field name. Valid field names are:\n%s',fields');
end

theData = maStruct.Data(:,col);

% convert from blocks to global indices

ax = newplot;
fig = get(ax,'Parent');

hImage = imagesc(theData(maStruct.Indices),'Parent',ax,hgargs{:});
axis(ax,'image');

% set figure callbacks
set(fig,'WindowButtonDownFcn',{@localInfoOn,hImage},...
        'WindowButtonMotionFcn',{@localShowInfo,hImage},...
        'WindowButtonUpFcn',{@localInfoOff});
    
        
maimageData.maStruct = maStruct;
maimageData.rowLabels = rowLabels;
maimageData.columnLabels = columnLabels;
    
setappdata(fig,'ShowMAIMAGEInfo',false);
setappdata(fig,'MAIMAGEData',maimageData);         

% draw on lines to indicate blocks
maxX = size(maStruct.Indices,2);
maxY = size(maStruct.Indices,1);
numBlocks = maStruct.Shape.NumBlocks;
XBreaks = unique(maStruct.Shape.BlockRange(:,1));
YBreaks = unique(maStruct.Shape.BlockRange(:,2));
numXBreaks = numel(XBreaks);
numYBreaks = numel(YBreaks);
hLines = zeros(numXBreaks+numYBreaks-2,1);
for count = 2:numXBreaks
    hLines(count-1) = line([XBreaks(count),XBreaks(count)]-.5,[0,maxY]+.5,'linewidth',2,'color','k');
end
for count = 2:numYBreaks
    hLines(numXBreaks+count-2) = line([0,maxX]+.5,[YBreaks(count),YBreaks(count)]-.5,'linewidth',2,'color','k');
end
% turn off axis
axis('off');
if isempty(titleString)
    titleString = fieldname;
end
title(titleString);
if showColorbar
    colorbar('peer',ax);
end

if nargout > 0
    hOut = hImage;
end




% -----------------------------------------------------------
function localInfoOn(fig,eventdata,hImage)
setappdata(fig,'ShowMAIMAGEInfo',true);
%display info now
localShowInfo(fig,eventdata,hImage)

% -----------------------------------------------------------
function localInfoOff(fig,eventdata) %#ok
setappdata(fig,'ShowMAIMAGEInfo',false);
htext = getappdata(fig,'MAIMAGEText');
if ~isempty(htext) && ishandle(htext)
    delete(htext)
end
setappdata(fig,'MAIMAGEText',[])

% -----------------------------------------------------------
function localShowInfo(fig,eventdata,hImage) %#ok
% check whether to show info
showinfo = getappdata(fig,'ShowMAIMAGEInfo');
if ~showinfo  || hittest(fig) ~= hImage
    return;
end

htext = getappdata(fig,'MAIMAGEText');
if ~isempty(htext) && ishandle(htext)
    delete(htext)
end


% set figure Units to pixels
figUnits = get(fig,'Units');
set(fig,'Units','pixels');

% setup axes
ax = get(hImage,'Parent');
axUnits = get(ax,'Units');
set(ax,'Units','pixels');

% axPos = get(ax,'Position');
axXLim = get(ax,'XLim');
axYLim = get(ax,'YLim');

%pixels from edge of axes
imCData = get(hImage,'CData');
sizeC = size(imCData);

% point relative to data
ax_cp = get(ax,'CurrentPoint');
x = round(ax_cp(1,1));
y = round(ax_cp(1,2));

maimageData = getappdata(fig,'MAIMAGEData');

names = '';
ids = '';
if isfield(maimageData.maStruct,'Names')
    names = maimageData.maStruct.Names(maimageData.maStruct.Indices);
end
if isfield(maimageData.maStruct,'IDs')
    ids = maimageData.maStruct.IDs(maimageData.maStruct.Indices);
end

% out of range
if x< 1 || x > sizeC(2) || y < 1 || y > sizeC(1)
    htext = getappdata(fig,'MAIMAGEText');
    if ~isempty(htext) && ishandle(htext)
        set(htext,'Visible','off')
    end
    return
end

ind = sub2ind(sizeC,y,x);

val = imCData(ind);
name = '';
id = '';
if ~isempty(names)
    name = names{ind};
end
if ~isempty(ids)
    id = ids{ind};
end

str = {['Value: ' num2str(val)]};
if ~isempty(name)
    str = [str; {['Name: ' name]}];
end
if ~isempty(id)
    str = [str; {['ID: ' id]}];
end
if ~isempty(maimageData.rowLabels)
    str = [str;{['Row: ' maimageData.rowLabels{y}]}];
end
if ~isempty(maimageData.columnLabels)
    str = [str;{['Column: ' maimageData.columnLabels{x}]}];
end

htext = text(x,y,str,'Visible','off','Clipping','off','FontName','FixedWidth');
setappdata(fig,'MAIMAGEText',htext)

% give it an off white background, black text and grey border
set(htext, 'BackgroundColor', [1 1 0.933333],...
    'Color', [0 0 0],...
    'EdgeColor', [0.8 0.8 0.8],...
    'Tag','ImageDataTip',...
    'interpreter','none');

% determine the offset in pixels
set(htext,'position',[x y]);
set(htext,'Units','pixels')
pixpos = get(htext,'Position');

offsets = [0 0 0];

% determine what quadrant the pointer is in
quadrant=[x y]<[mean(axXLim) mean(axYLim)];

if ~quadrant(1)
    set(htext,'HorizontalAlignment','Right')
    offsets(1) = -2;
else
    set(htext,'HorizontalAlignment','Left')
    offsets(1) = 16;
end
if ~quadrant(2)
    set(htext,'VerticalAlignment','Bottom')
    offsets(2) = 2;
else
    set(htext,'VerticalAlignment','Top')
    offsets(2) = -2;
end

set(htext,'Position',pixpos + offsets);

% show the text
set(htext, 'Visible','on')

% restore Units
set(fig,'Units',figUnits);
set(ax,'Units',axUnits);
