function hText = mbccountedtagdata(data, ax, hPrevious, sClip, tol)
%MBCCOUNTEDTAGDATA Add textual tags to indicate coincident data points
%
%  H = MBCCOUNTEDTAGDATA(DATA, AXES, OLDH, CLIPPING, TOL) adds a text tag
%  to groups of coincident data points indicating how many points are
%  grouped together.
%
%  DATA is either an N-by-2 (2D) or N-by-3 (3D) matrix.
%  AXES is an axes handle to place the tags in.
%  OLDH is a vector of pre-existing text handles that can be reused if
%  needed, or deleted if not.
%  CLIPPING is either 'on' or 'off'.  This clipping value will be set on
%  all of the text items that are used.
%  TOL is a vector, length N, of tolerances for deciding when points are
%  coincident.
%
%  The function outputs H, a vector of text object handles.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 07:33:16 $ 

if isempty(data)
    hText = [];
    delete(hPrevious);
    return
end

Ncols = size(data,2);
if Ncols==2
    IS3D = false;
else
    IS3D = true;
end

[pts, tagstr] = i_closepointalg(data, tol, IS3D); 

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





function [pts, tagstr] = i_closepointalg(data, tol, IS3D)

nPoints = size(data,1);
count = zeros(nPoints, 1);
count(1) = 1;
for n = 2:nPoints
    if IS3D
        closepts = abs(data(n,1)-data(1:n-1,1)) <= tol(1) & ...
            abs(data(n,2)-data(1:n-1,2)) <= tol(2) & ...
            abs(data(n,3)-data(1:n-1,3)) <= tol(3);
    else
        closepts = abs(data(n,1)-data(1:n-1,1)) <= tol(1) & ...
            abs(data(n,2)-data(1:n-1,2)) <= tol(2);
    end
    if any(closepts)
        ind = find(closepts);
        ind = ind(1);
        count(ind) = count(ind) + 1;
    else
        count(n) = 1;
    end
end
idx = find(count>1);
pts = data(idx, :);
tagstr = cell(length(idx), 1);
for n = 1:length(idx)
    tagstr{n} = sprintf('%d', count(idx(n)));
end
