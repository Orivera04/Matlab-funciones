function xpklein(action);
%XPKLEIN Klein bottle demo.
%    	A Klein bottle is a nonorientable surface in 
%    	four-dimensional space. It is formed by attaching two 
%    	Mobius strips along their common boundary.
%
%    	Klein bottles cannot be constructed without intersection 
%    	in three-space. The figure shown is an example of such a 
%    	self-intersecting Klein bottle. 
%
%    	Thanks to Davide Cervone, University of Minnesota.

%       Denise L. Chen  7-6-93
%	Copyright (c) 1984-94 by The MathWorks, Inc.

oldFigNumber = watchon;

if nargin < 1,
    action='initialize';
end;
 
if strcmp(action,'initialize'),
    figNumber=figure( ...
        'Name','Klein Bottle', ...
        'NumberTitle','off', ...
        'Pointer','watch', ...
        'Visible','off');
    axes( ...
        'Position',[0.05 0.05 0.70 0.90], ...
        'Box','on', ...
        'NextPlot','add', ...
        'Visible','off');
 
    %===================================
    % Information for all buttons
    labelColor=[0.8 0.8 0.8];
    yInitPos=0.90;
    xPos=0.80;
    btnLen=0.15;
    btnWid=0.10;
    % Spacing between the button and the next command's label
    spacing=0.05;
    
    %====================================
    % The CONSOLE frame
    frmBorder=0.02;
    yPos=0.05-frmBorder;
    frmPos=[xPos-frmBorder yPos btnLen+2*frmBorder 0.9+2*frmBorder];
    uicontrol( ...
        'Style','frame', ...
        'Units','normalized', ...
        'Position',frmPos, ...
        'BackgroundColor',[0.50 0.50 0.50]);
 
    %====================================
    % The WHOLE button
    btnNumber=1;
    yPos=0.90-(btnNumber-1)*(btnWid+spacing);
    labelStr='Whole';
    callbackStr='xpklein(''whole'')';
    uicontrol( ...
        'Style','push', ...
        'Units','normalized', ...
        'Position',[xPos yPos-spacing btnLen btnWid], ...
        'String',labelStr, ...
        'Callback',callbackStr);
 
    %====================================
    % The HALF button
    btnNumber=2;
    yPos=0.90-(btnNumber-1)*(btnWid+spacing);
    labelStr='Half';
    callbackStr='xpklein(''half'')';
    uicontrol( ...
        'Style','push', ...
        'Units','normalized', ...
        'Position',[xPos yPos-spacing btnLen btnWid], ...
        'String',labelStr, ...
        'Callback',callbackStr);
 
    %====================================
    % The SPINMAP button
    btnNumber=3;
    yPos=0.90-(btnNumber-1)*(btnWid+spacing);
    labelStr='Spinmap';
    callbackStr= ...
       ['watchon;', ...
        'spinmap;', ...
        'watchoff;'];
    uicontrol( ...
        'Style','push', ...
        'Units','normalized', ...
        'Position',[xPos yPos-spacing btnLen btnWid], ...
        'String',labelStr, ...
        'Callback',callbackStr);
 
    %====================================
    % The INFO button
    labelStr='Info';
    callbackStr='xpklein(''info'')';
    uicontrol( ...
        'Style','push', ...
        'Units','normalized', ...
        'Position',[xPos 0.20 btnLen 0.10], ...
        'String',labelStr, ...
        'Callback',callbackStr);
 
    %====================================
    % The CLOSE button
    labelStr='Close';
    callbackStr= 'close(gcf)';
    uicontrol( ...
        'Style','push', ...
        'Units','normalized', ...
        'Position',[xPos 0.05 btnLen 0.10], ...
        'String',labelStr, ...
        'Callback',callbackStr);
 
%====================================
% Generate the Klein bottle

% Set up the graphics parameters
%set(gcf,'color',[0.7 .7 .7]);
set(figNumber,'color',[0.3 .3 .3]);
colormap(jet);

% Set Klein bottle parameters
n = 12;
a = .2;                         % the diameter of the small tube
c = .6;                         % the diameter of the bulb
t1 = pi/4 : pi/n : 5*pi/4;  	% parameter along the tube
t2 = 5*pi/4 : pi/n : 9*pi/4;  	% angle around the tube
u  = pi/2 : pi/n : 5*pi/2;
[X,Z1] = meshgrid(t1,u);
[Y,Z2] = meshgrid(t2,u);

% The handle
len = sqrt(sin(X).^2 + cos(2*X).^2);
x1 = c*ones(size(X)).*(cos(X).*sin(X) ...
     - 0.5*ones(size(X))+a*sin(Z1).*sin(X)./len);
y1 = a*c*cos(Z1).*ones(size(X));
z1 = ones(size(X)).*cos(X) + a*c*sin(Z1).*cos(2*X)./len;
h=surf(x1,y1,z1,X);
set(h,'edge',[.5 .5 .5]);
set(h,'UserData',X);	% save CData in UserData
hold on;

% The bulb
r = sin(Y) .* cos(Y) - (a + 1/2) * ones(size(Y));
x2 = c * sin(Z2) .* r;
y2 = - c * cos(Z2) .* r;
z2 = ones(size(Y)) .* cos(Y);
h=surf(x2,y2,z2,Y);
set(h,'edge',[.5 .5 .5]);
set(h,'UserData',Y);	% save CData in UserData

view(-37,30);

% Reset the arrow and the nextplot information for this window.
 set(figNumber, ...
     'Nextplot','new', ...
     'Pointer','arrow', ...
     'Visible','on');

watchoff(oldFigNumber);

%====================================
% Half of the bottle

elseif strcmp(action,'half')

    watchon;
    shading interp;
    h = get(gca,'children');

    c = get(h(1),'UserData');
    [row col] = size(c);
    c(1:floor(row/2),:) = NaN*ones(floor(row/2),col);
    set(h(1),'CData',c);
    
    c = get(h(2),'UserData');
    [row col] = size(c);
    c(1:floor(row/2),:) = NaN*ones(floor(row/2),col);
    set(h(2),'CData',c);
    watchoff;

%====================================
% Whole bottle

elseif strcmp(action,'whole')

    watchon;
    shading faceted;
    h = get(gca,'children');
    set(h(1),'CData',get(h(1),'UserData'));
    set(h(2),'CData',get(h(2),'UserData'));
    watchoff;

%====================================
% Info text 

elseif strcmp(action,'info')
    figNumber = gcf;
    figNumber = watchon;
    infoStr = [
    ' A Klein bottle is a nonorientable surface in            '
    ' four-dimensional space. It is formed by                 '
    ' attaching two Mobius strips along their common          '
    ' boundary.                                               '
    '                                                         '
    ' Klein bottles cannot be constructed without             '
    ' intersection in three-space. The figure shown is        '
    ' an example of such a self-intersecting Klein            '
    ' bottle.                                                 '
    '                                                         '
    ' "Spinmap" spins the colormap.                           ' 
    ' "Whole" shows the whole Klein bottle.                   '
    ' "Half" shows half the Klein bottle.                     '
    '                                                         '
    ' File name: xpklein.m                                    '
];
    helpfun('Klein Info',infoStr);
    watchoff(figNumber);

end;		% if strcmp(action, ...
