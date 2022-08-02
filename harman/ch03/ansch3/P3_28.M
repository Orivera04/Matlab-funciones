% P3_28.M
% Rotate triangle and plot results
%   Input vertices and angle in degrees
%   Calls function vrot
p1=input(' Vertex [p11,p12]= ')    % Input the three vertices
p2=input(' Vertex [p21,p22]= ')
p3=input(' Vertex [p31,p32]= ')
theta=input(' Input rotation angle (degrees)= ')
x1=vrot(p1',theta);
x2=vrot(p2',theta);
x3=vrot(p3',theta);
% Original triangle  
xpts1=[p1(1) p2(1) p3(1) p1(1)];
ypts1=[p1(2) p2(2) p3(2) p1(2)];
% Rotated triangle
xptsrot=[x1(1) x2(1) x3(1) x1(1)];
yptsrot=[x1(2) x2(2) x3(2) x1(2)];
%
plot(xpts1,ypts1), hold on
plot(xptsrot,yptsrot)
hold off
axis('square'), axis([0 4 0 4])
%
%  Where is the axis of rotation? Can you modify the 
%   script to rotate a triangle around its centroid?
%


