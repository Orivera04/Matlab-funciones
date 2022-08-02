%SPHARM2 Construct spherical surface harmonic. 
%	Plots spherical surface harmonic Ymn(6,1) of 
%	amplitude 2 on surface of sphere of radius 5.

%       Denise L. Chen  9-1-93
%	Copyright (c) 1984-94 by The MathWorks, Inc.

% Demo initialization ====================
if ~exist('GalleryGUIFlag'), figNumber=0; end;

% Install help entry
hlpStr= ...                                                            
    ['                                                 '  
     ' Spherical harmonics are the spherical version   '  
     ' of Fourier series. They can be used to model    '  
     ' the free oscillations of the earth.             '  
     '                                                 '  
     ' The image pictured is the spherical harmonic    '  
     ' of degree 6, order 1, and amplitude 2 plotted on'  
     ' the surface of a sphere of radius 5.            '  
     '                                                 '  
     '                                                 '  
     ' File name: spharm2.m                            '];
gallinit(figNumber,hlpStr);

n = 6;				% degree = 6
m = 1;				% order = 1
if isstudent, delta = pi/30; else, delta = pi/40; end
theta = 0 : delta : pi;         % altitude
phi = 0 : 2*delta : 2*pi;       % azimuth
[phi,theta] = meshgrid(phi,theta);

Ymn = legendre(n,cos(theta(:,1)));
Ymn = Ymn(m+1,:)';
yy = Ymn;
for kk = 2: size(theta,1)
    yy = [yy Ymn];
end;
yy = yy.*cos(m*phi);

m = max(max(abs(yy)));
rho = 5 + 2*yy/m;

% spherical coordinate equations
r = rho.*sin(theta);
x = r.*cos(phi);    % spherical coordinate equations
y = r.*sin(phi);
z = rho.*cos(theta);

% do the plot
surf(x,y,z)
axis('square')
axis([-5 5 -5 5 -5 5])
axis('off')
view(40,30)
