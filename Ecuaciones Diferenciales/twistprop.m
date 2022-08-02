function [v,rc,vrr,V,Rc,Irr]=twistprop(A,B,M,X0,Y0,Z0)
%
% [v,rc,vrr,V,Rc,Irr]=twistprop(A,B,M,X0,Y0,Z0)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function computes geometrical properties of
% a twisted rope. Exact results are obtained using
% symbolic math to evaluate three surface integrals 
% for the volume, centroidal radius, and inertia 
% tensor. The symbolic calculations take about five 
% minutes to run.
%
% A,B,N    - parameters defining the twisted rope
% X0,Y0,Z0 - center coordinates for the centroid of
%            the twisted rope
% v,rc     - symbolic formulas for the volume and
%            centroid radius
% vrr      - symbolic formula for integral of
%            r*r'*d(vol)
% V,Rc     - numerical values for volume and 
%            centroid radius
% Irr      - numerical value for the inertia tensor

if nargin==0
   A=6; B=1; M=6; X0=1; Y0=2; Z0=3;
end

syms a b m t p xi eta rho x y z r rt rp real
syms x0 y0 z0 real
syms n dv dv1 v vr1 vr rg vrr1 vrr real
a=sym(A); b=sym(B); Pi=sym('pi');
x0=sym(X0); y0=sym(Y0); z0=sym(Z0);

% Surface equation for the twisted rope
xi=b*cos(t)*abs(cos(t));
eta=b*sin(t)*abs(cos(t));
rho=a+xi*cos(m*p)+eta*sin(m*p);
x=rho*cos(p)+x0; y=rho*sin(p)+y0; 
z=-xi*sin(m*p)+eta*cos(m*p)+p+z0;
Pi=sym('pi'); 

% Tangent vectors 
r=[x;y;z]; rt=diff(r,t); rp=diff(r,p);

% Integrate to get the volume
dv=det([r,rp,rt]); dv1=int(dv,t,0,2*Pi); 
v=simple(int(dv1,p,0,3*Pi)/3);

% First moment of volume
vr1=int(r*dv,t,0,2*Pi); 
vr=simple(int(vr1,p,0,3*Pi)/4);

% Radius to the centroid
rc=simple(vr/v);

% Integral of r*r'*d(vol)
vrr1=int(r*r'*dv,t,0,2*Pi);
vrr=simple(int(vrr1,p,0,3*Pi)/5);

% Obtain numerical values
V=double(subs(v,{a,b,m,x0,y0,z0},...
   {A,B,M,X0,Y0,Z0}));
Rc=double(subs(rc,{a,b,m,x0,y0,z0},...
   {A,B,M,X0,Y0,Z0}));
Irr=double(subs(vrr,{a,b,m,x0,y0,z0},...
   {A,B,M,X0,Y0,Z0}));

% Rigid body inertia tensor for a 
% body of unit mass density     
Irr=eye(3,3)*sum(diag(Irr))-Irr;