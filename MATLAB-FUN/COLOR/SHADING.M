function ret_type = shading(type)
%SHADING Color shading mode.
%	SHADING controls the color shading of SURFACE and PATCH objects.
%	SURFACE and PATCH objects are created by the functions SURF, MESH,
%	PCOLOR, FILL, and FILL3. 
%
%	SHADING FLAT sets the shading of the current graph to flat.
%	SHADING INTERP sets the shading to interpolated.
%	SHADING FACETED sets the shading to faceted, which is the default.
%
%	Flat shading is piecewise constant; each mesh line segment or
%	surface patch has a constant color determined by the color value
%	at the end point of the segment or the corner of the patch which
%	has the smallest index or indices.
%
%	Interpolated shading, which is also known as Gouraud shading, is
%	piecewise bilinear; the color in each segment or patch varies linearly
%	and interpolates the end or corner values.
%
%	Faceted shading is flat shading with superimposed black mesh lines.
%	This is often the most effective and is the default.
%
%	SHADING is an M-file that sets the EdgeColor and FaceColor properties
%	of all SURFACE objects in the current axes. It sets them to the
%	correct values that depend upon whether the SURFACE objects are
%	representing meshes or surfaces.
%
%	See also SURF, MESH, PCOLOR, FILL, FILL3, SURFACE, PATCH.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

ax = gca;
kids = get(ax,'Children');
fc = get(ax,'color');
if strcmp(lower(fc),'none')
	fc = get(gcf,'color');
end
imesh = [];
isurf = [];
itext = [];
for i = 1:max(size(kids))
    t = lower(get(kids(i),'type'));
	if(strcmp(t, 'surface') | strcmp(t, 'patch'))
		face = lower(get(kids(i),'facecolor'));
		if strcmp(face,'none')
			imesh = [imesh ; kids(i)];
		elseif strcmp(face,'texturemap')
			itext = [itext; kids(i)];
		elseif ~isstr(face)
			if (all(face == fc)) 
				imesh = [imesh ; kids(i)];
			else
				isurf = [isurf; kids(i)];
			end
		else
			isurf = [isurf; kids(i)];
		end
	end
end

if(nargin == 0)
	ret_type = get(ax,'DefaultSurfaceFaceColor');
	if(strcmp(ret_type, 'flat'))
		if(strcmp(get(ax,'DefaultSurfaceEdgeColor'),'black'))
			ret_type = 'faceted';
		end
	end
else
	if(strcmp(type, 'flat'))
		if ~isempty(isurf),set(isurf,'facecolor','flat','edgecolor','none');end
		if ~isempty(imesh),set(imesh,'facecolor',fc,'edgecolor','flat');end
		if ~isempty(itext),set(itext,'edgecolor','none');end
	elseif(strcmp(type, 'interp'))
		if ~isempty(isurf),set(isurf,'facecolor','interp','edgecolor','none');end
		if ~isempty(imesh),set(imesh,'facecolor',fc,'edgecolor','interp');end
		if ~isempty(itext),set(itext,'edgecolor','interp');end
	elseif(strcmp(type,'faceted'))
		if ~isempty(isurf),set(isurf,'facecolor','flat','edgecolor','black');end
		if ~isempty(imesh),set(imesh,'facecolor',fc,'edgecolor','flat');end
		if ~isempty(itext),set(itext,'edgecolor','black');end
	else
		error('Shading methods are flat, faceted, and interp.');
	end
end
