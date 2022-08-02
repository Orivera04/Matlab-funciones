function hText = mbctagdata(data, tags, ax, hPrevious, sClip, method, varargin)
%MBCTAGDATA Add textual tags to data points
%
%  H = MBCTAGDATA(DATA, TAGS, AXES, OLDH, CLIPPING, METHOD, OPTS) adds a text item next to each
%  data point, DATA(i) with the tag TAGS(i).  METHOD can be used to alter
%  the way that tags are built up, and a variable list of options OPTS may
%  be supplied depending on the value of METHOD.
%
%  DATA is either an N-by-2 (2D) or N-by-3 (3D) matrix.
%  TAGS may be either a length N vector of numbers or a length N cell array
%  of strings.
%  AXES is an axes handle to place the tags in.
%  OLDH is a vector of pre-existing text handles that can be reused if
%  needed, or deleted if not.
%  CLIPPING is either 'on' or 'off'.  This clipping value will be set on
%  all of the text items that are used.
%  METHOD may be either 'simple' or 'pointoverlap'.  The default is
%  'simple', which adds a tag for every data point.  'pointoverlap' will
%  attempt to look for data points that are near to each other and will use
%  a single tag for all close points.
%  OPTS values depend on the setting for METHOD.  When METHOD is 'simple',
%  no options are available.  When METHOD is 'pointoverlap', you may
%  specify the tolerance to use when looking for close matches.  This is
%  specified as a vector of tolerances for each column of the data.
%
%  The function outputs H, a vector of text object handles.
%
%  Example:  h = mbctagdata([0 0;1 2;1 1;0 1; .01 -.05], ...
%                           [1 2 3 4 5], ...
%                           'pointoverlap', [.1 .1]);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 07:33:25 $ 

if isempty(data)
    hText = [];
    delete(hPrevious);
    return
end
if size(data,1)~=length(tags(:))
    hText = hPrevious;
    error('mbc:mbctagdata:InvalidArgument', 'Data and label lengths must match.');
    return
end

if nargin<6
    method = 'simple';
end

Ncols = size(data,2);
if Ncols==2
    IS3D = false;
else
    IS3D = true;
end

if isnumeric(tags)
    % Convert to a cell array of strings
    nTags = tags;
    tags = cell(size(nTags));
    for n = 1:length(nTags)
        tags{n} = sprintf('%g', nTags(n));
    end
end

switch method
    case 'simple'
        pts = data;
        tagstr = tags;
    case 'pointoverlap'
        tol = varargin{1};
        [pts, tagstr] = i_closepointalg(data, tags, tol, IS3D);    
end

% Make new text items if required
nItems = length(tagstr);
nOldText = length(hPrevious);
nToMake = nItems - nOldText;
if nToMake>0
    hText = zeros(1, nItems);
    hText(1:nOldText) = hPrevious;
    axvis = get(ax, 'visible');
    for n = nOldText+1:nItems
        hText(n) = text('Parent', ax, ...
            'Visible', axvis, ...
            'HorizontalAlignment', 'right', ...
            'VerticalAlignment', 'bottom', ...
            'Hittest', 'off', ...
            'FontSize', 8);
    end
elseif nToMake<0
    % Delete some handles
    hText = hPrevious(1:nItems);
    delete(hPrevious(nItems+1:end));
else
    hText = hPrevious;
end

% Set the string and position on all items
cellpts = cell(nItems,1);
for n = 1:nItems
    cellpts{n} = pts(n,:);
end
set(hText(:), 'clipping', sClip,  {'string'}, tagstr(:), {'position'}, cellpts);




function [pts, tagstr] = i_closepointalg(data, tags, tol, IS3D)

pts = data(1,:);
tagstr = tags(1);
nPoints = size(data,1);
RETCHAR = sprintf('\n');
for n = 2:nPoints
    if IS3D
        closepts = abs(data(n,1)-pts(:,1)) <= tol(1) & ...
            abs(data(n,2)-pts(:,2)) <= tol(2) & ...
            abs(data(n,3)-pts(:,3)) <= tol(3);
    else
        closepts = abs(data(n,1)-pts(:,1)) <= tol(1) & ...
            abs(data(n,2)-pts(:,2)) <= tol(2);
    end
    if any(closepts)
        ind = find(closepts);
        ind = ind(1);
        tagstr{ind} = [tagstr{ind}, RETCHAR, tags{n}];
    else
        pts = [pts; data(n,:)];
        tagstr  = [tagstr; tags(n)];
    end
end