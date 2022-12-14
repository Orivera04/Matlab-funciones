function initialize(this,Axes)
%INITIALIZE  Initialization for @FreqPeakRespView class

%  Author(s): John Glass
%  Copyright 1986-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $  $Date: 2004/04/11 00:25:25 $

[s1,s2] = size(Axes(:,:,1));
VLines = zeros([s1 s2]);
HLines = zeros([s1 s2]);
Points = zeros([s1 s2]);

for ct=1:s1*s2   
   % Plot verticle lines
   VLines(ct) = line([NaN,NaN],[NaN,NaN],[-10,-10],...
      'Parent',Axes(ct),...
      'Visible','off',...
      'LineStyle','-.',...
      'Selected','off',...
      'XlimInclude','off', 'YlimInclude','off',...
      'HandleVisibility','off','HitTest','off',...
      'Color','k');
   %% Plot horizontal lines
   HLines(ct) = line([NaN,NaN],[NaN,NaN],[-10,-10],...
      'Parent',Axes(ct),...
      'Visible','off',...
      'LineStyle','-.',...
      'Selected','off',...
      'XlimInclude','off', 'YlimInclude','off',...
      'HandleVisibility','off','HitTest','off',...
      'Color','k');       
   %% Plot characteristic points
   Points(ct) = line(NaN,NaN,[5],...
      'Parent',Axes(ct),...
      'XlimInclude','off',...
      'YlimInclude','off',...
      'Visible','off',...
      'Marker','o',...
      'MarkerSize',6);
end

this.VLines = handle(VLines);
this.HLines = handle(HLines);
this.Points = handle(Points);
this.PointTips = cell([s1 s2]);