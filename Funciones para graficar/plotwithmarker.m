function plotwithmarker(inx, varargin)
% Usage: plotwithmarker(y, ...)
%        plotwithmarker(x, y, ...)
%
% Plots signal with markers.
% Common problem of using markers in Matlab arise when you try to plot long 
% vector. Cause Matlab plots marker for each datapoint, they are overlapped 
% and practically has no use.
% This function solves this problem and plots only 20..40 markers per graph.
% By default, first graph has no markers. 
%
% You can adjust marker symbols and number of markers per graph 
% by editing source code.
%
% Created by: P.Berkman, 28 February, 2001
% tested in Matlab 5

% FUTURE PLANS: its' good idea to shift position of markers from one graph to another...

% Default values, you can adjust it for you needs:
marker_symbol=['o','*','+','.','x','s','d','^','v','<','>','p','h'];
markers_per_screen=20; % actual number of markers can vary depends on step,-
                       % step=length(inx)/markers_per_screen
                       % step could be only integer

if nargin<1
    error('Invalid number of input arguments');
elseif nargin<2
    % one argument
    [y_marker,x]=marker(inx,markers_per_screen);
    plot(inx);
elseif length(inx)~=length(varargin{1})
    % one argument (y values only) with special attributes for plot
    [y_marker,x]=marker(inx,markers_per_screen);
    plot(inx, varargin{:});
else
    % x and y specified and probably some attributes for plot
    [y_marker,x]=marker(inx,varargin{1},markers_per_screen);    
    plot(inx,varargin{1},varargin{2:end});
end

prevholdstatus=ishold;
if prevholdstatus==0
    hold on
end

if size(y_marker,2)-1>size(marker_symbol,2)
    error('Too much graphs on screen - not enough marker symbols');
end

% now plot the markers itself
for i=2:size(y_marker,2)
    plot(x,y_marker(:,i),['k' marker_symbol(i-1)]);
end

% if you want to plot markers for first graph to, use this code:
% for i=1:size(y_marker,2)
%     plot(x,y_marker(:,i),['k' marker_symbol(i)]);
% end

if prevholdstatus==0
    hold off
end

% --------------------------- SUB - FUNCTIONS ----------------------------------------

function [out,x]=marker(inx, iny, markers_per_screen)
% Usage: [out_y,out_x]=marker( x,y [,markers_per_screen] )
%        [out_y,out_x]=marker( y [,markers_per_screen] )
% Returns position of markers
% Could be used separately from <plotwithmarker.m>

if nargin<2
    iny=inx;
    inx=1:length(iny);
    markers_per_screen=20; %default
elseif nargin==2
    if length(iny)~=1
        markers_per_screen=20;
    else
        markers_per_screen=iny;
        iny=inx;
        inx=1:length(iny);
    end
end

step=floor(length(inx)/markers_per_screen);
if step<1
    step=1;
end

out=iny(1:step:length(iny),:);
if nargout>1
    x=inx(1:step:length(inx))';
end

