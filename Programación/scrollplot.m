function scrollplot(dx,x,y)
% function scrollplot(dx,x,y)
% dx: size of window
% x: e.g. time
% y: e.g. signal
% Description: Advanced scrollplot with dynamic range of time (x) axis
%
% Original scrollplotdemo modified by Wolfgang Stiegmaier
% m0199stwo@edu.fh-kaernten.ac.at
%
% Example:
% x=0:1e-2:2*pi;
% y=sin(x);
% plot(x(300:629),y(300:629))
% scrollplot(3,x(300:629),y(300:629))
%
% Original message
% :Created by Steven Lord, slord@mathworks.com
% :Uploaded to MATLAB Central
% :http://www.mathworks.com/matlabcentral
% :7 May 2002
% :Permission is granted to adapt this code for your own use.
% :However, if it is reposted this message must be intact.

% get current axes
a=gca;
% This avoids flickering when updating the axis
set(gcf,'doublebuffer','on');
% Set appropriate axis limits and settings
set(a,'xlim',[0 dx]);
%set(a,'ylim',[min(y) max(y)]);

% Generate constants for use in uicontrol initialization
pos=get(a,'position');
xmax=max(x);
xmin=min(x);

% This will create a slider which is just underneath the axis
% but still leaves room for the axis labels above the slider
Newpos=[pos(1) pos(2)-0.1 pos(3) 0.05];

% Setting up callback string to modify XLim of axis (gca)
% based on the position of the slider (gcbo)
S=['set(gca,''xlim'',get(gcbo,''value'')+[0 ' num2str(dx) '])'];


% Creating Uicontrol with initial value of the minimum of x
h=uicontrol('style','slider',...
    'units','normalized','position',Newpos,...
    'callback',S,'min',xmin,'max',xmax-dx,'value',xmin);
%initialize postion of plot
set(gca,'xlim',[xmin xmin+dx]);

