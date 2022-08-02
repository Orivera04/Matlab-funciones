% 	VECTORS
GAfigure; clc; %/
% 	VECTORS
global v w; %/
clf; %/
%	Vectors can be defined using coordinates:
v = e1 + e2;
w = e2 + 2*e3;
draw(v,'b');
GAtext(0.5*v -0.1*unit(w),'v'); %/
draw(w,'g');
GAtext(0.5*w-0.1*unit(v),'w'); %/ 
axis('vis3d'); %/
va = [-0.1 1 0 2 -0.1 2]; %/
axis(va); %/
GAprompt; %/
GAorbiter(60,6); %/
GAprompt; %/
% 	Adding vectors, as usual:
v+w
draw(v+w,'r'); %/
GAtext(0.7*(v+w) -0.1*unit(w),'v+w'); %/
DrawPolyline({v,v+w},'k'); %/
DrawPolyline({w,v+w},'k'); %/
% 	But vector addition is coordinate-free,
%	so we will drop the axes.
axis(va); %/
GAprompt; %/
axis off; %/
GAprompt; %/
%	Vectors `are' geometrical objects in space.
GAorbiter(360,10); %/
