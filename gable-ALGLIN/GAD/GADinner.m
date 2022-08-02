% 	INNER PRODUCT
GAfigure; clc; %/
% 	INNER PRODUCT
%
global x B v w; %/
clf; %/
% 	The inner product of two vectors is a scalar 
% 	(its magnitude denotes the relative angle)
%.
v = e1;
w = unit(e1 + e2);
draw(v,'b'); %/
GAtext(0.7*v - 0.1*unit(e2^v)/I3,'v'); %/
draw(w,'g'); %/
GAtext(0.7*w + 0.1*unit(e2^w)/I3,'w'); %/
inner(v,w) %w
% Geometrically, this is a zero-dimensional subspace:
% a weighted point at the origin.
draw(inner(v,w),'r'); %/
draw(I3/100000,'r'); %/
GAprompt; %/
%.
% 	The inner product x.B of a vector x and a bivector B is 
% 	a vector in B, perpendicular to x
% 	(its magnitude denotes the relative angle)
%.
clf; %/
x = unit(e1 + e3); 
draw(x,'b'); %/
GAtext(0.7*x + 0.1*unit(e2^x)/I3,'x'); %/
B = e1^e2; 
%% ===>  This is v^w, but we prevent unnecessary variables.
%% ===>  Yet the labels are plotted using v,w in case we want to change this.
draw(B,'y'); %/
GAtext(-0.5*v+0.1*B/I3,'B'); %/
inner(x,B) %w
axis off; %/
draw(inner(x,B),'r'); %/
GAtext(inner(x,B)+0.1*B/I3,'x \bullet B'); GAprompt; %/ 
%	Spinning shows that x.B is "the part of B least like x".
GAorbiter(-360,10); %/
