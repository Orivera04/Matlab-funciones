%	Manual tuning of a generalized bell membership funciton.

%	Copyright (c) 1993 Jyh-Shing Roger Jang, U. C. Berkeley
%	jang@eecs.berkeley.edu

%	Roger Jang, 7-4-93.
%	Roger Jang, 12-20-96.

echo on;
% This file let you change the a, b and c parameters to see how they affect
% the shape of a generalized bell membership function, which is defined as
% f(x) = 1/{1 + [(x-c)/a]^(2b)}.
echo off;

set(gcf, 'position', [10 544 560 420]);
x = linspace(-10, 10, 201)';
a = 5; b = 2; c = 0;
y = gbell_mf(x, [a, b, c]);
mfH(1) = line(x, y, 'linewidth', 2);
mfH(2) = line(x, y, 'linestyle', 'o', 'color', 'm');
set(gca, 'box', 'on');
axis([min(x) max(x) 0 1]);
title(['a = ' num2str(a) ', b = ' num2str(b) ', c = ' num2str(c)]);
xlabel('Click the sliders to change parameters of this MF.');

drawnow

s = ['x=-10:.1:10;' ...
        'a = get(aH,''Value'');' ...
        'b = get(bH,''Value'');' ...
        'c = get(cH,''Value'');' ...
        'y = gbell_mf(x, [a, b, c]);' ...
	'set(mfH, ''ydata'', y);' ...
	'title([''a = '' num2str(a) '', b = '' num2str(b) '', c = '' num2str(c)]);'];

aH = uicontrol('Style','slider','Position',[0.95 0.70 0.03 0.20],...
        'Min',1,'Max',10, 'Units', 'normalized', ...
        'Value',5,'CallBack',s);

bH = uicontrol('Style','slider','Position',[0.95 0.40 0.03 0.20],...
        'Min',-10,'Max',10, 'Units', 'normalized', ...
        'Value',2,'CallBack',s);

cH = uicontrol('Style','slider','Position',[0.95 0.10 0.03 0.20],...
        'Min',-10,'Max',10, 'Units', 'normalized', ...
        'Value',0,'CallBack',s);

% an invisible axes for putting on texts
axes('pos',[0 0 1 1],'Visible','off');
% text for a
text(.94,.7,'1','hor','right');
text(.94,.9,'10','hor','right');
text(.94,.8,'a:','horizontalalignment','right');
% text for b
text(.94,.4,'-10','hor','right');
text(.94,.6,'10','hor','right');
text(.94,.5,'b:','horizontalalignment','right');
% text for c
text(.94,.1,'-10','hor','right');
text(.94,.3,'10','hor','right');
text(.94,.2,'c:','horizontalalignment','right');

% The CLOSE button
closeHndl=uicontrol( ...
	'Style','pushbutton', ...
	'Units','normalized', ...
	'Position',[0.87 0.01 0.1 0.05], ...
	'String','Close', ...
	'Callback','close(gcf)');
