function membanim(u,x,y,t)
%
% function membanim(u,x,y,t)
% ~~~~~~~~~~~~~~~~~~~~~~~~~
% This function animates the motion of a 
% vibrating membrane
%
% u    array in which component u(i,j,k) is the
%      displacement for y(i),x(j),t(k)
% x,y  arrays of x and y coordinates
% t    vector of time values

% Compute the plot range
if nargin==0; 
  [u,x,y,t]=memrecwv(2,1,1,15.5,1.5,.5,5);
end
xmin=min(x(:)); xmax=max(x(:));
ymin=min(y(:)); ymax=max(y(:));
xmid=(xmin+xmax)/2; ymid=(ymin+ymax)/2;
d=max(xmax-xmin,ymax-ymin)/2; Nt=length(t);
range=[xmid-d,xmid+d,ymid-d,ymid+d,...
       3*min(u(:)),3*max(u(:))];

while 1 % Show the animation repeatedly
  disp(' '), disp('Press return for animation')
  dumy=input('or enter 0 to stop > ? ','s');
  if ~isempty(dumy)
    disp(' '), disp('All done'), break
  end

  % Plot positions for successive times
  for j=1:Nt
    surf(x,y,u(:,:,j)), axis(range)
    xlabel('x axis'), ylabel('y axis')
    zlabel('u axis'), titl=sprintf(...
    'MEMBRANE POSITION AT T=%5.2f',t(j));
    title(titl), colormap([1 1 1])
    colormap([127/255 1 212/255])
    % axis off
    drawnow, shg, pause(.1)
  end
end