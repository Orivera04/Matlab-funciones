function brownian3(n)
% BROWNIAN3  3-D Brownian motion
%     Brownian3(n) has n particles.
%     Default n = 50 .
%     Graphics user interface similar to NBODY.

   if nargin < 1, n = 50; end
   repeat = true;
   while repeat

      % P = n-by-3 array of position coordinates
      % H = graphics and user interface handles.

      P = zeros(n,3);
      H = initialize_graphics(P);
   
      while ~get(H.stop,'value')
   
         % Obtain step size from slider.
         delta = get(H.speed,'value');
   
         % Normally distributed random velocities.
         V = randn(n,3);
   
         % Update positions.
         P = P + delta*V;
   
         update_plot(P,H);

      end
      repeat = finalize_graphics;
   end
   close
end 

% ------------------------------------------------------------

function H = initialize_graphics(P)
% Initialize graphics and user interface controls

   clf reset
   set(gcf,'numbertitle','off','name',' Brownian')
   n = size(P,1);
   color = hsv(n);
   dotsize = 18;
   for i = 1:n
      H.particles(i) = line(P(i,1),P(i,2),P(i,3),'color',color(i,:), ...
         'marker','.','markersize',dotsize);
   end
   s = 20;
   axis([-s s -s s -s s])
   axis square
   box on

   H.speed = uicontrol('style','slider','min',0,'value',1/8,'max',1/4, ...
      'units','normal','position',[.02 .02 .30 .04],'sliderstep',[1/80 1/40]);
   H.stop = uicontrol('string','stop','style','toggle', ...
     'units','normal','position',[.90 .02 .08 .04]);

   uicontrol('string','trace','style','toggle','units','normal', ...
      'position',[.34 .02 .06 .04],'callback','tracer');
   uicontrol('string','in','style','pushbutton','units','normal', ...
      'position',[.42 .02 .06 .04],'callback','zoomer(1/sqrt(2))')
   uicontrol('string','out','style','pushbutton','units','normal', ...
      'position',[.50 .02 .06 .04],'callback','zoomer(sqrt(2))')
   uicontrol('string','x','style','pushbutton','units','normal', ...
      'position',[.58 .02 .06 .04],'callback','view(0,0)')
   uicontrol('string','y','style','pushbutton','units','normal', ...
      'position',[.66 .02 .06 .04],'callback','view(90,0)')
   uicontrol('string','z','style','pushbutton','units','normal', ...
      'position',[.74 .02 .06 .04],'callback','view(0,90)')
   uicontrol('string','3d','style','pushbutton','units','normal', ...
      'position',[.82 .02 .06 .04],'callback','view(-37.5,30)')
   drawnow
end

% ------------------------------------------------------------

function tracer
% Callback for trace button
   particles = flipud(findobj('type','line'));
   if get(gcbo,'value')
      set(particles,'erasemode','none','markersize',4)
   else
      set(particles,'erasemode','normal','markersize',18)
   end
end

% ------------------------------------------------------------

function zoomer(zoom)
% Callback for in and out buttons
   [az,el] = view;
   view(3);
   axis(zoom*axis);
   view(az,el);
   s = findobj('style','slider');
   set(s,'max',zoom*get(s,'max'), ...
      'value',zoom*get(s,'value'));
end

% ------------------------------------------------------------

function update_plot(P,H)
   n = size(P,1);
   for i = 1:n
      set(H.particles(i),'xdata',P(i,1),'ydata',P(i,2),'zdata',P(i,3))
   end
   drawnow
end

% ------------------------------------------------------------

function repeat = finalize_graphics
   delete(findobj('type','uicontrol'))
   uicontrol('string','close','style','pushbutton', ...
     'units','normal','position',[.90 .02 .08 .04]);
   repeat = uicontrol('string','repeat','style','toggle', ...
     'units','normal','position',[.80 .02 .08 .04]);
   waitforbuttonpress
   pause(0.3)
   repeat = get(repeat,'value');
end
