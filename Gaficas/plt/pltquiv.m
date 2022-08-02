% pltquiv.m

% Demonstrates several plt features:
% - The Quiver parameter ([2 3]) specifies that the second (v1x,v1y)
%   and third (v2x,v2y) ordered pairs are two be plotted as vectors
%   using the previous ordered pair (x,y) as the tail of each vector.
%   This is somewhat similar to the two matlab commands
%   quiver(x,y,v1x,v1y); quiver(x,y,v2x,v2y);
% - Using the AxisPos parameter to make room for long Trace ID names
% - Using tex commands (e.g. \uparrow) inside Trace ID names
% - Reassigning menu box items. In this example, the 'LinX' button is
%   replaced by a 'Filter' button. Its button down function (which is
%   executed when you click on 'Filter') searches for the 4th trace
%   (findobj) and swaps the contents of its user data and y-axis data.
% - Adding text items to the figure. Note that the text position is
%   specified using x and y axes coordinates
% - Using z data NaNs (not a number) to blank out portions of a trace

x = 0:.08:5;  x2 = 0:.01:5;  t = x/5;
y   = humps(t)/20;
y2  = 6 + rand(size(x2)) - humps(fliplr(x2/5))/20;
v1x = exp(-2*t).*sin(20*t);
v1y = t .* cos(15*(1-t).^3);
v2x = exp(-1.4*t).*sin(30*t.^5);
v2y = .5 - exp(-((4*t-2).^2));

h = plt('Quiver',[2 3],x,y,v1x,v1y,v2x,v2y,x2,y2,...
    'AxisPos',[1.2 1 .97 1 1.8],'Xlim',[-.2 5.2],'Ylim',[0 6.6],...
    'Options','-Y-M','FigName','pltquiv','TraceID',...
    {'humps \div 20','velocity1 \uparrow','velocity2 \uparrow','humps+rand'});

y2 = filter([1 1 1]/3,1,y2); y2 = y2([3 3:end end]); % smoothed y2
set(h(4),'tag','h4','user',y2); % save smoothed y2 in trace user data
set(findobj(gcf,'string','LinX'),'string','Filter','ButtonDownFcn',...
'h=findobj(''tag'',''h4''); set(h,''y'',get(h,''user''),''user'',get(h,''y''));');
set([text(3,5.6,'Click on ''Filter''') text(3,5.35,'in the menu box')],...
    'color',get(h(4),'color'));
set([text(3.7,.5,'Note the two gaps in') text(3.7,.25,'the humps function')],...
    'color','green','fontangle','italic');
x([13 24:26]) = NaN;  set(h(1),'z',x);  % create two gaps in trace 1
