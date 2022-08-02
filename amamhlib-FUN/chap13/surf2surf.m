function [d,r,R]=surf2surf(x,y,z,X,Y,Z,n)
% [d,r,R]=surf2surf(x,y,z,X,Y,Z,n)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function determines the closest points on two
% surfaces and the distance between these points. It
% is similar to function srf2srf except that large
% arrays can be processed. 
%
% x,y,z  -  arrays of points on the first surface
% X,Y,Z  -  arrays of points on the second surface
% d      -  the minimum distance between the surfaces
% r,R    -  vectors containing the coordinates of the
%           nearest points on the first and the 
%           second surface 
% n      -  length of subvectors used to process the
%           data arrays. Sending vectors of length
%           n to srf2srf and taking the best of the
%           subresults allows processing of large
%           arrays of data points
%
% User m functions used: srf2srf

if nargin<7, n=500; end
N=prod(size(x)); M=prod(size(X)); d=realmax;
kN=max(1,floor(N/n)); kM=max(1,floor(M/n));
for i=1:kN
  i1=1+(i-1)*n; i2=min(i1+n,N); i12=i1:i2;
  xi=x(i12); yi=y(i12); zi=z(i12);
  for j=1:kM
    j1=1+(j-1)*n; j2=min(j1+n,M); j12=j1:j2;
    [dij,rij,Rij]=srf2srf(...
                  xi,yi,zi,X(j12),Y(j12),Z(j12));
    if dij<d, d=dij; r=rij; R=Rij; end
  end
end

%=================================================

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