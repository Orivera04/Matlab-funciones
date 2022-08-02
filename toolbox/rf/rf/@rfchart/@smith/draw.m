function h = draw(h,eventData)
%DRAW  Draw a Smith chart

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.5 $  $Date: 2004/04/12 23:36:01 $

% Set XY data
setxy(h);

% Update HG lines
c1 = get(h,'Color');
c2 = get(h,'SubColor');
lw1 = get(h,'LineWidth');
lw2 = get(h,'SubLineWidth');
lt1 = get(h,'LineType');
lt2 = get(h,'SubLineType');
xdata = get(h, 'XData');
ydata = get(h, 'YData');

switch lower(get(h,'Type'))
case 'z'
    set(h.ImpedanceGrid, 'XData', xdata, 'YData', ydata, 'Visible', 'on', 'Color', c1, 'LineWidth', lw1, 'LineStyle', lt1);
    set(h.AdmittanceGrid, 'XData', [0], 'YData', [0], 'Visible', 'off', 'Color', c2, 'LineWidth', lw1, 'LineStyle', lt2);
case 'y'
    set(h.AdmittanceGrid, 'XData', -xdata, 'YData', ydata, 'Visible', 'on', 'Color', c1, 'LineWidth', lw1, 'LineStyle', lt1);
    set(h.ImpedanceGrid, 'XData', [0], 'YData', [0], 'Visible', 'off', 'Color', c2, 'LineWidth', lw2, 'LineStyle', lt2);
case 'zy'
    set(h.ImpedanceGrid, 'XData', xdata, 'YData', ydata, 'Visible', 'on', 'Color', c1, 'LineWidth', lw1, 'LineStyle', lt1);
    set(h.AdmittanceGrid, 'XData', -xdata, 'YData', ydata, 'Visible', 'on', 'Color', c2, 'LineWidth', lw2, 'LineStyle', lt2);
case 'yz'
    set(h.AdmittanceGrid, 'XData', -xdata, 'YData', ydata, 'Visible', 'on', 'Color', c1, 'LineWidth', lw1, 'LineStyle', lt1);
    set(h.ImpedanceGrid, 'XData', xdata, 'YData', ydata, 'Visible', 'on', 'Color', c2, 'LineWidth', lw2, 'LineStyle', lt2);
end
set(h.StaticGrid,'Visible','on','Color', c1,'LineWidth', lw1, 'LineStyle', lt1);

% Restack HG lines
restack(h);
label(h);
axis off;

function h = setxy(h, xyData)
%SETXY  Set Smith chart X/Y-data.

% Initialize line data vectors
N = 100; M = 128;
nn = size(h.Values,2);
X = zeros(1,((2+4*nn)*(N+1))+M+1);
Y = zeros(1,((2+4*nn)*(N+1))+M+1);

% Full circle at R=50
r = 50;
x0 = r/(r+1);
r0 = 1/(r+1);
t = 0:M;
s1 = 1;
s2 = s1+M;
X(1,s1:s2) = [x0+r0*sin(t*2*pi/M)];
Y(1,s1:s2) = [r0*cos(t*2*pi/M)];

% Full arcs at X = -50,+50
s1 = s2+1;
s2 = s1+2*N+1;
z = z2g((linspace(0,50,N)).^2+j*50*ones(1,N));
X(1,s1:s2) = [NaN real(z) NaN real(conj(z))];
Y(1,s1:s2) = [NaN imag(z) NaN imag(conj(z))];

% R+jX grid
for idx=1:nn
    s1 = s2+1;
    s2 = s1+4*N+3;
    r  = h.Values(1,idx);
    x  = (linspace(0,sqrt(h.Values(2,idx)),N)).^2;
    ZR = z2g(r*ones(1,N)+j*x);
    ZX = z2g(x+j*r*ones(1,N));
    X(1,s1:s2) = [NaN real(ZR) NaN real(conj(ZR)) NaN real(ZX) NaN real(conj(ZX))];
    Y(1,s1:s2) = [NaN imag(ZR) NaN imag(conj(ZR)) NaN imag(ZX) NaN imag(conj(ZX))];
end

% Record new data
set(h,'XData', X);
set(h,'YData', Y);

function h = restack(h)
%RESTACK  Restack grid lines.

% Find indices of smith chart grid lines within axes children
ch = allchild(double(h.Axes));
Yidx = find(double(h.AdmittanceGrid)==ch);
Zidx = find(double(h.ImpedanceGrid)==ch);

% If both Y and Z charts are visible, make sure current primary grid is on top
if ((Zidx>Yidx) & strcmpi(h.Type(1),'z')) | ((Yidx>Zidx) & strcmpi(h.Type(1),'y'))
   % Swap locations
   chY = ch(Yidx);
   chZ = ch(Zidx);
   ch(Zidx) = chY;
   ch(Yidx) = chZ;
   set(h.Axes,'Children',ch);
end

%%%%%%%%%%%%%%%%%%%
function g = z2g(z)
% Z2G  Converts normalized impedance to reflection coefficient
g = (z-1)./(z+1);
