function [u,ux,uy,X,Y]=recseris(udat,a,b,iside,x,y,N)
%
% [u,ux,uy,X,Y]=recseris(udat,a,b,iside,x,y,N)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function computes a function harmonic in
% a rectangle with general function values given
% on one side and zero function values on the 
% other three sides.
% udat    - a data array to determine the function
%           values by piecewise linear interpolation
%           along the side having nonzero values.
%           udat(:,1) contains either x or y values
%           along a side, and udat(:,2) contains
%           corresponding function values
% a,b     - side lengths for the x and y directions
% iside   - an index indicating the side for which
%           function values are given. 
%           [1,2,3,4]<=>[bottom,top,left,right]
% x,y       data vectors defining a grid 
%           [X,Y]=meshgrid(x,y) on which the function
%           and its first partial derivatives are
%           computed
% N       - number of series terms used (up to 500)
% u,ux,uy - arrays of values of the harmonic function
%           and its first partial derivatives
% X,Y       arrays of coordinate values for which
%           function values were computed.

x=x(:)'; y=y(:); ny=length(y); N=min(N,500);
if iside<3, period=2*a; else, period=2*b; end
c=ftsincof(udat,period); n=1:N; c=c(n);
if iside<3     % top or bottom sides
   npa=pi/a*n; c=c./(1-exp(-2*b*npa));
   sx=sin(npa(:)*x); cx=cos(npa(:)*x);
   if iside==1 % bottom side
      dy=exp(-y*npa); ey=exp(-(2*b-y)*npa);
      u=repmat(c,ny,1).*(dy-ey)*sx;
      c=repmat(c.*npa,ny,1);
      ux=c.*(dy-ey)*cx; uy=-c.*(dy+ey)*sx;
   else        % top side
      dy=exp((y-b)*npa); ey=exp(-(y+b)*npa);
      u=repmat(c,ny,1).*(dy-ey)*sx; 
      c=repmat(c.*npa,ny,1);
      ux=c.*(dy-ey)*cx; uy=c.*(dy+ey)*sx;
   end
else           % left or right sides
   npb=pi/b*n; c=c./(1-exp(-2*a*npb));
   sy=sin(y*npb); cy=cos(y*npb);
   if iside==3 % left side
      dx=exp(-npb(:)*x);
      ex=exp(-npb(:)*(2*a-x));
      u=repmat(c,ny,1).*sy*(dx-ex);
      c=repmat(c.*npb,ny,1);
      ux=c.*sy*(-dx-ex); uy=c.*cy*(dx-ex);
   else        % right side
      dx=exp(-npb(:)*(a-x)); 
      ex=exp(-npb(:)*(a+x));
      u=repmat(c,ny,1).*sy*(dx-ex);
      c=repmat(c.*npb,ny,1);
      ux=c.*sy*(dx+ex); uy=c.*cy*(dx-ex);
   end
end
[X,Y]=meshgrid(x,y);