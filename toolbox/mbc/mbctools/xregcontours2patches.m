function patches = xregcontours2patches( C, H, varargin )
%CONTOURS_TO_PATCHES   CONTOURS output to patch object conversion
%   CONTOURS_TO_PATCHES(C,H) where C is the output from CONTOURS and H is an 
%   axes handle, is a vecotr of handles to patch objetcs that C describes. 
%   These patch objects will be attached to the axes H. The 'UserData' of each 
%   patch object will contain the level value. It is assumed that each line 
%   segement forms a closed patch. This can be assured from CONTOURS by a 
%   suitable padding of the function evaluation matrix.
%   CONTOURS_TO_PATCHES(C,H,<Parameter>,<Value>,...) sets additional properties 
%   of the patch objects.
%
%   The patches are colored acording to the sign of their areas: patches 
%   positve area have the default color (which can be overruled by explicitly 
%   specifying 'FaceColor' property) and patches with negative area are colored 
%   the same as the background color (which overrules an explicit 'FaceColor' 
%   property value). This means that C should come from CONTOURS and not 
%   CONTOURC and that a binary value function will have its patches correctly 
%   coloured (except possibly any patches on infinite extent which aren't 
%   listed in the output anyway.
%
%   See also CONTOURS.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 08:21:13 $ 

%
%     The contour matrix C is a two row matrix of contour lines. Each
%     contiguous drawing segment contains the value of the contour, 
%     the number of (x,y) drawing pairs, and the pairs themselves.  
%     The segments are appended end-to-end as
%
%        C = [level1 x1 x2 x3 ... level2 x2 x2 x3 ...;
%             pairs1 y1 y2 y3 ... pairs2 y2 y2 y3 ...]

% pull info out of C and compute areas


area = [];
level = [];
xdata = {};
ydata = {};
n = 1;
while n <= size( C, 2 );
    level  = [level, C(1,n) ];
    np = C(2,n);
    xp  = C(1,n+(1:np));
    yp  = C(2,n+(1:np));
    n = n + np + 1;
    
    xdata = { xdata{:}, [xp] };
    ydata = { ydata{:}, [yp] };
    area = [ area, sum( diff(xp).*(yp(1:np-1)+yp(2:np))/2 ) ];

    
%     %     if area(end) < 0,
%     display_eval( 'xp([1,end])' )
%     display_eval( 'yp([1,end])' )
%     display_eval( 'area(end)  ' )
%     figure,
%     %         plot( xp, yp, '+-', ....
%     %             [xp; xp; xp([end,1:(end-1)]); xp([end,1:(end-1)]); xp], ....
%     %             [yp; yp([end,1:(end-1)]); yp([end,1:(end-1)]); yp; yp], 'o-' )
%     plot( xp, yp, '+-' )
%     a1 = diff(xp).*(yp(1:np-1)+yp(2:np))/2;
%     for i = 1:(np-1),
%         text( ...
%             (xp(i)+xp(i+1))/2, ...
%             (yp(i)+yp(i+1))/2, ...
%             [num2str( a1(i) ), '(', int2str(i), ')'], ...
%             'BackGroundColor', a1(i) > [0,0,0], ...
%             'Color', a1(i) <= [0,0,0] );
%     end
%     title( [ 'Area: ', num2str( area( end ) ) ] )
%     %     end
end

% sort patches in decreasing order of area
[NULL,ind] = sort( -abs(area) );
% % area = area(ind);
% % xdata = {xdata{ind}};
% % ydata = {ydata{ind}};

% assign patches
patches = [];
bgc = get( H, 'Color' );
for i = ind,
    if area(i) > 0,
        patches = [ patches, patch( ...
                'Parent', H, ...
                'XData', xdata{i}, ...
                'YData', ydata{i}, ...
                'UserData', level(i), ...
                varargin{:} ) ];
    else
        patches = [ patches, patch( ...
                'Parent', H, ...
                'XData', xdata{i}, ...
                'YData', ydata{i}, ...
                'UserData', level(i), ...
                varargin{:}, ...
                'facecolor', bgc) ];
    end
end


%---------------------------------|--------------------------------------------|
% Ruler:
%        1         2         3         4         5         6         7         8
%2345678901234567890123456789012345678901234567890123456789012345678901234567890
%---------------------------------|--------------------------------------------|
% EOF
%---------------------------------|--------------------------------------------|
