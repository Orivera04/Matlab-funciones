% 	SPANNING: THE OUTER PRODUCT
GAfigure; clc; %/
% 	SPANNING: THE OUTER PRODUCT
%
global v w; %/
clf; %/
% 	The outer product is anti-symmetric:
%
e1^e2 %w
e2^e1 %w
e1^e1 %w
GAprompt; %/
% 	and the outer product is linear:
%.
e1^(e2+e3) %w
%	All bivectors expressible on BIVECTOR BASIS.
%.
% 	Those properties yield certain identities:
%.
e1^(e1+e2) %w
GAprompt; %/
%
% Now let us draw these bivectors
%.
v = e1 + e2;
w = e2 + 2*e3;
B = v^w;
DrawBivector(v,w);
GAview([30 30]); %/
GAtext(0.5*v-0.1*unit(w)+0.1*unit(grade(((v^w)/I3),1)),'v'); %/
GAtext(0.5*w+0.1*unit(v)+0.1*unit(grade(((v^w)/I3),1))+v,'w'); %/
GAtext(0.5*v+0.7*w-0.2*unit((v^w)*I3),'v \wedge w'); %/
axis('vis3d'); %/
GAprompt; %/ 
%	Again, the actual object is coordinate-free.
axis off; %/
GAprompt; %/
GAorbiter(380,10); %/
% 	The bivector v^w has dimension, direction, 
%	sense and area, but NO SHAPE
GAprompt; %/
va = [-1.5 2.5 -0.75 3.5 -1 2]; %/
axis(va); %/
% 	(a more distant view)');
GAprompt; %/
DrawBivector(v,1.5*v+w); 
GAtext(0.5*v+0.7*(1.5*v+w)-0.2*unit((v^w)*I3),'v \wedge w');  %/
axis(va); %/
GAprompt; %/
DrawBivector(v,-1.5*v+w); 
GAtext(0.5*v+0.7*(-1.5*v+w)-0.2*unit((v^w)*I3),'v \wedge w'); %/
axis(va); %/
GAprompt; %/
GAorbiter(360,10); GAprompt; %/
%	(Note that all points spanning same bivector with v
%	are on a line parallel to v)
%
GAprompt; %/
% 	If no spanning vectors are known 
%	we draw the bivector as a disk:
%.
draw(v^w,'g'); 
GAtext(-0.2*unit((v^w)*I3)-w/4,'v \wedge w'); %/ 
axis(va); %/
GAprompt; %/
GAorbiter(360,10); %/
