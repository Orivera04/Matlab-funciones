function o = orient(or)
%ORIENT	Hardcopy paper orientation.
%   	ORIENT LANDSCAPE causes subsquent PRINT operations from the current
%   	figure window to generate output in full-page landscape orientation
%   	on the paper.
%   	ORIENT PORTRAIT returns to the default PORTRAIT orientation with
%   	the figure window occupying a rectangle with aspect ration 4/3 in 
%   	the middle of the page.
%   	ORIENT TALL causes the figure window to map to the whole page
%   	in portrait orientation.
%   	ORIENT, by itself, returns a string containing the current paper
%   	orientation, either PORTRAIT, LANDSCAPE or TALL.
%
%   	ORIENT is an M-file that sets the PaperOrientation and PaperPosition
%   	properties of the current figure window.
%
%	See also PRINT.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

if nargin == 0
    o = lower(get(gcf,'PaperOrientation'));
    if strcmp(o,'portrait')
       pp = get(gcf,'PaperPosition');
       ps = get(gcf,'PaperSize');
       if all(pp([3,4]) == ps) & ps(1) < ps(2)
          o = 'tall';
       end
    end
    return
end

do = lower(get(gcf,'DefaultFigurePaperOrientation'));
ps = get(gcf,'papertype');
if strcmp(ps,'a4letter')
   frectpin = [.25 2.5 7.73 5.8];
   drect = [.25 2.5 7.73 5.8];
else
   frectpin = [.25 2.5 8 6];
   drect = get(0,'DefaultFigurePaperPosition');
end
or = lower(or);
if strcmp(or,'portrait')
	set(gcf,'PaperOrientation','portrait')
	if strcmp(do,'portrait')
		set(gcf,'PaperPosition',drect)
	else
		un = get(gcf,'PaperUnits');
		set(gcf,'PaperUnits','inches');
		set(gcf,'PaperPosition',frectpin);
		set(gcf,'PaperUnits',un);
	end
elseif strcmp(or,'landscape')
	set(gcf,'PaperOrientation',or);
	if strcmp(do,'landscape')
		set(gcf,'PaperPosition',drect)
	else
		un = get(gcf,'PaperUnits');
		set(gcf,'PaperUnits','inches');
		ps = get(gcf,'PaperSize');
		rect = [0 0 ps];
		set(gcf,'PaperPosition',rect);
		set(gcf,'PaperUnits',un);
	end
elseif strcmp(or,'tall')
	set(gcf,'PaperOrientation','portrait')
	un = get(gcf,'PaperUnits');
	set(gcf,'PaperUnits','inches');
	ps = get(gcf,'PaperSize');
	rect = [0 0 ps];
	set(gcf,'PaperPosition',rect);
	set(gcf,'PaperUnits',un);
else
	error('Unknown command option.')
end
