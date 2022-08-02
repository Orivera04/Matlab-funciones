function [hAxes,hLine] = layerplot(x1,y1,x2,y2,Labels,Range,Legends)
%layerplot(x1,y1,x2,y2)
%   A plot function more powerful thant plotyy.
%
%layerplot(x1,y1,x2,y2,Labels)
%   Labels must be a cell array with 3 elements describing the xLabel,
%     y1Label and y2Label respectively.
%     eg. Labels = {'Time (t)','sin(t)','cos(t)'};
%
%layerplot(x1,y1,x2,y2,Labels,Range)
%   Range can be a 1-by-2 matrix whose elements are the minimum and
%     maximum of x-axis repectively. eg. Range = [0,1];
%   Range can also be a 3-by-2 matrix. The elements in the first row are
%     the minimum and maximum of x repectively. The second and the third
%     row are for y1 and y2.  eg. Range = [0,1; -1,3; 2,7];
%
%layerplot(x1,y1,x2,y2,Labels,Range,Legends)
%   Legends is cell array with 2 elements which are the legend texts.
%     eg. Legends = {'y = sin(x)','y = cos(x)'};
%
%[hAxes,hLine] = layerplot(x1,y1,x2,y2,Labels,Range,Legends)
%   hAxes is the graphics handle vector for the two axes
%     who is overlapped with each other.
%   hLine is the graphics handle vector for the two lines.
%
%For an example:
%   t = linspace(0,2*pi,500); y1 = sin(t); y2 = 100*cos(t);
%   layerplot(t,y1,t,y2,{'Time (t)','sin(t)','100*cos(t)'},...
%      [0,2*pi; -2,2; -200,200],{'y = sin(t)','y = 100*cos(t)'});
%
%Author: Gao zhipeng;   2006-05-24
%See also: plotyy, myplot

figure('Color',[1 1 1]);
hAxes(1) = axes;
hLine(1) = line(x1,y1);
set(hAxes(1),'YColor','b','Box','on');
hAxes(2) = axes('Position',get(hAxes(1),'Position'),'YColor','r');
hLine(2) = line(x2,y2,'Color','r');
set(hAxes(2),'Xlim',get(hAxes(1),'Xlim'),'YAxisLocation','right','Color','none','XTickLabel',[],'Layer','top');
if nargin >= 5
    xlabel(hAxes(1),Labels{1},'Color','k');
    ylabel(hAxes(1),Labels{2},'Color','b');
    ylabel(hAxes(2),Labels{3},'Color','r');
end
if nargin >= 6
    if(length(Range(:))==2)
        set(hAxes,'Xlim',Range);
    else
        set(hAxes,'Xlim',Range(1,:));
        set(hAxes(1),'Ylim',Range(2,:));
        set(hAxes(2),'Ylim',Range(3,:));
    end
end
if nargin ==7, legend(hLine,Legends{:}); end;
