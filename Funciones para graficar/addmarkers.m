function ho=addmarkers(hi,n)
% ADDMARKERS    Add a pre-defined number of markers to a plot instead of
% one at each datapoint which is default in Matlab.
%
% Usage:
% ADDMARKERS(HI) adds 5 markers to the input handle HI
% ADDMARKERS(HI,N) adds N markers to the input handle HI
% HO=ADDMARKERS(...) returns the output handle HO for future usage such as
% changing colors, markers, etc.
%
% Hint: use the output handle when adding legends, e.g.
% LEGEND(HO,'legend 1',...,'legend N')
%
% The markers will be added in the following order:
%
% o     Circle
% s     Square
% d     Diamond
% x     Cross
% +     Plus sign
% *     Asterisk
% .     Point
% ^     Upward-pointing triangle
% v     Downward-pointing triangle
% >     Right-pointing triangle
% <     Left-pointing triangle
% p     Five-pointed star (pentagram)
% h     Six-pointed start (hexagram)
%
% By Matthijs Klomp at Saab Automobile AB, 2009-03-18
% E-mail: matthijs.klomp@gm.com
%
if nargin<2, n=5; end % default
if nargin<1, error('Supply an input handle as input argument.'), end
hold on                                 % do not overwrite the current plot
markers = {'o','s','d','^','v','x','+','*','.','>','<','p','h'};
ho = hi;                                % initialize output handle
for i = 1:length(hi)
    x = get(hi(i),'xdata');             % get the independent variable
    y = get(hi(i),'ydata');             % get the dependent variable data
    s = linspace(1,n,length(x));        % sampling independent variable
    xrs = interp1(s,x,1:n,'nearest');   % downsample to n datapoints
    yrs = interp1(s,y,1:n,'nearest');   % downsample to n datapoints
    ho(i) = plot(xrs,yrs,...            % Plot the markers
        'Marker',markers{i},'LineStyle','None','Color',get(hi(i),'Color'));
end
if nargout==0, clear ho, end

