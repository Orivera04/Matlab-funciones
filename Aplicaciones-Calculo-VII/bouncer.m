function bouncer
% BOUNCER  Simple illustration of gravity.

   [z0,h] = initialize_bouncer;
   g = 9.8;        % Gravity
   c = 0.75;       % Elasticity
   delta = 0.005;  % Time step
   v0 = 21;        % Initial velocity
   while v0 >= 1
      v = v0;
      z = z0;
      while all(z >= 0)
         set(h,'zdata',z)
         drawnow
         v = v - delta*g;
         z = z + delta*v;
      end
      v0 = c*v0;
   end
   finalize_bouncer

end

%-----------------------------------------------

function [z,h] = initialize_bouncer
% INITIALIZE_BOUNCER
%  The z-coordinates and the handle for a surf plot of a sphere.
   clf
   shg
   set(gcf,'color','white','numbertitle','off','name','  Bounce')
   axes('position',[0 0 1 1])
   [x,y,z] = sphere(20);
   z = z + 1;
   h = surf(x,y,z);
   colormap copper
   shading interp
   axis([-12.5 12.5 -12.5 12.5 0 25.0])
   axis square off
   view(90,0)
   uicontrol('string','TOSS','style','pushbutton', ...
      'units','normal','position',[.10 .05 .12 .05], ...
      'background','white','fontweight','normal', ...
      'enable','off','callback','bouncer')
   drawnow
end

%-----------------------------------------------

function finalize_bouncer
   set(findobj('string','TOSS'),'fontweight','bold','enable','on')
end
