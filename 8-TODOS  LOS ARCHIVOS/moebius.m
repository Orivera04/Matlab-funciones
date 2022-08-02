function moebius(u,v)
% MOEBIUS(u,v)   Plots the Moebius strip.
%
%    Parameterized equation:
%    x(u,v) = cos(u) + v*cos(u/2)*cos(u)
%    y(u,v) = sin(u) + v*cos(u/2)*sin(u)
%    z(u,v) = v * sin(u/2)              
%
%    Default values for u and v are u = [0, 2*pi], v = [-0.4, 0.4].
	
% Author  : Andreas Klimke, Universität Stuttgart
% Version : 1.0
% Date    : Aug 12, 2002
	
	
if nargin~=2
	u = [0 2*pi];
	v = [-0.4 0.4];
end

u = linspace(u(1),u(2),100);
v = linspace(v(1),v(2),20);

[u,v] = meshgrid(u,v);
x = cos(u) + v.*cos(0.5*u).*cos(u);
y = sin(u) + v.*cos(0.5*u).*sin(u);
z = v.*sin(0.5*u);

h = surf(x,y,z);
hold on;
axis tight;
grid off;
material([0.8,0.6,0.5,30]);
light('Position',[200,-20,-20]);
light('Position',[-20,300,-20]);
colormap summer;
shading interp;
lighting phong;
axis off;
hold off;