% plt5.m
% This is a simple script which creates a plot containing 5 traces.
% Run this script as you review the help documentation
%
% Note how the five y-vectors are combined to form a single plt argument.
% Note the use of the 'Xlim' and 'Ylim' to control the initial axis limits.
% Note the use of the disable trace argument to turn off the last trace (initially).
% Note the use of 'LabelYR' to assign trace 5 to the right hand axis.

t  = (0:399)/400;
y1 = 5 - 1.4*exp(-2*t).*sin(20*t);
y2 = repmat([1 0 1 0 1 0]+3.5,100,1); y2 = y2(:)';
f = (0:.15:25)-12.5; f = sin(f)./f;
y2 = filter(f,sum(f),y2); y2(1:200) = [];
y3 = 3 * t .* cos(5*pi*(1-t).^3) + 3;
y4 = 2.2 - 2*exp(-1.4*t).*sin(10*pi*t.^5);
y5 = humps(t);
t = (t+.08) * 1e-5;;
plt(t,[y1; y2; y3; y4; y5],'DisTrace',[0 0 0 0 1],...
   'Xlim',t([1 end]),'Ylim',[1.1 6],...
   'LabelX','seconds','LabelYR','Humps function');
