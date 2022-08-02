function canimate(y,u,t,tmin,tmax,norub)
%
% canimate(y,u,t,tmin,tmax,norub)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function draws an animated plot of 
% data values stored in array u. The 
% different columns of u correspond to position 
% values in vector y. The successive rows of u 
% correspond to different times. Parameter 
% tpause controls the speed of the animation.
%
% u         - matrix of values for which 
%             animated plots of u versus y 
%             are required
% y         - spatial positions for different 
%             columns of u
% t         - time vector at which positions 
%             are known
% tmin,tmax - time limits for graphing of the 
%             solution
% norub     - parameter which makes all 
%             position images remain on the 
%             screen. Only one image at a 
%             time shows if norub is left out. 
%             A new cable position appears each 
%             time the user presses any key
%
% User m functions called:  none.
%----------------------------------------------

% If norub is input, 
%   all images are left on the screen
if nargin < 6
  rubout = 1;
else
  rubout = 0;
end

% Determine window limits
umin=min(u(:)); umax=max(u(:)); udif=umax-umin;
uavg=.5*(umin+umax); 
ymin=min(y); ymax=max(y); ydif=ymax-ymin;
yavg=.5*(ymin+ymax); 
ywmin=yavg-.55*ydif; ywmax=yavg+.55*ydif;
uwmin=uavg-.55*udif; uwmax=uavg+.55*udif;
n1=sum(t<=tmin); n2=sum(t<=tmax); 
t=t(n1:n2); u=u(n1:n2,:);
u=fliplr (u); [ntime,nxpts]=size(u);

hold off; cla; ey=0; eu=0; axis('square');
axis([uwmin,uwmax,ywmin,ywmax]);
axis off; hold on;
title('Trace of Linearized Cable Motion');

% Plot successive positions
for j=1:ntime
  ut=u(j,:); plot(ut,y,'-'); 
  figure(gcf); pause(.5);
 
  % Erase image before next one appears
  if rubout & j < ntime, cla, end
end