function plot_vf(vf, M, options)

% plot_vf - plot a vector field with 
%   an optional image in the background.
%
% plot_vf(vf, M, options);
%
%   WORKS ONLY FOR 2D VECTOR FIELDS
%
%   set options.display_streamlines=1 to display streamlines
%
%   Copyright (c) 2004 Gabriel Peyré

options.null = 1;
if nargin<2
    M = [];
end

if isfield(options, 'is_oriented')
    is_oriented = options.is_oriented;
else
    is_oriented = 1;
end

if isfield(options, 'strech_factor')
    strech_factor = options.strech_factor;
else
    strech_factor = 0.6;
end

if isfield(options, 'reorient')
    reorient = options.reorient;
else
    reorient = 0;
end

if isfield(options, 'linestyle')
    linestyle = options.linestyle;
else
    linestyle = 'b';
end


if isfield(options, 'display_streamlines')
    display_streamlines = options.display_streamlines;
else
    display_streamlines = 0;
end

if isfield(options, 'streamline_density')
    streamline_density = options.streamline_density;
else
    streamline_density = 8;
end


if isfield(options, 'line_width')
    line_width = options.line_width;
else
    line_width = 1;
end


if isfield(options, 'display_arrows')
    display_arrows = options.display_arrows;
else
    display_arrows = 1;
end

if display_streamlines & ~isfield(options, 'display_arrows')
    display_arrows = 0;
end

if size(vf,3)~=2
    warning('Dimension >2, cropping ...');
    vf = vf(:,:,1:2);
end

if reorient
    % reorient the vf to x>0
    epsi = sign(vf(:,:,1));
    I = find( epsi==0 );
    epsi(I) = 1;
    vf(:,:,1) = vf(:,:,1).*epsi;
    vf(:,:,2) = vf(:,:,2).*epsi;
end

n = size(vf,1);
p = size(vf,2);

x = 0:1/(n-1):1;
y = 0:1/(p-1):1;
[Y,X] = meshgrid(y,x);
 
hold on;

if display_arrows
imagesc(x,y,M);
if is_oriented
    h = quiver(X,Y,vf(:,:,1),vf(:,:,2), strech_factor, linestyle);
else
    h = quiver(X,Y,vf(:,:,1),vf(:,:,2), strech_factor*0.7, linestyle);
    h = quiver(X,Y,-vf(:,:,1),-vf(:,:,2), strech_factor*0.7, linestyle);
end
axis xy;
axis equal;
end

set(h, 'LineWidth', line_width);

if display_streamlines
    imagesc(M);
    [X,Y] = meshgrid(1:n,1:p);
    [XY,tmp] = streamslice(X,Y, vf(:,:,1), vf(:,:,2) ,streamline_density);
    % reverse stream
    for i=1:length(XY)
        XY{i} = XY{i}(:,2:-1:1);
    end
    streamline(XY);
    axis ij;
end

axis off;
hold off;