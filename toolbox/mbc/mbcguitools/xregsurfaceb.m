function [varargout] = xregsurfaceb(varargin)
%XREGSURFACEB Create surface clipped by a boundary.
%    XREGSURFACEB(X,Y,Z,B,C) is analogous to SURFACE(X,Y,Z,C) except that the
%    surface is formed from patches and is clipped to the the region where
%    B <= 0.
%    XREGSURFACEB(X,Y,Z,B) uses C = Z, so color is proportional to surface
%    height. 
%    XREGSURFACEB(Z,B) and XREGSURFACEB(Z,B,C) use X = 1:M and Y = 1:N where 
%    [M,N] = SIZE(Z). 
% 
%    XREGSURFACEB returns a handle to a PATCH object. 
% 
%    The arguments to XREGSURFACEB can be followed by parameter/value pairs to
%    specify additional properties of the patch. 
% 
%    See also SURFACE, PATCH.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.5 $    $Date: 2004/04/20 23:19:00 $ 

error( nargchk( 2, Inf, nargin, 'struct' ) );
% error( nargchk( 2, Inf, nargin ) );

firstChar = min( find( cellfun( 'isclass', varargin, 'char' ) ) );
if isempty( firstChar ),
    firstChar = nargin + 1;
    patchArgs = cell( 0 );
else
    patchArgs = varargin(firstChar:end);
end

switch firstChar,
    case 3,
        % XREGSURFACEB(Z,B,<parameter>,<value>,...)
        z = varargin{1};
        b = varargin{2};
        c = z;
        [m, n] = size( z );
        x = 1:m;
        y = 1:n;
    case 4,
        % XREGSURFACEB(Z,B,C,<parameter>,<value>,...)
        z = varargin{1};
        b = varargin{2};
        c = varargin{3};
        [m, n] = size( z );
        x = 1:m;
        y = 1:n;
    case 5,
        % XREGSURFACEB(X,Y,Z,B,<parameter>,<value>,...)
        x = varargin{1};
        y = varargin{2};
        z = varargin{3};
        b = varargin{4};
        c = z;
        [m, n] = size( z );
    case 6,
        % XREGSURFACEB(X,Y,Z,B,C,<parameter>,<value>,...)
        x = varargin{1};
        y = varargin{2};
        z = varargin{3};
        b = varargin{4};
        c = varargin{5};
        [m, n] = size( z );
    otherwise
        error( 'mbc:Clipping:invalidInputArguemnts', 'Invalid input arguments' );
end
if ~any( size( x ) == 1 )
    if x(2,1)==x(1,1)
        % Check for x being the wrong way round.  
        x = x.';
        y = y.';
        z = z.';
        c = c.';
        b = b.';
        [m, n] = size( z );
    end
    
    % x is a matrix ==> want the first column
    x = x(:,1);
end
if ~any( size( y ) == 1 )
    % y is a matrix ==> want the first row
    y = y(1,:);
end

% Triangulate the interior of the boundary
[faces, vertices] = i_TriangulateBoundaryInterior( -b );

if isempty( faces ) || isempty( vertices ),
    h = [];
else
    
vx = vertices(:,1);
vy = vertices(:,2);

