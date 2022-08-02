function beamanim(x,u,tpause,titl,xlabl,ylabl)
%
% beamanim(x,u,tpause,titl,xlabl,ylabl)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function draws an animated plot of data 
% values stored in array u.  The different 
% columns of u correspond to position values 
% in vector x.  The successive rows of u 
% correspond to different times. Parameter 
% tpause controls the speed of animation.
%
%  u      - matrix of values to animate plots 
%           of u versus x
%  x      - spatial positions for different 
%           columns of u
%  tpause - clock seconds between output of 
%           frames. The default is .1 secs 
%           when tpause is left out. When 
%           tpause=0, a new frame appears 
%           when the user presses any key.
%  titl   - graph title
%  xlabl  - label for horizontal axis
%  ylabl  - label for vertical axis
%
% User m functions called:  none
%----------------------------------------------
 
if nargin<6, ylabl=''; end; 
if nargin<5, xlabl=''; end
if nargin<4, titl=''; end; 
if nargin<3, tpause=.1; end;

[ntime,nxpts]=size(u); 
umin=min(u(:)); umax=max(u(:));
udif=umax-umin; uavg=.5*(umin+umax); 
xmin=min(x); xmax=max(x); 
xdif=xmax-xmin; xavg=.5*(xmin+xmax);
xwmin=xavg-.55*xdif; xwmax=xavg+.55*xdif;
uwmin=uavg-.55*udif; uwmax=uavg+.55*udif; clf;
axis([xwmin,xwmax,uwmin,uwmax]); title(titl);
xlabel(xlabl); ylabel(ylabl); hold on;

for j=1:ntime
  ut=u(j,:); 
  plot(x,ut,'-'); axis('off'); figure(gcf);
  if tpause==0 
    pause; 
  else 
    pause(tpause); 
  end
  if j==ntime, break, else, cla; end
end
% print -deps cntltrac
hold off; clf;