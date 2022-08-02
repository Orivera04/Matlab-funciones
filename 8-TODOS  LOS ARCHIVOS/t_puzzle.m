function t_puzzle(action)
% T_PUZZLE  The T puzzle.
% Rearrange the four pieces to form a T, an arrow, or a rhombus.
% Click on the subplot to cycle through the puzzle shapes.
% Click near the center of one of the four pieces to drag it.
% Click near a vertex of a piece to rotate it.
% Right click or control click on a piece to change its orientation.
% Read the code to see additional features.

% Generate playing pieces and puzzle shapes.
T = puzzle_pieces;

if nargin == 0
   action = 'init';
end
switch action

   case 'init'

      init_plot(T);
      init_subplot(T);
      init_buttons

   case 'down'

      ax = get(gcf,'userdata');
      if gca == ax(1)
         select_piece;
      else
         cycle_subplot(T)
      end

   case 'motion'

      drag_or_rotate

   case 'up'

      snap

end

% ------------------------

% Guide to userdata:
%   figure userdata = ax = vector of handles to the two axes.
%   ax(1) userdata = hit = handle of selected piece, or empty.
%   ax(2) userdata = shape = index of current puzzle shape.

% ------------------------

function T = puzzle_pieces
   % Four playing pieces and three puzzle shapes.
   % Use complex coordinates.

   r = sqrt(2);
   T{1} = [0 1 1 0 0] + ...
          [0 0 2 3 0]*i - (2+i);
   T{2} = [0 1 1 0 0] + ...
          [0 0 2-r 3-r 0]*i + (1+i/4);
   T{3} = [0 1 0 0] + ...
          [0 0 1 0]*i + (1-i);
   T{4} = [0 r/2 1 1 0 0] + ...
          [0 r/2 r-1 2*r-1 2*r 0]*i - (1/2+i);
   T{5} = [0 2 2-r 2-r 1-r 1-r -2 0 0 -1 1-r 1-r 1-r 2-r] + ...
          [2 0 0 -2 -2 0 0 2 1 1 1 0 1 0]*i;
   T{6} = [1 3 0 -2 1 1 -1 2-r 2-r 2-r 3-r] + ...
          [1 -1 -1 1 1 0 0 0 -1 0 -1 ]*i - 1/2;
   T{7} = [2 2 1 1 0 0 -1 -1 2 0 2 2-r 1-r] + ...
          [2 1 1 -2 -2 1 1 2 2 0 2 2 1]*i - 1/2;

% ------------------------

function drag_or_rotate
   % Button motion, either drag or rotate a piece.
   % Use complex arithmetic.
   
   point = get(gca,'currentpoint');
   v = point(1,1) + point(1,2)*i;
   hit = get(gca,'userdata');
   if ~isempty(hit) && ishandle(hit) && hit ~= 1
      u = get(hit,'xdata') + get(hit,'ydata')*i;
      z = get(hit,'userdata');
      % Check if closer to center or vertex.
      w  = mean(u(1:end-1));
      if abs(w-v) < min(abs(u-v))
         % Drag
         u = u - (z - v);
      else
         % Rotate about the center by an integer
         % multiple of pi/20, which is 9 degrees.
         dtheta = pi/20;
         theta = angle(v-w) - angle(z-w);
         theta = round(theta/dtheta)*dtheta;
         omega = exp(i*theta);
         u = omega*(u-w) + w;
         v = omega*(z-w) + w;
      end
      set(hit,'xdata',real(u),'ydata',imag(u))
      set(hit,'userdata',v);
   end

% ------------------------

function init_plot(T)
   % Initialize primary plot.
   clf
   shg
   set(gcf,'numbertitle','off','menubar','none','name','T-puzzle')
   ax(1) = axes('pos',[0 0 1 1],'color',get(gcf,'color'), ...
      'xlim',[-4 4],'ylim',[-3 3],'userdata',[]);
   hold on
   axis off
   bluegreen = [0 1/2 1/2];
   for k = 1:4
      fill(real(T{k}),imag(T{k}),bluegreen, ...
         'markeredgecolor','black','linewidth',2)
   end
   set(gcf,'userdata',ax);

% ------------------------

