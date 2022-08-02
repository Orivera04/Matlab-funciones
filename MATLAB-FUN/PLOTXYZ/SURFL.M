function hout=surfl(x,y,z,s,k)
%SURFL	3-D shaded surface with lighting.
%	SURFL(...) is the same as SURF(...) except that it draws the surface
%	with highlights from a light source.
%
%	SURFL(Z), SURFL(X,Y,Z), SURFL(Z,S), and SURFL(X,Y,Z,S) are all 
%	legal. S, if specified, is the three vector S = [Sx,Sy,Sz]
%	that specifies the direction of the light source. S can also be
%	specified in spherical coordinates, S = [AZ,EL].
%
%	The shading is based on a combination of diffuse, specular and 
%	ambient lighting models.
%
%	The default value for S is 45 degrees counterclockwise from
%	the current view direction.  Use CLA, HOLD ON, VIEW(AZ,EL),
%	SURFL(...), HOLD OFF to plot the lighted surface with view
%	direction (AZ,EL).
%
%	The relative contributions due to ambient light, diffuse
%	reflection, specular reflection, and the specular spread
%	coefficient can be set by using five arguments
%	SURFL(X,Y,Z,S,K) where K=[ka,kd,ks,spread].
%
%	Relies on the ordering of points in the X,Y, and Z matrices
%	to define the inside and outside of parametric surfaces.
%	Try SURFL(X',Y',Z') if you don't like the results of
%	this function.  Due to the way surface normal vectors are
%	computed, SURFL requires matrices that are at least 3-by-3.
%
%	See also SURF.

%	Clay M. Thompson 4-24-91
%	Copyright (c) 1984-94 by The MathWorks, Inc.

error(nargchk(1,5,nargin));

if nargin==1,    % Define x,y
  z = x;
  [m,n] = size(z);
  [x,y] = meshgrid(1:n,1:m);

elseif nargin==2,
  z = x;
  s = y;
  [m,n] = size(z);
  [x,y] = meshgrid(1:n,1:m);
end
if isstr(z) | isstr(x)
	error('Must be 1, 3 or 4 numeric input arguments.')
end

if nargin<5 % Define default weighting coefficients
  k = [.55,.6,.4,10]; % Ambient,diffuse,specular,spread
end 
if length(k)~=4,
  error('Weighting vector k must have four components.');
end

[msg,x,y,z] = xyzchk(x,y,z); if ~isempty(msg), error(msg); end
if any(size(z)<[3 3]), error('X, Y, and Z must be at least 3-by-3.'); end

stencil=ones(2,2)/4;

cax = newplot;
next = lower(get(cax,'NextPlot'));
if ~ishold, view(3); end	% Set graphics system for 3-D plot
[vaz,vel] = view;
vaz = vaz*pi/180; vel = vel*pi/180; % Convert to radians

if (nargin==1) | (nargin==3), % Use default S
  phi = 45*pi/180;
  s = zeros(1,3);
  s(1) = cos(vaz)*sin(phi)+sin(vaz)*cos(vel)*cos(phi);
  s(2) = sin(phi)*sin(vaz)-cos(vaz)*cos(vel)*cos(phi);
  s(3) = sin(phi)*sin(vel);
else
  if (length(s)~=2) & (length(s)~=3),
    error('S must be specified using [AZ,EL] or [Sx,Sy,Sz].');
  end
end

ms = length(s(:));
if ms==2, % Compute source direction from [AZ,EL]
  az = s(1)*pi/180; el = s(2)*pi/180; % Convert to radians
  s = zeros(1,3);
  s(1) =  sin(az)*cos(el);
  s(2) = -cos(az)*cos(el);
  s(3) =  sin(el);
end

% Determine plot scaling factors for a cube-like plot domain.
h = surf(x,y,z);
a = [get(gca,'xlim') get(gca,'ylim') get(gca,'zlim')];
Sx = a(2)-a(1);
Sy = a(4)-a(3);
Sz = a(6)-a(5);
scale = max([Sx,Sy,Sz]);
Sx = Sx/scale; Sy = Sy/scale; Sz = Sz/scale;

% Compute surface normals.  Rely on ordering to define inside or outside.
xx = x/Sx; yy = y/Sy; zz = z/Sz;
[nx,ny,nz] = surfnorm(xx,yy,zz);

% Compute Lambertian shading + specular + ambient light
R = (k(1)+k(2)*diffuse(nx,ny,nz,s)+ ...
    k(3)*specular(nx,ny,nz,s,[vaz,vel]*180/pi,k(4)))/ sum(k(1:3));

% Show surface
set(h,'cdata',R);
caxis([0,1]);     % Set color axis range.
if nargout > 0
	hout = h;
end
