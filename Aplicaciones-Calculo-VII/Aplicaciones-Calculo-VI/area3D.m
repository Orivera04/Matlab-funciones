function	plarea = area3D(x,y,z)

%AREA3D  Area of a 3D planar polygon which does not lie in the x-y plane.
%	AREA3D(X,Y,Z) calculates the area of a polygon in space
%	formed by vertices with coordinate vectors X,Y and Z.
%	If the coordinates of vertex v_i are x_i, y_i and z_i
%	twice the area of a polygon is given by:
%	2 A(P) = abs(N . (sum_{i=0}^{n-1} (v_i x v_{i+1})))
%	where N is a unit vector normal to the plane. The `.' represents the
%	dot product operator, the `x' represents the cross product operator,
%	and abs() is the absolute value function.	

%	----------------------------------------------------------------
%  Copyright (c) 2000 by Ioan M. Buciu
%	nelu@zeus.csd.auth.gr
%	10/04/2000
%	----------------------------------------------------------------

%	Length of vectors X,Y and Z
lx = length(x);
ly = length(y);
lz = length(z);

%	Auxilliars needed for normals length
edge0 = [x(2) - x(1),y(2) - y(1),z(2) - z(1)];
edge1 = [x(3) - x(1),y(3) - y(1),z(3) - z(1)]; 

%	Cross products
nor3 = [edge0(2)*edge1(3) - edge0(3)*edge1(2),...
      edge0(3)*edge1(1) - edge0(1)*edge1(3),...
      edge0(1)*edge1(2) - edge0(2)*edge1(1)];

%	Length of normal vectors
inveln = 1/(sqrt(nor3(1)*nor3(1) + nor3(2)*nor3(2) + nor3(3)*nor3(3)));

%	Make normals unit length
nor3 = inveln*nor3;

	for	i = 1:lx-1
   	csumx(i) = y(i)*z(i+1) - z(i)*y(i+1);
   	csumy(i) = z(i)*x(i+1) - x(i)*z(i+1);
   	csumz(i) = x(i)*y(i+1) - y(i)*x(i+1);
	end
csumx;
csumy;
csumz;
csumx = sum([csumx y(ly)*z(1)-z(lz)*y(1)]);
csumy = sum([csumy z(lz)*x(1)-x(lx)*z(1)]);
csumz = sum([csumz x(lx)*y(1)-y(ly)*x(1)]);

%	Calculate area
plarea = (abs(nor3(1)*csumx + nor3(2)*csumy + nor3(3)*csumz))/2;