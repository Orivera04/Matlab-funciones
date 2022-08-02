function biorhythm(birthday)
% BIORHYTHM  Plot your biorhythm for an 8 week period.
%
% BIORHYTHM(birthday)
% The input argument can be a string, a vector, or a datenum.
% Examples:
%    biorhythm('Aug 17, 1939')
%    biorhythm([1939 8 17])
%    biorhythm(fix(now-28))
% You can edit the resulting plot title to change the birthday.
%
% Biorhythms were very popular in the '60's.  You can still find
% many Web sites today that offer to prepare personalized biorhythms,
% or that sell software to compute them.
% Biorhythms are based on the notion that three sinusoidal cycles
% influence our lives.  The physical cycle has a period of 23 days,
% the emotional cycle has a period of 28 days, and the intellectual
% cycle has a period of 33 days.  For any individual, the cycles are
% initialized at birth, as shown by
%   biorhythm(now)

% From "Experiments with MATLAB"
% Cleve Moler
% The MathWorks, Inc.
% See http://www.mathworks.com/moler
% August 1, 2010.  Copyright, 2010.

initialize

if nargin == 0
   t0 = fix(now-28);
else
   t0 = datenum(birthday);
end
t1 = fix(now);

% Eight week time span centered on today.

t = (t1-28):(t1+28);
y = 100*[sin(2*pi*(t-t0)/23)
         sin(2*pi*(t-t0)/28)
         sin(2*pi*(t-t0)/33)];
plot(t,y)

finalize

% ------------------------------------

   function initialize
      clf
      shg
      axes('position',[.10 .30 .80 .50])
   end
   
   function finalize
      line([t1 t1],[-100 100],'color','k')
      line([t1-28 t1+28],[0 0],'color','k')
      set(gca,'xtick',(t1-28):7:(t1+28))
      datetick('x',6,'keeplimits','keepticks')
      bot = text(t1-5,-130,['today: ' datestr(t1,1)]);
      cbs = 'biorhythm(strrep(get(gcbo,''string''),''birthday:'',''''))'; 
      top = uicontrol('style','edit','units','normal', ...
            'position',[.35 .82 .32 .05], ...
            'string',['birthday: ' datestr(t0,1)], ...
            'fontsize',get(bot,'fontsize'), ...
            'callback',cbs);
      axis tight
      leg = legend('Physical','Emotional','Intellectual');
      set(leg,'pos',[.10 .02 .18 .12])
   end

end % biorhythm
