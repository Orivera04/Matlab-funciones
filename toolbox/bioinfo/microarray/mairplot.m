function [outlogIntensity,logRatio,hout] = mairplot(Xdata,Ydata,varargin)
%MAIRPLOT creates an Intensity vs Ratio scatter plot of microarray data.
%
%   MAIRPLOT(X,Y) creates an intensity vs ratio scatter plot of X vs Y.
%
%   MAIRPLOT(...,'FACTORLINES',N) adds lines showing a factor of N change.
%
%   MAIRPLOT(...,'TITLE',TITLE) allows you to specify a title for the plot.
%
%   MAIRPLOT(...,'LABELS',LABELS) allows you to specify a cell array of
%   labels for the data. If LABELS are defined, then clicking on a point on
%   the plot will show the LABEL corresponding to that point. 
%
%   MAIRPLOT(...,Handle Graphics name/value) allows you to pass optional
%   Handle Graphics property name/property value pairs to the function.
%
%   [INTENSITY, RATIO] = MAIRPLOT(...) returns the intensity and ratio
%   values.
%
%   [INTENSITY, RATIO, H] = MAIRPLOT(...) returns the handle of the plot.
%
%   Examples:
%
%       maStruct = gprread('mouse_a1wt.gpr');
% 		cy3data = maStruct.Data(:,36);
% 		cy5data = maStruct.Data(:,37);
%       positiveVals = (cy3data>0) & (cy5data>0);
%       cy3data(~positiveVals) = [];
%       cy5data(~positiveVals) = [];
%       mairplot(cy3data,cy5data,'title','R vs G')
%       figure
%       names = maStruct.Names(positiveVals);
%       mairplot(cy3data,cy5data,'FACTORLINES',2,'LABELS',maStruct.Names)
%
%   See also MABOXPLOT, MALOGLOG, MALOWESS.

% Copyright 2003-2004 The MathWorks, Inc.
% $Revision: 1.9.6.4 $   $Date: 2004/01/24 09:18:27 $

hgargs = {};
equalLine = false;
twoXLine = false;
twoXScale = 2;
titleString = '';
labels = '';
if nargin > 2

    if rem(nargin,2)== 1
        error('Bioinfo:IncorrectNumberOfArguments',...
            'Incorrect number of arguments to %s.',mfilename);
    end
    okargs = {'factorlines','title','labels'};
    for j=1:2:nargin-2
        pname = varargin{j};
        pval = varargin{j+1};
        k = strmatch(lower(pname), okargs);
        if isempty(k)
            % here we assume that these are handle graphics options
            hgargs{end+1} = pname;
            hgargs{end+1} = pval;
        elseif length(k)>1
            error('Bioinfo:AmbiguousParameterName',...
                'Ambiguous parameter name: %s.',pname);
        else
            switch(k)
                case 1  % factorlines
                    equalLine = true;
                    twoXLine = true;
                    if pval == 0
                        equalLine = false;
                        twoXLine = false;
                    elseif pval == 1
                        twoXLine = false;
                    end
                    twoXScale = pval;
                case 2 % title
                    titleString = pval;
                case 3
                    labels = pval;
            end
        end
    end
end

% convery inputs to column vectors
Xdata = Xdata(:);
Ydata = Ydata(:);

% discard any zero elements

allZeros = ((Xdata == 0) | (Ydata == 0));
allNegative = ((Xdata < 0) | (Ydata < 0));

if any(allZeros)
    warning('Bioinfo:MairplotZeroValues','Zero values are ignored');
end
if any(allNegative)
    warning('Bioinfo:MairplotNegativeValues','Negative values are ignored.');
end

% % make nicer bounds than the default loglog plot
% upperBound = 1.5*max(max(Xdata(:)),max(Ydata(:)));
goodVals = ~(allZeros|allNegative);

logRatio = (Xdata(goodVals)./Ydata(goodVals));
logIntensity = (Xdata(goodVals).*Ydata(goodVals));

% plot the figure
hPlot = loglog(logIntensity,logRatio,'+',hgargs{:});

% resize the axes
hAxis = get(hPlot,'parent');
%set(hAxis,'Xlim',[lowerBound,upperBound],'Ylim',[lowerBound,upperBound]);
Xrange = get(hAxis,'Xlim');

xlabel('Intensity');
ylabel('Ratio');

% plot line y = x;
if equalLine
    line( [Xrange(1),Xrange(2)],[1,1],'color','k','linestyle',':')
end

% plot 2x line
if twoXLine
    line([Xrange(1),Xrange(2)], twoXScale*[1,1],'color','k','linestyle',':')
    line([Xrange(1),Xrange(2)], [1,1]/twoXScale,'color','k','linestyle',':')
end

% Add a title
if ~isempty(titleString)
    title(titleString);
end

% If labels exist, set up a buttondown function
if ~isempty(labels)
    set(hAxis,'Userdata',hPlot,'ButtonDownFcn',@clickonplot);
    set(hPlot,'Userdata',labels,'ButtonDownFcn',@clickonplot);
end

% if output is requested, send out handle
if nargout > 0
    hout = hPlot;
    outlogIntensity = logIntensity;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function clickonplot(varargin) %#ok
% callback function highlights selected element and displays label.
[hObject,hFig] = gcbo;
% clean up any old labels
%hFig = localCleanUpLabel;
udata = get(hObject,'Userdata');
if ishandle(udata)
    hObject  = udata;
end

xvals = get(hObject,'XData');
yvals = get(hObject,'YData');
hAxis = get(hObject,'parent');
point = get(hAxis,'CurrentPoint');
udata = get(hObject,'Userdata');
set(hFig,'Doublebuffer','on');

% find the closest point
[v, index] = min((((xvals - point(1,1)).^2)./(point(1,1)^2)) +...
    ((yvals - point(1,2)).^2)./(point(1,2)^2)); %#ok

%highlight the point and set the title
if ~isempty(index)
    hHighlight = line(xvals(index),yvals(index),...
        'color','red','marker','d','Tag','loglogHighlight');%#ok
    % get the value and label of the current point
    cpAct = get(hAxis,'CurrentPoint');

    % create a new text object -- start with it invisible
    htext = text(cpAct(1,1),cpAct(1,2) ,udata(index),'visible','off','interpreter','none');

    % give it an off white background, black text and grey border
    set(htext,	'BackgroundColor' , [1 1 0.933333],'Color' , [0 0 0],'EdgeColor' ,...
        [0.8 0.8 0.8], 'Tag','LogLogDataTip');
    % show the text
    set(htext, 'Visible','on')
    set(hFig,'WindowButtonUpFcn',@localCleanUpLabel);

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function hFig = localCleanUpLabel(varargin) %#ok
%localCleanUpLabel callback function to remove label from image

% get the handles to the figure, image and axis
hFig = gcbf;

% delete the old label if it exists
oldLabel = findobj(hFig,'Tag','LogLogDataTip');
if ~isempty(oldLabel)
    delete(oldLabel);
end
% delete the old label if it exists
oldHighlight = findobj(hFig,'Tag','loglogHighlight');
if ~isempty(oldHighlight)
    delete(oldHighlight);
end

