function [lineHandle,xline, yline] = linedraw(x1,y1,x2,y2,lineStyle,nPoint)
%LINEDRAW draws a line connecting two arbitrary separated points in 2-D.
%   Input parameters
%       x1          Abscissa of one of given points
%       y1          Ordinate of one of given points
%       x2          Abscissa of the other given points
%       y2          Ordinate of the other given points
%       lineStyle   Line style
%       nPoint      Number of points along the line
%   Output parameters
%       lineHandle  Handle of line plot
%       xline       Abscissa of line data
%       yline       Ordinate of line data
%
%   Usage Examples:
%       linedraw(-5,0,5,0);
%       linedraw (0,-5,0,5,'c-')
%
%       h1 = linedraw(-3,2,4,-1);
%       set(h1,'LineWidth',2,'color',[1 0 1]);
% 
%
%See also LINE

% Designed by: Lei Wang, <WangLeiBox@hotmail.com>, 11-Mar-2003.
% Last Revision: 21-Mar-2003.
% Dept. Mechanical & Aerospace Engineering, NC State University.
% Copyright (c)2003, Lei Wang <WangLeiBox@hotmail.com>
%$Revision: 1.0 $  $ 3/24/2003 9:24 PM $

if (nargin < 4)|(nargin > 6),
    error('Please see help for INPUT DATA.');
elseif nargin == 4
    nPoint = 50;
    lineStyle = ['b-']; 
elseif nargin == 5
    nPoint = 50;
end

if (x1==x2)&(y1==y2)
    error('Two points have the same position. Please use the sperated ponits data for drawing a line.');
end

Lx = x2-x1;
Ly = y2-y1;
dx = Lx/nPoint;
dy = Ly/nPoint;

if (x1~=x2)&(y1~=y2)    
    xline = [x1:dx:x2];
    slope = (y2-y1)/(x2-x1);
    yline = y1 + (xline-x1)*slope;   
    
elseif (x1==x2)&(y1~=y2)    
    yline = [y1:dy:y2];    
    xline = x1*ones(size(yline));
    
elseif (x1~=x2)&(y1==y2)         
    xline = [x1:dx:x2];    
    yline = y1*ones(size(xline));
    
else
    error('Two points have the same position. Please use the sperated two data for drawing a line.');
end

% Plot the line connecting two points
%--------------------------------------------
lineHandle = plot(xline,yline,lineStyle);