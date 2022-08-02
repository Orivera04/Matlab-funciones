function [x,y,ydot,xo]=mmgetpt(xy,xdata,ydata,w)
%MMGETPT Get Graphical Point With Interpolation. (MM)
% [X,Y,Ydot]=MMGETPT(XY,Xdata,Ydata,W) uses the point XY=[x y] to find
% the nearest point on the piecewise linear interpolation of the
% graphical data vectors Xdata and Ydata. W is an optional scalar
% weight that gives weight W to the x-axis data and (1-W) weight to
% the y-axis data. By default W=1 and only x-axis data is used to
% find the closest point.
% X and Y are the coordinates of the interpolated point.
% Ydot is the slope at the interpolated point based on quadratic
% interpolation of the three Xdata and Ydata points nearest to XY.
% Typical usage:
%     xy=get(gca,'CurrentPoint');
%     xdata=get(H,'Xdata'); ydata=get(H,'Ydata'); % line data
%     [x,y,ydot]=MMGETPT(xy(1,1:2),xdata,ydata)
%
% x,y are coordinates of point on graph nearest xy(1,1:2) and
% ydot is slope at x,y when fit with a quadratic.
%
% See also MMGINPUT.

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 11/21/96, revised 12/5/96, v5: 1/16/97, 9/1/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

xlen=length(xdata);
if xlen~=length(ydata)
   error('Xdata and Ydata Must Have the Same Length.')
end
if xlen<3
   error('Xdata and Ydata Must Contain at Least 3 Points.')
end
if nargin==3, w=1; end
x=xy(1);
y=xy(2);

if w==1  % weight x-axis only
   [tmp,ip]=min(abs((xdata-x)));
elseif w==0  % weight y-axis only
   [tmp,ip]=min(abs((ydata-y)));
elseif w>0 & w<1  % mixed weight
   adx=max(xdata)-min(xdata);
   if abs(adx)<eps, adx=1; end
   ady=max(ydata)-min(ydata);
   if abs(ady)<eps, ady=1; end
   [tmp,ip]=min(w*abs((xdata-x)/adx)+(1-w)*abs((ydata-y)/ady));
else
   error('W Must be Between 0 and 1.')
end

if ip==1,        idx=[1 2 3];
elseif ip==xlen, idx=xlen-[0 1 2];
else,            idx=ip+[-1 0 1];
end

xi=xdata(idx);
dx=xi([2 3])-xi([1 2]);
yi=ydata(idx);
dy=yi([2 3])-yi([1 2]);

if (x>xi(1) & x<xi(2)) | (x<xi(1) & x>xi(2))
   a=(x-xi(1))/dx(1);
   y=a*yi(2)+(1-a)*yi(1);
elseif (x>xi(2) & x<xi(3)) | (x<xi(2) & x>xi(3))
   a=(x-xi(2))/dx(2);
   y=a*yi(3)+(1-a)*yi(2);
elseif (y>yi(1) & y<yi(2)) | (y<yi(1) & y>yi(2))
   a=(y-yi(1))/dy(1);
   x=a*xi(2)+(1-a)*xi(1);
elseif (y>yi(2) & y<yi(3)) | (y<yi(2) & y>yi(3))
   a=(y-yi(2))/dy(2);
   x=a*xi(3)+(1-a)*xi(2);
else
   x=xdata(ip);
   y=ydata(ip);
end

if nargout>=3  % compute slope at point
   xd=xdata(idx).';
   A=ones(3);       % find quadratic thru three nearest points
   A(:,1)=xd.^2; A(:,2)=xd;
   yd=ydata(idx);
   qp=A\yd(:);
   ydot=[2*x 1 0]*qp; % eval derivative at point
end
