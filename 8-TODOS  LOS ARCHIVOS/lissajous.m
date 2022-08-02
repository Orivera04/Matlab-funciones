function lissajous(a,b)
% LISSAJOUS  2D and 3D Lissajous curves.
% x = sin(t), y = sin(a*t) or 
% x = sin(t), y = sin(a*t), z = sin(b*t).
% Usage:
%    lissajous(a,b)
%    lissajous('a','b'), to retain symbolic representation.
%    lissajous, to open gui with default values.
% Enter rational and irrational values of a and b in the edit boxes.
% Enter b = 0 for 2D curves.
%    eg:
%    a = 3/2 , b = 5/4
%    a = 2^(7/12), b = 2^(4/12)
%    a = 5/4 , b = 0
%
% See Wikipedia article: http://en.wikipedia.org/wiki/Lissajous_curve 

   % Default value of the parameters.

   if nargin == 0
      a = '3/2';
      b = '5/4';
   elseif nargin == 1
      b = 0;
   end

   % Retain both character and numeric representation of the parameters.

   if ischar(a)
      sa = a;
      a = str2num(a);
   else
      sa = rats(a);
   end
   if ischar(b)
      sb = b;
      b = str2num(b);
   else
      sb = rats(b);
   end

   % Initialize

   loop = true;
   t = 0;
   dt = pi/1024;
   initialize_graphics;

   % Run the loop until the 'X' toggle is pushed.

   while loop
      t = t + dt;
      x = sin(t);
      y = sin(a*t);
      z = sin(b*t);
      plotdot(x,y,z)
   end

   close

% ------------------------------------------------
   
   function initialize_graphics
      clf
      shg
      set(gcf,'color','white')
      initialize_plot

      uicontrol('string','a = ','style','edit','units','normalized', ...
         'position',[.25,.05,.05,.05],'background','white')
      uicontrol('tag','a','style','edit','units','normalized', ...
         'position',[.30,.05,.20,.05],'background','white', ...
         'string',sa,'callback',@abcallback);

      uicontrol('string','b = ','style','edit','units','normalized', ...
         'position',[.55,.05,.05,.05],'background','white')
      uicontrol('tag','b','style','edit','units','normalized', ...
         'position',[.60,.05,.20,.05],'background','white', ...
         'string',sb,'callback',@abcallback);

      uicontrol('string','line','style','toggle','units','normalized', ...
         'tag','mode','position',[.06,.48,.05,.05],'background','white', ...
         'foreground','blue','callback',@modecallback);

      uicontrol('string','X','style','toggle','units','normalized', ...
         'position',[.95,.95,.04,.04],'background','white', ...
         'callback',@xcallback);
   end

% ------------------------------------------------

   function initialize_plot
      mode = get(findobj('tag','mode'),'value');
      if isempty(mode) || mode==0
         plot3(0,0,0,'.','erasemode','none')
      else
         plot3(0,0,0,'.','markersize',24,'color',[0 2/3 0])
      end
      axis([-1 1 -1 1 -1 1])
      set(gca,'xtick',[],'ytick',[],'ztick',[])
      axis square
      box on
      switch b
         case 0
            view(2)
            title('sin(t), sin(a*t)')
         case 1
            view(3)
            title('sin(t), sin(a*t), sin(b*t)')
      end
      t = 0;
   end

% ------------------------------------------------
   
   function plotdot(x,y,z)
      % Move dot on plot.
      set(get(gca,'child'),'xdata',x,'ydata',y,'zdata',z)
      drawnow
   end

% ------------------------------------------------

   function abcallback(h,~)
      % Callback for ab controls.
      switch get(h,'tag')
         case 'a', a = str2num(get(h,'string'));
         case 'b', b = str2num(get(h,'string'));
      end
      initialize_plot
   end

% ------------------------------------------------

   function modecallback(h,~)
      % Callback for mode control.
      switch get(h,'value')
         case 0, set(h,'string','line','foreground','blue')
                 dt = dt/4;  % Slower
         case 1, set(h,'string','dot','foreground',[0 2/3 0])
                 dt = 4*dt;  % Faster
      end
      initialize_plot
   end

% ------------------------------------------------

   function xcallback(~,~)
      % Callback for X control.
      loop = false;
   end

end % Lissajous
