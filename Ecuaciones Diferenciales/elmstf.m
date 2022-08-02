function [k,vol]=elmstf(x,y,a,e,i,j)
%
% [k,vol]=elmstf(x,y,a,e,i,j)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% This function forms the stiffness matrix for 
% a truss element. The member volume is also 
% obtained.
%
% User m functions called: none
%----------------------------------------------

xx=x(j)-x(i); yy=y(j)-y(i); 
L=norm([xx,yy]); vol=a*L;
c=xx/L; s=yy/L; k=a*e/L*[-c;-s;c;s]*[-c,-s,c,s];
