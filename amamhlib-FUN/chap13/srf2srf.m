function [d,r,R]=srf2srf(x,y,z,X,Y,Z)
% [d,r,R]=srf2srf(x,y,z,X,Y,Z)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function determines the closest points on two
% surfaces and the distance between these points.
% x,y,z  -  arrays of points on the first surface
% X,Y,Z  -  arrays of points on the second surface
% d      -  the minimum distance between the surfaces
% r,R    -  vectors containing the coordinates of the
%           nearest points on the first and the 
%           second surface  

x=x(:); y=y(:); z=z(:); n=length(x); v=ones(n,1); 
X=X(:)'; Y=Y(:)'; Z=Z(:)'; N=length(X); h=ones(1,N);
d2=(x(:,h)-X(v,:)).^2; d2=d2+(y(:,h)-Y(v,:)).^2;
d2=d2+(z(:,h)-Z(v,:)).^2;
[u,i]=min(d2); [d,j]=min(u); i=i(j); d=sqrt(d);
r=[x(i);y(i);z(i)]; R=[X(j);Y(j);Z(j)];