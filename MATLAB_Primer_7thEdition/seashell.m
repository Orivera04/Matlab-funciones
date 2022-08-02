figure(1) ; clf
t = linspace(0, 2*pi, 512) ;
[u,v] = meshgrid(t) ;

% for front cover:
a = -0.2 ; b = .5 ; c = .1 ;
% for back cover
% a = -0.5 ; b = .5 ; c = .1 ;
n = 2 ;
x = (a*(1-v/(2*pi)).*(1+cos(u)) + c) ...
    .* cos(n*v) ;
y = (a*(1-v/(2*pi)).*(1+cos(u)) + c) ...
    .* sin(n*v) ;
z = b*v/(2*pi) + ...
    a*(1-v/(2*pi)) .* sin(u) ;

surf(x,y,z,y)
shading interp

axis off
axis equal
colormap(hsv(1024))
material shiny
lighting gouraud
lightangle(80, -40)
lightangle(-90, 60)
view([-150 10])
