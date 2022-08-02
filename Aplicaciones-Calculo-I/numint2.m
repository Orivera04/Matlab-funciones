function out=numint2(integrand,var1,varlim1,varlim2,var2,lim1,lim2)
%NUMINT2 Numerically evaluate double integral. 
%   NUMINT2 is basically a "wrapper" for DBLQUAD, to
%   get around the fact that the latter is only designed for integration
%   over a rectangle, and requires inline vectorized input.  The
%   INNER integral should be written first.
%   Example:
%       syms x y
%       numint2(x,y,0,x,x,1,2) integrates
%       the function x over the trapezoid 1<x<2, 0<y<x,
%       and gives the numerical output 2.3333.
%   See also SYMINT2.
syms uU
newvar1=varlim1+uU*(varlim2-varlim1);
integrand2=subs(integrand,var1,newvar1)*(varlim2-varlim1);
integrand3=inline([char(vectorize(integrand2)),'.*ones(size(uU))'],'uU',char(var2));
out=dblquad(integrand3,0,1,lim1,lim2);