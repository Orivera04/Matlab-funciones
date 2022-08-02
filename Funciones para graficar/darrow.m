function h = darrow(xi,yi,u,v,s)
% DARROW  draw arrows at specified point in spefied directions
%
%   DARROW(X,Y,U,V,S) for scalar arguments, draws an arrow of lengths S  at
%   point (X,Y) in the direction (U,V).
%
%   When one or more input arguments are column vectors, arrows of 
%   specified lengths are drawn at each point in specifed directions
%
%   H = DARROW(...) also returns the associated handle

% Mukhtar Ullah
% mukhtar.ullah@informatik.uni-rostock.de
% December 8, 2004

if nargin < 5, s = 1; end
w = [u v];
normw = sqrt(sum(w.^2,2));
normw(~normw) = 1;
w = w./normw(:,[1 1]);
xf = xi + w(:,1).*s;
yf = yi + w(:,2).*s;
xrang = get(gca,'xlim');
yrang = get(gca,'ylim');
pos = get(gca,'position');
x = pos(1) + pos(3)*[xi xf]/xrang(2);
y = pos(2) + pos(4)*[yi yf]/yrang(2);
h = findobj(gca,'Type','line');
n = numel(xi);
h = zeros(n,1);
for i = 1:n, h(i) = annotation('arrow',x(i,:),y(i,:)); end