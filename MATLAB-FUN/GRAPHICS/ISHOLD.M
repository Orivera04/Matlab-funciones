function holdstate = ishold()
%ISHOLD	Return 1 if hold is on.
%	ISHOLD returns 1 if hold is on, and 0 if it is off.
%	When HOLD is ON, the current plot and all axis properties
%	are held so that subsequent graphing commands add to the 
%	existing graph.
%
%	Hold on means the NextPlot property of both figure
%	and axes is set to "add".
%
%	See also HOLD, NEWPLOT, FIGURE, AXES.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

ca = get(gcf,'Children');
ax = 0;
for i=1:length(ca)
   if strcmp(get(ca(i),'type'),'axes')
      ax = 1;
      break;
   end
end
if ax
   ca = gca;
   holdax = strcmp(get(ca,'nextplot'),'add');
else
   ca = [];
   holdax = 0;
end
holdstate = holdax & strcmp(lower(get(gcf,'NextPlot')),'add');
