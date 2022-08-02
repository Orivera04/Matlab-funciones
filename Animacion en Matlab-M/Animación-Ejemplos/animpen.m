function animpen(t,th,titl,tim,trac)
%
% animpen(t,th,titl,tim,trac)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function plots theta versus t and animates
% the pendulum motion 
%
% t    - time vector for the solution
% th   - angular deflection values defining the
%        pendulum positions
% titl - a title shown on the graphs graph
% tim  - a time delay between successive steps of
%        the animation. This is used to slow down
%        the animation on fast computers
% trac - 1 if successive positions plotted in the
%        animation are retained on the screen, 0
%        if each image is erased after it is 
%        drawn

if nargin<5, trac=0; end; if nargin<4, tim=.05; end; 
if nargin<3, titl=''; end

% Plot the angular deflection
plot(t,180/pi*th(:,1),'k'), xlabel('time')
ylabel('angular deflection (degrees)'), title(titl)
grid on, shg, disp(' ')
disp('Press return to see the animation'), pause
% print -deps penangle
nt=length(th); z=zeros(nt,1); 
x=[z,sin(th)]; y=[z,-cos(th)];
hold off, close
if trac 
   axis([-1,1,-1,1]), axis square, axis off, hold on
end
for j=1:nt
   X=x(j,:); Y=y(j,:);
   plot(X,Y,'k-',X(2),Y(2),'ko','markersize',12)   
   if ~trac
	  axis([-1,1,-1,1]), axis square, axis off
   end
   title(titl), drawnow, shg
   if tim>0, pause(tim), end
end
% if trac==1, print -deps pentrace,  end
pause(1),hold off    