% Interpolate to get the z-values and colours
vertices(:,1) = interp1( 1:m, x, vx );
vertices(:,2) = interp1( 1:n, y, vy );
vertices(:,3) = interp2( 1:m, 1:n, z', vx, vy );
if ndims(c)==2
    colors = interp2( 1:m, 1:n, c', vx, vy );
elseif ndims(c)==3 && size(c,3)==3
    colors = zeros(length(vx), 3);
    for k = 1:3
        colors(:,k) = interp2( 1:m, 1:n, c(:,:,k)', vx, vy );
    end
else
    error('mbc:xregsurfaceb:InvalidArgument', ...
        'CData must be a correct 2D or 3D color array.');
end

% Compute surface normals
[dy, dx] = gradient( z, y, x);

dx = interp2( 1:m, 1:n, dx', vx, vy );
dy = interp2( 1:m, 1:n, dy', vx, vy );
dx = dx';
dy = dy';

normals = [dx(:), dy(:), -ones( numel( dx ), 1 )];
normals = normals./repmat( sqrt( sum( normals.^2, 2 ) ), 1, 3 );

% Produce the patches
h = patch( ...
   'Faces', faces, ...
   'Vertices', vertices, ...
   'FaceVertexCData', colors, ...
   'VertexNormals', normals, ...
   patchArgs{:} );

end

if nargout > 0,
    varargout{1} = h;
end

%--------------------------------------------------------------------------
function [faces, vertices] = i_TriangulateBoundaryInterior( bdry )

[m, n] = size( bdry );
mask = bdry >= 0;

if ~any( mask(:) ),
    faces = zeros( 0, 3 );
    vertices = zeros( 0, 3 );
    return
end

% Get vertices from the main grid
[i, j] = find( mask );
vertices = [i(:), j(:)];
nVertices = size( vertices, 1 );

gridIndices = repmat( -1, m, n );
gridIndices(mask) = 1:nVertices;

% Use contours to determine the location of the boundary
c = contours( bdry', [0, 0] );

% Generate line segments from c
lines = [];
i = 1;
while i <= size( c, 2 ),
    j = 1:c(2,i);
    vertices = [vertices; c(:,i+j)'];
    lines = [lines; nVertices + [j(1:end-1)', j(2:end)']];
    nVertices = nVertices + c(2,i);
    i = i + c(2,i) + 1;
end
nLines = size( lines, 1 );

% Find the closest grid point to each point on the CONTOURS line
nInside = max( gridIndices(:) );
closeGrid = 1:size( vertices, 1 );
for count = (nInside+1):size( vertices, 1 ),
    pt = vertices(count,:);
    pt1 = floor( pt );
    pt2 = ceil(  pt );
    
    if pt1(1) == pt2(1),
        % on a vertical grid line
        v1 = [pt1(1), pt1(2)];
        v2 = [pt1(1), pt2(2)];
    elseif pt1(2) == pt2(2),
        % on a horizaontal grid line
        v1 = [pt1(1), pt1(2)];
        v2 = [pt2(1), pt1(2)];
    else
        error( 'mbc:Clipping:pointNotOnGrid', 'This point doesn''t seem to be on a grid line' );
    end
    
    if gridIndices(v1(1),v1(2)) >= 0, 
        closeGrid(count) = gridIndices(v1(1),v1(2));
    elseif gridIndices(v2(1),v2(2)) >= 0,
        closeGrid(count) = gridIndices(v2(1),v2(2));
    elseif all( pt1 == pt2 ),
        % make this vertex a grid vertex
        gridIndices(pt(1),pt(2)) = count;
        closeGrid(count) = count;
    else
        error( 'mbc:Clipping:postiveValueNotFound', 'Neither point had positive value' );
    end
end

mask = gridIndices > 0;

% Remove coincident vertices
[vertices, i, j] = unique( vertices, 'rows' );
gridIndices(mask) = j(gridIndices(mask));
if size(lines, 1)==1
    % Need to ensure that lines stays as a single row
    lines = j(lines).';
else
    lines = j(lines);
end
closeGrid = j(closeGrid(i));


% Triangulation of the main grid
% 
%    C---D
%    |  /|
%    | / |
%    |/  |
%    A---B
%
A = gridIndices(1:m-1,1:n-1);
B = gridIndices(2:m,1:n-1);
C = gridIndices(1:m-1,2:n);
D = gridIndices(2:m,2:n);
f1 = [A(:), B(:), D(:)];
f2 = [A(:), D(:), C(:)];
ind = any( f1 == -1, 2 ) | any( f2 == -1, 2 );
faces = [f1(~ind,:); f2(~ind,:)];

% Need to allocate space for further faces to be added
nFaces = size( faces, 1 );
faces = [faces; zeros( 3 * nLines, 3 )]; % at most 3 new faces for each line

flagged = []; % [flagged line, point close to start, point close to end]

% Triangulation of non-grid part
for i = 1:nLines,
    s = lines(i,1); % start of line
    e = lines(i,2); % end of line
    if closeGrid(s) == closeGrid(e),
        % triangle,
        faces(nFaces+1,:) = [closeGrid(s), lines(i,[2 1]) ];
        nFaces = nFaces + 1;
    elseif any( vertices(closeGrid(s),:) == vertices(closeGrid(e),:) ),
        % quad,
        faces(nFaces+(1:2),:) = [ ...
            closeGrid(s), lines(i,[2 1]); ...
            closeGrid(e), lines(i,2), closeGrid(s) ];
        nFaces = nFaces + 2;
    else
        % five sided, 
        corner = i_findClockwisePoint( closeGrid(s), closeGrid(e), gridIndices );
        if corner < 0,
            % we haven't another point to connet to
            flagged = [flagged; i, closeGrid(s), closeGrid(e) ];
        else
            faces(nFaces+(1:3),:) = [ ...
                corner, lines(i,[2 1]); ...
                corner, lines(i,1), closeGrid(s); ...
                corner, closeGrid(e), lines(i,2) ];
            nFaces = nFaces + 3;
        end
    end
end

% Process six sided, i.e., flagged lines
% 
% close2--e1-+
%      |   \ |
%      |    \|
%      s2    s1
%      |\    |
%      | \   |
%      +--e2-close1
%   
% The flagged lines are [s1, e1] and [s2, e2]
% close1 and close2 are the grid points closest to the lines
for i = 1:size( flagged, 1 ),
    if flagged(i,1) < 0,
        % this line has been processed ==> ignore
    else
        close1 = flagged(i,2);
        close2 = flagged(i,3);

        % Find the other line that has these two points as closest grid
        % points
        j = intersect( ...
            find( flagged(:,3) == close1 ), ...
            find( flagged(:,2) == close2 ) );

        % There should be exactly one match
        if isempty( j ),
            error( 'mbc:Clipping:matchMismatch', 'Unmatched flagged line' );
        elseif numel( j ) > 1,
            error( 'mbc:Clipping:matchMismatch', 'Multiple matches found for flagged line' );
        else

            % Form the four triangles inside the polygon [s1, e1, close2, s2, e2, close1]
            s1 = lines(flagged(i,1),1);
            e1 = lines(flagged(i,1),2);
            s2 = lines(flagged(j,1),1);
            e2 = lines(flagged(j,1),2);
            faces(nFaces+(1:4),:) = [ ...
                s1, e1, e2; ...
                e1, close2, s2; ...
                s2, e2, e1; ...
                e2, close1, s1];
            nFaces = nFaces + 4;
            
            % unflag the matched line
            flagged(i,1) = -1; 
            flagged(j,1) = -1; 
        end
    end
end

faces = faces(1:nFaces,:);

%--------------------------------------------------------------------------
function c = i_findClockwisePoint( s, e, ind )
[si,sj] = find( ind == s );
[ei,ej] = find( ind == e );
if ind(si,ej) > 0,
    c = ind(si,ej);
else
    c = ind(ei,sj);
end

%--------------------------------------------------------------------------
% EOF
%--------------------------------------------------------------------------
