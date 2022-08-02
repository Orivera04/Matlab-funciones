function [xi,yi] = ginputplot(varargin)
%
% GINPUTPLOT finds points on the 2-D plot nearest to the mouse click
% 
%   [XI,YI] = GINPUTPLOT(N) gets N points from the current axes and 
%   returns the nearest points on the plot of Y versus X, in length N 
%   vectors XI and YI, where X and Y are respectively 'XData' and 'YData'
%   properties of all childern objects in the current axes.
%
%   [XI,YI] = GINPUTPLOT gathers an unlimited number of points until
%   the return key is pressed.
%
%   GINPUTPLOT(H,N) and GINPUTPLOT(H) does the same as GINPUTPLOT(N) and
%   GINPUTPLOT for objects with handles H.
% 
% Example:
%
% [t,Y] = ode23(@lotka,[0 5],[20 20]');
% plot(Y(:,1),Y(:,2))
% [xi,yi] = ginputplot
%
% If any suggestions/improvements/entensions, please let me know.

% Mukhtar Ullah
% mukhtar.ullah@informatik.uni-rostock.de
% December 24, 2004

args = varargin;
nargs = nargin; 
if nargs > 2, error('Too many inputs'); end
if nargs > 0 && all(ishandle(args{1}))
    h = args{1};
    args = args(2:end);
    nargs = nargs - 1;
else
    h = get(gca,'Children');
end
n = inf;
if nargs > 0, n = args; end
[xi,yi] = ginput(n);
n = numel(xi);
xc = get(h,'xdata');
yc = get(h,'ydata');
if isscalar(h)
    x = xc(:);
    y = yc(:);
else
    x = [xc{:}].';
    y = [yc{:}].';
end

D = cell(2,n);
for i = 1:n
    D{1,i} = x - xi(i);
    D{2,i} = y - yi(i);
end
[md,id] = min([D{1,:}].^2 + [D{2,:}].^2);
xi = x(id);
yi = y(id);