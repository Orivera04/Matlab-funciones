function r = diffuse(nx,ny,nz,s)
%DIFFUSE Diffuse reflectance.
%	R = DIFFUSE(Nx,Ny,Nz,S) returns the reflectance for a surface with
%	normal vector components [Nx,Ny,Nz].  S is a three vector that
%	defines the direction to the light source. S can also be a two vector
%	S = [Az,El] specifying the direction with azimuth and elevation.
%
%	Lambert's Law: R = cos(theta) where theta is the angle between the
%	surface normal and light source.
%
%	See also SPECULAR, SURFNORM, SURFL.

%	Clay M. Thompson 5-1-91
%	Copyright (c) 1984-94 by The MathWorks, Inc.

[m,n] = size(nx);
if size(ny)~=[m,n], error('Ny must be the same size as Nx.'); end
if size(nz)~=[m,n], error('Nz must be the same size as Nx.'); end

% Generate component matrices for source.
if length(s) == 2 % convert to 3-vector
	az = s(1)*pi/180;
	el = s(2)*pi/180;
	s = [cos(az)*cos(el) sin(az)*cos(el) sin(el)];
end
s = s/norm(s); % Normalize
sx = s(1)*ones(m,n);
sy = s(2)*ones(m,n);
sz = s(3)*ones(m,n);

% Normalize normal vectors.
mag = sqrt(nx.*nx+ny.*ny+nz.*nz);
d = (mag==0); mag(d) = eps*ones(size(mag(d)));

r = max(0,(sx.*nx + sy.*ny + sz.*nz)./mag);
