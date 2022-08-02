function [x,y,z,X,Y,Z]=plot2cyls(...
             rad,len,r0,vc,Rad,Len,R0,Vc,d,titl)
% [x,y,z,X,Y,Z]=plot2cyls(rad,len,r0,vc,Rad,...
%                         Len,R0,Vc,d,titl)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function generates point grids on the
% surfaces of two circular cylinders and plots
% both cylinders together
%
% User m functions called: cornrpts surfmany
%                          cylpts  
if nargin==0
   titl='TWO CYLINDERS';
   rad=1; len=3; r0=[4,0,0]; vc=[3,0,4];
   Rad=1; Len=3; R0=[0,4,0]; Vc=[0,3,4]; d=.2;
end
if isempty(titl), titl=' '; end
u=2*rad+len; v=2*pi*rad;
nu=ceil(u/d); nv=ceil(v/d);
u=cornrpts([0,rad,rad+len,u],nu)/u;
v=linspace(0,1,nv);
[x,y,z]=cylpts(u,v,rad,len,r0,vc); 
U=2*Rad+Len; V=2*pi*Rad;
Nu=ceil(U/d); Nv=ceil(V/d);
U=cornrpts([0,Rad,Rad+Len,U],Nu)/U;
V=linspace(0,1,Nv);
[X,Y,Z]=cylpts(U,V,Rad,Len,R0,Vc);
surfmany(x,y,z,X,Y,Z), title(titl)
colormap([1 1 0]), shg