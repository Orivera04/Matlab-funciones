function [x,y,icrnr]=makcrcsq
%
% [x,y,icrnr]=makcrcsq
% ~~~~~~~~~~~~~~~~~~~~
% This function creates data for a geometry 
% involving half of an annulus placed above a 
% square containing a square hole.
%
% x,y   - data points characterizing the data
% icrnr - index vector defining corner points
%
% User m functions called:  none
%----------------------------------------------

xshift=3.0; yshift=3.0;
a=2; b=1; narc=7; x0=0; y0=2*a-b;
xy=[a,-a,-b, b, b,-b,-b,-a,-a, a, a;
    a, a, b, b,-b,-b, b, a,-a,-a, a]';
theta=linspace(0,pi,narc)'; 
c=cos(theta); s=sin(theta); 
xy=[xy;[x0+a*c,y0+a*s]]; 
c=flipud(c); s=flipud(s);
xy=[xy;[x0+b*c,y0+b*s];[a,y0];[a,a]];
x=xy(:,1)+xshift; y=xy(:,2)+yshift;
icrnr=[(1:12)';11+narc;12+narc; ...
       11+2*narc;12+2*narc;13+2*narc];