function [R, C] = getCellAt(obj, x, y)
%GETCELLAT Find cell corresponding to pixel coordinates
%
%  [R, C] = GETCELLAT(OBJ, X, Y) returns the row and column indices for the
%  cell at point (x, y).  If there is no cell from this grid at that point,
%  x and y will be set to 0.  If the point falls on a a gap between cells
%  this will count as no cell.
%
%  Note that this function ignores any merging settings and will throw an
%  error if it is used on a grid that is using the old positioning
%  algorithm.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 07:36:10 $ 

R = 0;
C = 0;

data = obj.g.info;
if ~data.usecorrectalg
    error('mbc:xreggridlayout:InvalidState', ...
        'Cells cannot be found when using the old layout algorithm');
end

if obj.hGrid.Rows==0 || obj.hGrid.Columns==0
    return
end

p = get(obj.xregcontainer,'innerposition');
p(3:4) = max(p(3:4),[1 1]);

% Check that x,y are within the position rectangle
if x<p(1) ...
        || x>=(p(1)+p(3)) ...
        || y<p(2) ...
        || y>=(p(2)+p(4))
    return
end

% Get positions for each cell
nR = obj.hGrid.Rows;
nC = obj.hGrid.Columns;
el_pos = reshape(obj.hGrid.getPositions(p), [nR, nC]);

for n = 1:nR 
    % Check y position for each pos in first row
    p = el_pos{n,1};
    if (y >= p(2)) && (y < (p(2)+p(4)))
        R = n;
        break
    end
end

if (R > 0)
    for n = 1:nC
        % Check x position for each pos in first row
        p = el_pos{R,n};
        if (x >= p(1)) && (x < (p(1)+p(3)))
            C = n;
            break
        end
    end
end

if (C==0)
    % Reset R to 0 as well
    R = 0;
end
