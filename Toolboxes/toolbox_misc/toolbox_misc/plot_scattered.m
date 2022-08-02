function plot_scattered(pos,z, resc)

% plot_scattered - plot 2D scattered data using triangulation.
%
%   plot_scattered(pos,z, resc);
%
%   if 'z' is ommited, it only plot a 2D scalar plot.
%   'rescale==1' force a triangulation in [0,1]x[0,1].
%
%   Copyright (c) 2004 Gabriel Peyré

if nargin<2
    plot( pos(1,:), pos(2,:), '.' );    
    return;
end
if nargin<3
    resc = 0;
end

X = pos(1,:)';
Y = pos(2,:)';

if resc>0
    X = rescale(X)*resc;
    Y = rescale(Y);
end

TRI = delaunay(X,Y);
    
trisurf(TRI,X,Y,z);
view(45,20);