function init_subplot(T)
   % Initialize puzzle shapes subplot.
   ax = get(gcf,'userdata');
   ax(2) = axes('units','normal','position',[.02 .02 .24 .24]);
   shape = 3;
   t = T{shape+4};
   e = max(find(t == t(1),2));
   buttoncolor = [.8314 .8157 .7843];
   bluegreen = [0 1/2 1/2];
   fill(real(t(1:e)),imag(t(1:e)),bluegreen, ...
      'markeredgecolor','black','linewidth',1)
   set(ax(2),'xtick',[],'ytick',[],'xlim',[-4 4],'ylim',[-3 3], ...
      'color',buttoncolor,'userdata',shape);
   set(gcf,'userdata',ax);

% ------------------------

function init_buttons
   % Initialize buttons and callbacks.
   ax = get(gcf,'userdata');
   axis(ax(1));
   set(gcf,'windowbuttondownfcn','t_puzzle(''down'')', ...
           'windowbuttonmotionfcn','t_puzzle(''motion'')', ...
           'windowbuttonupfcn','t_puzzle(''up'')')
   uicontrol('units','normal','position',[.83 .12 .12 .05],'style','toggle', ...
      'callback','t_puzzle(''init'')','string','reset')
   uicontrol('units','normal','position',[.83 .06 .12 .05],'style','push', ...
      'callback','close(gcf)','string','exit')

% ------------------------

function select_piece;
   % Select a piece and remember it in ax(1) userdata.
   point = get(gca,'currentpoint');
   z = point(1,1) + point(1,2)*i;
   delete(findobj(gca,'type','line'))
   h = flipud(get(gca,'children'));
   h = h(1:4);
   hit  = [];
   for k = 1:length(h)
      x = get(h(k),'xdata');
      y = get(h(k),'ydata');
      if inregion(real(z),imag(z),x,y)
         hit = h(k);
         set(hit,'userdata',z)
         break
      end
   end
   set(gca,'userdata',hit)

   % Right click reflects piece about center horizontally.

   if ~isempty(hit) && isequal(get(gcf,'selectiontype'),'alt')
      x = 2*mean(x(1:end-1))-x;
      set(hit,'xdata',x)
   end

% ------------------------

function cycle_subplot(T)
   % Cycle through puzzle shapes in subplot.
   ax = get(gcf,'userdata');
   shape = get(ax(2),'userdata');
   shape = mod(shape,3)+1;
   t = T{shape+4};
   e = max(find(t == t(1),2));
   f = get(ax(2),'child');
   set(f,'xdata',real(t(1:e)),'ydata',imag(t(1:e)))
   set(ax(1),'userdata',[])
   set(ax(2),'userdata',shape)
   axes(ax(1))

   % Check for selection type 'extend', usually <shift>-<click>.
   % See MATLAB documentation/ ...
   %    Handle Graphics Property Browser/Figure/SelectionType.

   reveal = isequal(get(gcf,'selectiontype'),'extend');
   if reveal
      line(real(t),imag(t),'color',[0 0 1])
   end

% ------------------------

function snap
   % Button up, snap to any nearby piece, then deselect.
   % Use complex arithmetic.

   delete(findobj(gca,'type','line'))
   hit = get(gca,'userdata');
   set(gca,'userdata',[])
  
   % Compute distance to nearest vertex of other pieces.

   z = get(hit,'xdata') + get(hit,'ydata')*i;
   h = get(gca,'children');
   w = [];
   for k = 1:length(h)
      if h(k) ~= hit
         w = [w; get(h(k),'xdata')+get(h(k),'ydata')*i];
      end
   end
   dz = 1;
   for k = 1:length(z);
      d = z(k)-w;
      dw = d(find(abs(d)==min(abs(d)),1));
      if abs(dw) < abs(dz)
         dz = dw;
      end
   end

   % If close enough, snap to nearby piece.

   tol = 1/8;
   if abs(dz) < tol
      set(hit,'xdata',real(z-dz),'ydata',imag(z-dz))
      bluegreen = [0 1/2 1/2];
      set(hit,'facecolor',1.25*bluegreen)
      pause(.25)
      set(hit,'facecolor',bluegreen)
   end
