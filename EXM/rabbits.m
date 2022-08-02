function rabbits(handle)
% RABBITS  Fibonacci's rabbit pen.
%   How fast does the population grow?
%   rabbits, with no arguments, initializes the simulation.
%   rabbits(handle) is the callback with each button click.

% Initialize with a blue bunny in the center of the figure.
% Clicking on a blue bunny turns it into a blue rabbit.
% Clicking on a blue rabbit creates a gray bunny and turns the rabbit gray.
% Clicking on a gray bunny or gray rabbit does nothing.
% When all the bunnies and rabbits are gray, count them and turn them all blue.

   % R = structure of rabbit images.
   % pos = history of positions.
   persistent R pos

   if nargin == 0
      % Initialize single blue bunny and uicontrols.
      init_graphics

   else
      % Process a button click.
      switch get(handle,'tag')
         case 'bluebunny'
            % A blue bunny turns into a gray rabbit.
            bluebunny(handle)
         case 'bluerabbit'
            % A blue rabbit creates a gray bunny and turns gray itself.
            bluerabbit(handle)
         case 'graybunny'
            % A gray bunny does nothing.
         case 'grayrabbit'
            % A gray rabbit does nothing.
      end

      % When all are gray, turn them all blue.
      update
      
   end

% ------------------------------

   function init_graphics
      clf reset
      shg

      R = load('rabbits.mat');
      R.graybunny = cat(3,R.bunny,R.bunny,R.bunny); 
      R.grayrabbit = cat(3,R.rabbit,R.rabbit,R.rabbit); 
      R.bluebunny = cat(3,R.bunny,R.bunny,255*ones(size(R.bunny),'uint8'));
      R.bluerabbit = cat(3,R.rabbit,R.rabbit,255*ones(size(R.rabbit),'uint8'));

      f = get(gcf,'position');
      p = .45*f(3:4);
      pos = p;

      % Single bunny
      uicontrol('style','pushbutton','position',[p 80 80], ...
         'background','white','cdata',R.bluebunny,'tag','bluebunny', ...
         'callback','rabbits(gcbo)');

      % Population counter
      uicontrol('style','text','fontsize',12,'fontweight','bold', ...
         'position',[f(3)/2-14 f(4)-40 28 28],'string','1')

      % Auto toggle
      uicontrol('style','toggle','position',[20 20 60 20], ...
         'string','auto','callback',@auto)
   end

% ------------------------------

   function bluebunny(handle)
      % A blue bunny turns into a gray rabbit.
      set(handle,'cdata',R.grayrabbit,'tag','grayrabbit', ...
         'callback','rabbits(gcbo)')
   end

% ------------------------------

   function bluerabbit(handle)
      % A blue rabbit creates a gray bunny and turns gray itself.
      p = find_good_position;
      uicontrol('style','pushbutton','position',[p 80 80], ...
         'background','white','cdata',R.graybunny,'tag','graybunny', ...
         'callback','rabbits(gcbo)');
      set(handle,'cdata',R.grayrabbit,'tag','grayrabbit', ...
         'callback','rabbits(gcbo)');
   end

% ------------------------------

   function p = find_good_position
      % Avoid toggle and population counter.
      f = get(gcf,'position');
      ds = -Inf;
      % Choose best of several random positions.
      for k = 1:20
         p = .80*f(3:4).*rand(1,2);
         % Avoid toggle in lower right hand corner.
         if p(1) < 80 && p(2) < 40
            continue
         end
         % Avoid population counter centered near the top.
         f = get(gcf,'pos');
         if (p(2)+80 > f(4)-40) && (p(1)+80 > f(3)/2-14) ...
            && (p(1) < f(3)/2+14)
            continue
         end
         r = p(ones(size(pos,1),1),:);
         d = min(min(abs(pos-r)'));
         if d > ds
            ds = d;
            ps = p;
         end
      end
      p = ps;
      pos = [pos; p];
   end

% ------------------------------

   function update
      % When all are gray, turn them all blue.
      b = findobj(gcf,'style','pushbutton');
      n = length(b);
      c = get(b,'tag');
      if n == 1
         c = {c};
      end
      % Check for all gray.
      if length(findstr([c{:}],'gray')) == n
         pause(1.0)
         for k = 1:n
            if findstr(c{k},'graybunny')
               set(b(k),'cdata',R.bluebunny,'tag','bluebunny', ...
                  'callback','rabbits(gcbo)')
            else
               set(b(k),'cdata',R.bluerabbit,'tag','bluerabbit', ...
                  'callback','rabbits(gcbo)');
            end
         end
         % Update population counter.
         set(findobj(gcf,'style','text'),'string',n)
      end
   end

% ------------------------------

   function auto(handle,~)
      % Auto toggle callback
      % Complete one month's growth
      set(handle,'enable','off')
      b = [findobj(gcf,'tag','bluebunny')
          findobj(gcf,'tag','bluerabbit')];
      n = length(b);
      b = b(randperm(n));
      for k = 1:n
          rabbits(b(k))
          pause(.1)
      end
      set(handle,'enable','on','value',0)
   end

end % rabbits
