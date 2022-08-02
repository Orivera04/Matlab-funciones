function out=symint2(integrand,var1,varlim1,varlim2,var2,lim1,lim2)
%SYMINT2 Symbolically evaluate double integral. 
%   SYMINT2 is basically a "wrapper" for iterated application of INT.
%   The INNER integral should be written first.
%   Example:
%       syms x y
%       symint2(x,y,0,x,x,1,2) integrates
%       the function x over the trapezoid 1<x<2, 0<y<x,
%       and gives the symbolic output 7/3.
%   See also NUMINT2.
out=int(int(integrand,var1,varlim1,varlim2),var2,lim1,lim2);
