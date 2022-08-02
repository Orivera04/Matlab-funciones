function plotmotn(x,y,titl,isave)
%
% plotmotn(x,y,titl,isave)
% ~~~~~~~~~~~~~~~~~~~~
% This function plots the cable time 
% history described by coordinate values 
% stored in the rows of matrices x and y.
%
% x,y   - matrices having successive rows 
%         which describe position 
%         configurations for the cable
% titl  - a title shown on the plots
% isave - parameter controlling the form 
%         of output. When isave is not input, 
%         only one position at a time is shown
%         in rapid succession to animate the
%         motion. If isave is given a value,
%         then successive are all shown at
%         once to illustrate a kinematic 
%         trace of the motion history.
%
% User m functions called:  none
%----------------------------------------------

% Set a square window to contain all 
% possible positions
[nt,n]=size(x); 
if nargin==4, save =1; else, save=0; end
xmin=min(x(:)); xmax=max(x(:));
ymin=min(y(:)); ymax=max(y(:)); 
w=max(xmax-xmin,ymax-ymin)/2;
xmd=(xmin+xmax)/2; ymd=(ymin+ymax)/2;  
hold off; clf; axis('normal'); axis('equal'); 
range=[xmd-w,xmd+w,ymd-w,ymd+w];
title(titl)
xlabel('x axis'); ylabel('y axis')
if save==0
  for j=1:nt
    xj=x(j,:); yj=y(j,:);
    plot(xj,yj,'-k',xj,yj,'ok');
    axis(range), axis off
    title(titl)
    figure(gcf), drawnow, pause(.1)
  end
  pause(2)
else
  hold off; close
  for j=1:nt
    xj=x(j,:); yj=y(j,:);
    plot(xj,yj,'-k',xj,yj,'ok');
    axis(range), axis off, hold on
  end
  title(titl)
  figure(gcf), drawnow, hold off, pause(2)
end

% Save plot history for subsequent printing 
% print -deps plotmotn