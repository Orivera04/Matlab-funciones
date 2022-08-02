function [xx,yx,zx,xy,yy,zy]=mminxy(X,Y,Z)
%MMINXY Minima of 3D Data Along X and Y Axes. (MM)
% [Xx,Yx,Zx,Xy,Yy,Zy]=MMINXY(X,Y,Z) finds minima in the
% Z matrix along the axis directions in X and Y.
% X and Y can be plaid matrices, e.g., created by MESHGRID,
% or they can be vectors defining the x and y axes.
%
% Xx,Yx,Zx are x,y,z coordinates of minima along the X axis.
% Xy,Yy,Zy are x,y,z coordinates of minima along the Y axis.
%
% At Xx(i), Yx(i) is the Y value where Zx(i) = min{Z=f(Xx(i),Y)} occurs.
% At Yy(i), Xy(i) is the X value where Zy(i) = min{Z=f(X,Yy(i))} occurs.
%
% plot3(Xx,Yx,Zx) draws a line from min(X) to max(X)
%                 identifying the minimum in Z
% plot3(Xy,Yy,Zy) draws a line from min(Y) to max(Y)
%                 identifying the minimum in Z

% D.C. Hanselman, University of Maine, Orono ME,  04469
% 12/6/95, revised 9/4/96, v5: 1/13/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

sx=size(X);
sy=size(Y);
sz=size(Z);
if all(sx==sz), X=X(1,:); end		% get x-axis vector
if all(sy==sz), Y=Y(:,1); end		% get y-axis vector
X=X(:);
Y=Y(:);

[zm,i]=min(Z);		% min w.r.t. y for each fixed x
xx=X(:);
yx=Y(i);
zx=zm(:);

[zm,i]=min(Z');		% min w.r.t. x for each fixed y
xy=X(i);
yy=Y(:);
zy=zm(:);
