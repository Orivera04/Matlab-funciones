%	AFFINE (HOMOGENEOUS) REPRESENTATION
GAfigure; clc; %/
%	AFFINE (HOMOGENEOUS) REPRESENTATION
%
% 	For 2-space representation of (e1,e2) plane,
%  	add 1 more dimension e.
global e p P q Q plane u d M; %/
clf; %/
e=e3; %/
size = 1; %/
va = [-size size -size size 0 2]; %/
plane = {e+size*(e1+e2),e+size*(e1-e2),e+size*(-e1-e2),e+size*(-e1+e2)}; %/
e = e3; 
I2 = e1^e2; %/
draw(e,'k') %/
GAview([120 5]); %/
GAtext(e/2-0.1*e2,'e'); %/
GAtext(1.1*e,'0','k'); %/
axis off; %/
DrawPolygon(plane,'w'); %/
axis(va); %/
GAprompt; %/
% A (weighted) point may be represented by a vector.
p = e1/3+e2/2;
draw(p,'b'); %/
GAtext(0.5*p+0.1*e,'p','b'); %/
axis(va); %/
GAprompt; %/
P = e+p;             
DrawHomogeneous(e,P,'b','r'); %/
GAtext(0.5*P + 0.1*unit(p),'P','b'); %/
axis(va); %/
GAprompt; %/
% 	We might as well denote label at the point in 2-space.
GAtext(1.1*P,'P','r'); %/
GAprompt; %/
% 	Tilting for a better view.
GAtilt(10,5); %/
GAprompt; %/
%% =========================================
%% 	BIVECTORS AS LINE ELEMENTS
clf; %/
e=e3; %/
size = 1; %/
plane = {e+size*(e1+e2),e+size*(e1-e2),e+size*(-e1-e2),e+size*(-e1+e2)}; %/
draw(e,'k'); %/
GAtext(1.1*e,'0'); %/
axis off; %/
GAview([120 15]); %/
p = e1/4+e2/2;
q = 2*e2/3-e1/2;
P = e+p;
Q = e+q;
DrawPolygon(plane,'w'); %/
DrawHomogeneous(e,P,'b','r'); %/
GAtext(1.1*P,'P','r'); %/
DrawHomogeneous(e,Q,'g','r'); %/
GAtext(1.1*Q,'Q','r'); %/
axis(va); %/
GAprompt; %/
% 	The bivector formed by P and Q can be used
% 	to represent the line element from P to Q.
P^Q %w
DrawBivector(P,Q,'y'); %/
GAtext(0.25*(P+Q)-0.1*unit((P^Q)/I3),'P \wedge Q'); %/
DrawSimplex({P,Q},'n','r'); %/
axis(va); %/
GAprompt; %/
%	The bivector can be reshaped to P^(Q-P):
DrawBivector(P,Q-P,'g'); %/
draw(Q-P,'r'); %/
GAtext((Q-P)/2-0.1*e,'Q-P','r'); %/
axis(va); %/
title('P \wedge Q = P \wedge (Q-P)','Color','r'); %/
%	A line element: characterized by 2 points, 
%	or by point and direction.
GAprompt; %/
GAtilt(-20,5); %/
GAtilt(20,7.5); %/
%	The projective split of the bivector
%	retrieves the line parameters.
%
%	The tangent vector:
GAprompt; %/
PQ = P^Q
u = inner(e,PQ)    %w
DrawBivector(e,u,'m'); %/
perp = grade((e^u)/norm(e^u)/I3,1); %/
GAtext( (e+u)/2 + 0.1*perp,'e \wedge u'); %/
DrawSimplex({e,e+u},'n','m'); %/
GAtext( u/2+1.05*e+0.05*perp,'u'); %/
axis(va); %/
GAprompt; %/
%	The moment:
M = inner(e,e^PQ)    %w
d = M/u;  %/
DrawBivector(d,u,'m'); %/
GAtext( (d+u)/2 + 0.05*grade((d^u)/norm(d^u)/I3,1),'M'); %/
axis(va); %/
GAprompt; %/
%	The perpendicular support vector:
d = M/u    %w
DrawSimplex({e,e+d},'n','m'); %/
GAtext( d/2+1.05*e+0.05*unit(u),'d'); %/
axis(va); %/
GAprompt; %/
GAtilt(70,5); %/

