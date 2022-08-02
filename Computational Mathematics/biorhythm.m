function biorhythm(birthday)
% BIORHYTHM  Plot of your biorhythm for an 8 week period.
%
% BIORHYTHM('birthday')
% Example:
%   biorhythm('Aug 17, 1939')
%   biorhythm([1939 8 17])
%
% Biorhythms were very popular in the '60's.  You can still find
% many Web sites today that offer to prepare personalized biorhythms,
% or that sell software to compute them.
% Biorhythms are based on the notion that three sinusoidal cycles
% influence our lives.  The physical cycle has a period of 23 days,
% the emotional cycle has a period of 28 days, and the intellectual
% cycle has a period of 33 days.  For any individual, the cycles are
% initialized at birth.
%
% From "Experiments with MATLAB"
% Cleve Moler
% The MathWorks, Inc.
% See http://www.mathworks.com/moler
% March 23, 2008.  Copyright 2008.

if nargin == 0
   birthday = datestr(708434+fix(25056*rand));
end
t0 = datenum(birthday);
t1 = fix(now);
t = (t1-28):1:(t1+28);
y = 100*[sin(2*pi*(t-t0)/23)
         sin(2*pi*(t-t0)/28)
         sin(2*pi*(t-t0)/33)];

clf
shg
axes('position',[.10 .30 .80 .50])
plot(t,y)

line([t1 t1],[-100 100],'color','k')
set(gca,'xtick',(t1-28):7:(t1+28))
datetick('x',6,'keeplimits','keepticks')
text(t1-3,-130,datestr(t1,1))
title(['birthday: ' datestr(birthday,1)])
axis tight
l1 = legend('Physical','Emotional','Intellectual');
set(l1,'pos',[.10 .02 .18 .12])
