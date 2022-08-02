function graymon
%GRAYMON Graphics figure defaults set for gray-scale monitor.
%	GRAYMON changes the default graphics properties to produce
%	legible displays for gray-scale monitors.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

ch = get(0,'children');
if isempty(ch)
   fig = 0;
else
   fig = [gcf 0];
end
co = [.75 .5 .25]'*ones(1,3);
set(fig,'defaultaxescolororder',co)
