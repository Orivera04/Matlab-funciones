% surfi(X,Y,Z[,C])
%
% plot a surface interpolated from a set of vertices.
%
% X, Y and Z should be 1xN vectors, so N vertices are
% represented in all. the surface that interpolates these
% vertices is plotted.
%
% C specifies vertex colours. if unsupplied, C = Z.
%
% to obtain the surface without plotting it, see
% triangulate.
%
% to see example usage, try surfi_demo.
%
% triangulate is ported from Paul Bourke's triangulate code at
% http://astronomy.swin.edu.au/~pbourke/terrain/triangulate/
%
% sourced from http://www.mathworks.com/matlabcentral/

function surfi(X,Y,Z,C)

% check args
if nargin<3
	error('Requires 3 input arguments');
end

% sort vertices by x, then y, then z
scale = 3 * max(max(abs([X;Y;Z])));
[temp,i] = sort(scale*scale*X + scale*Y + 1*Z);
X = X(i);
Y = Y(i);
Z = Z(i);

% run triangulate
v=triangulate([X; Y; Z]);

% display
if nargin<4
	C = Z(v);
	C = C / max(max(C));
end
patch(X(v),Y(v),Z(v),C);

% set up axis
view(3)
