% | 
% |   ROTATION DEFINITION
% |
x = unit(e1-e2/3); %/
I = e1^e2; %/
angle = pi/6; %/
%%
Rx = gexp(-I*angle)*x; %/
xper = x*I; %/
Iper = I/I3; %/
%%
clf; %/
draw(x,'r'); GAtext(1.1*x+0.1*Iper,'x','r'); %/
draw(I*pi*norm(x)*norm(x),'y'); %/
axis off; %/
% | 
% |   A vector x and a plane I containing it.
% |
GAprompt; %/
%GAview([0 90]); %/
draw(xper,'b'); GAtext(1.1*xper+0.1*Iper,'x_\perp = x {\fontname{times}I}','b'); %/
% |
% |   The perpendicular to x in that plane (its dual).
% |
GAprompt; %/
draw(Rx,'r'); GAtext(1.1*Rx+0.1*Iper,'Rx','r'); %/
DrawPolyline({(Rx^x)/x,Rx,inner(Rx,x)/x},'m'); %/
% |
% |   The rotated x can be composed from these, 
% |   in a coordinate-free manner.
% |
title('Rx = (cos \phi) x + (sin \phi) (x {\fontname{times}I}) = x (cos \phi + {\fontname{times}I} sin \phi) = x e^{{\fontname{times}I}\phi}'); %/
