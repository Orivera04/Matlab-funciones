function F=extinterp2(X,Y,Z,U,V);
%EXTINTERP2 extends interp2 to provide extrapolation outside the bounds
% ZI = INTERP2(X,Y,Z,XI,YI) interpolates to find ZI, the values of the
%   underlying 2-D function Z at the points in matrices XI and YI.
%   Matrices X and Y specify the points at which the data Z is given.
%   
%   XI can be a row vector, in which case it specifies a matrix with
%   constant columns. Similarly, YI can be a column vector and it 
%   specifies a matrix with constant rows. 
%
%		The function extrapolates by extend the mesh originally specified by X and Y.
%   Thus if originally X and Y gave an n by m grid, then a new n by m grid will be created
%   where the maximal and minimal values are those largest and smallest of the 
%   values in the combined X and Xi entities. Z values are adjusted by extending 
%   the previous bilinear interpolations into the new region.
%
%
%   X,Y Z,XI and YI should be as in interp2. This will use bilinear 
%   interpolation and extrapolation to obtain estimates of a function
%   at grid points specified by u and v. Unfortunately due to the 
%   way this function works, certain error messages may not be as 
%   helpful as in interp2. 
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:50:05 $

%If inputs aren't valid then set output to nan
%if any(any(isnan(U))) |any(any(isnan(V))) | any(any(isnan(X))) |...
%      any(any(isnan(Y))) | any(any(isnan(Z)))
%   F=nan;
%   return
%end

%Make vector inputs column vectors
X=X(:);
Y=Y(:);
u=U(:);
v=V(:);

ut=max(max(u));
ub=min(min(u));
vt=max(max(v));
vb=min(min(v));
mX=prod(size(X));
mY=prod(size(Y));

[m,n]=size(X);
% get vector of X gridpoints
if n==1
    Xv=X';
else 
    Xv=X(1,:);
end
[k,l]=size(Y);
% Do same for Y.
if l==1
    Yv=Y';
else 
    Yv=Y(:,1)';
end

xb=min(X(1),ub);
xt=max(X(mX),ut);
yb=min(Y(1),vb);
yt=max(Y(mY),vt);

Xu=[xb Xv(2:length(Xv)-1) xt];
Yu=[yb Yv(2:length(Yv)-1) yt];

[XX,YY]=meshgrid(Xu,Yu);

[p,q]=size(Z);
ZZ=zeros(size(Z));
ZZ(2:p-1,2:q-1)=Z(2:p-1,2:q-1);
ZZ(1,2:q-1)=Z(1,2:q-1)+(Z(2,2:q-1)-Z(1,2:q-1))/(Yv(2)-Yv(1))*(Yu(1)-Yv(1));
ZZ(p,2:q-1)=Z(p,2:q-1)+(Z(p,2:q-1)-Z(p-1,2:q-1))/(Yv(p)-Yv(p-1))*(Yu(p)-Yv(p));
ZZ(2:p-1,1)=Z(2:p-1,1)+(Z(2:p-1,2)-Z(2:p-1,1))/(Xv(2)-Xv(1))*(Xu(1)-Xv(1));
ZZ(2:p-1,q)=Z(2:p-1,q)+(Z(2:p-1,q)-Z(2:p-1,q-1))/(Xv(q)-Xv(q-1))*(Xu(q)-Xv(q));
ZZ(1,1)=lin(Z(1,1),Z(1,2),Z(2,1),Z(2,2),Xv(1),Yv(1),Xv(2),Yv(2),Xu(1),Yu(1));
ZZ(1,q)=lin(Z(1,q-1),Z(1,q),Z(2,q-1),Z(2,q),Xv(q-1),Yv(1),Xv(q),Yv(2),Xu(q),Yu(1));
ZZ(p,1)=lin(Z(p-1,1),Z(p-1,2),Z(p,1),Z(p,2),Xv(1),Yv(p-1),Xv(2),Yv(p),Xu(1),Yu(p));
ZZ(p,q)=lin(Z(p-1,q-1),Z(p-1,q),Z(p,q-1),Z(p,q),Xv(q-1),Yv(p-1),Xv(q),Yv(p),Xu(q),Yu(p));

if length(u) ==1;
   u = repmat(u,size(V));
else
   u = reshape(u,size(U));
end
if length(v)==1;
   v = repmat(v,size(U));
else
   v = reshape(v,size(V));
end

F=interp2(XX,YY,ZZ,u,v);

% subfunction to compute values of ZZ matrix at corners.

function  K=lin(a,b,c,d,u,p,v,q,x,y);


K=-(v*q*a-x*q*a-y*v*a+x*y*a-b*u*q+b*x*q+b*y*u-x*y*b-c*v*p+c*x*p...
    +c*y*v-x*y*c+u*p*d-x*p*d-y*u*d+x*y*d)/(-v*q+v*p+u*q-u*p);


