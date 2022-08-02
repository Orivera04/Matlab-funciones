function mandelbrot(varargin)
% MANDELBROT  Explore the Mandelbrot set.
%  mandelbrot with no arguments starts with the full set.
%
%  mandelbrot(center,width,grid,depth,cmapidx)
%     center = Region center.  Default -.5+0i.
%     width = Region width.  Default 3.
%     grid = Grid size, usually 2^k or 3*2^k.  Default 512.
%     depth = Trace length.  Default 256.
%     cmapidx = Index into cell array of colormap functions, default 1.
%
%  You can ...
%     Use the mouse to zoom in on any region.
%     Choose among several predefined regions.
%     Increase the grid size or iteration depth.
%     Change the color map.

% The "state" consists of
%   center   % Region center, complex scalar.
%   width    % Region width, flint scalar.
%   grid     % Grid size, flint scalar.
%   depth    % Trace length, flint scalar.
%   cmapidx  % Index into cell array of colormap functions, flint scalar.
%   kz       % Counts on the grid, (grid+1)-by-(grid+1) uint16 array.
%   z        % z values on the grid,(grid+1)-by-(grid+1) complex array.
% As the state is modified, it is saved between callbacks in the gcf user data.

cmaps = {@jets, @hots, @cmyk, @fringe};
grid = 0;

% Switchyard.

if nargin == 0 || isnumeric(varargin{1})
   startup(varargin{:})
else
   get_state
   buttons = flipud(findobj(gcf,'type','uicontrol'));
   job = varargin{1};
   switch job(1:4)
      case 'dept'
         deepen
      case 'grid'
         refine
      case 'colo'
         colors
      case 'exit'
         close(gcf)
         return
      case 'regi'
         region
      otherwise
         error('Argument not recognized')
   end
end
state = {center,width,grid,depth,cmapidx,z,kz};
set(gcf,'userdata',state)

% ------------------------

function iterate(startdepth,finaldepth)
   s = width*(-1/2:1/grid:1/2);
   [u,v] = meshgrid(s+real(center),s+imag(center));
   z0 = u + i*v;
   if isreal(z)
      z = complex(z);
   end
   for d = startdepth:finaldepth
      if mod(d,32) == 0
         set(buttons(1),'string',[num2str(d) '/' num2str(finaldepth)])
         plotit;
      end
      [z,kz] = mandelbrot_step(z,kz,z0,d);
%     mandelbrot_step is a c-mex file that does one step of:
%        z = z.^2 + z0;
%        kz(abs(z) < 2) = d;
   end
   depth = finaldepth;
   set(buttons(1),'string',['depth = ' num2str(depth)])
   drawnow
end

% ------------------------

function cmap = jets(cmaplen)
   cycle = 16;
   cmap = repmat(jet(cycle),ceil(cmaplen/cycle),1);
end

% ------------------------

function cmap = hots(cmaplen)
   cycle = 16;
   cmap = repmat(flipud(hot(cycle)),ceil(cmaplen/cycle),1);
end

% ------------------------

function cmap = cmyk(cmaplen)
   % Blue, green, red, cyan, magenta, yellow, gray, black.
   b = [0 0 3; 0 2 0; 3 0 0; 0 3 3; ...
        3 0 3; 3 3 0; 1 1 1; 0 0 0]/4;
   cycle = size(b,1);
   cmap = repmat(b,ceil(cmaplen/cycle),1);
end

% ------------------------

function cmap = fringe(cmaplen)
   cmap = zeros(min(cmaplen,256),3);
   cmap(end,1) = .5;
   cmap(1:12,:) = 1;
end

% ------------------------

function colors
   % New color map
   cmapidx = mod(cmapidx,length(cmaps))+1;
   cx = char(cmaps{cmapidx});
   set(buttons(3),'string',['color: ' cx(find(cx=='/')+1:end)],'value',0)
   plotit
   state = {center,width,grid,depth,cmapidx,z,kz};
   set(gcf,'userdata',state)
end

% ------------------------

function startup(varargin)
   % First entry
   clf
   shg
   defaults = [-0.5+0i, 3, 512, 256, 1];
   parms = defaults;
   parms(1:nargin) = [varargin{:}];
   center = parms(1);
   width = parms(2);
   grid = parms(3);
   depth = parms(4);
   cmapidx = parms(5);
   kz = zeros(grid+1,grid+1,'uint16');
   z = zeros(grid+1,grid+1);
   set(gcf,'name','Mandelbrot')
   buttons = make_buttons;
   cx = char(cmaps{cmapidx});
   set(buttons(3),'string',['color: ' cx(find(cx=='/')+1:end)],'value',0)
   iterate(0,depth);
end

% ------------------------

function get_state
   state = get(gcf,'userdata');
   center = state{1};
   width = state{2};
   grid = state{3};
   depth = state{4};
   cmapidx = state{5};
   z = state{6};
   kz = state{7};
end

% ------------------------

function region
   switch get(gcbo,'value');
      case  1 %   full
         center = -.5+0i; width = 3;
         grid = 512; depth = 256; cmapidx = 1;
      case  2 %   fringe
         center = -.5+0i; width = 3;
         grid = 512; depth = 256; cmapidx = 4;
      case  3 %   seahorses1
         center = -0.7700-0.1300i; width = 0.10;
         grid = 512; depth = 512; cmapidx = 1;
      case  4 %   seahorses2
         center = -0.7799-0.1297i; width = 0.002;
         grid = 512; depth = 512; cmapidx = 1;
      case  5 %   buzzsaw
         center = 0.001643721971153+0.822467633298876i; width = 4.0e-11;
         grid = 1024; depth = 2048; cmapidx = 2;
      case  6 %   west wing
         center = -1.6735-0.0003318i; width = 1.5e-4;
         grid = 1024; depth = 160; cmapidx = 1;
      case  7 %   geode
         center = 0.28692299709-0.01218247138i; width = 6.0e-10;
         grid = 2048; depth = 4096; cmapidx = 1;
      case  8 %   nebula
         center = -0.737527770996094-0.128495483398438i; width = 4.8828125e-5;
         grid = 1024; depth = 2048; cmapidx = 3; 
      case  9 %   vortex1
         center = -1.74975914513036646-0.00000000368513796i; width = 6.0e-12;
         grid = 1024; depth = 2048; cmapidx = 2;
      case 10 %   vortex2
         center = -1.74975914513271613-0.00000000368338015i; width = 3.75e-13;
         grid = 1024; depth = 2048; cmapidx = 2;
      case 11 %   vortex3
         center = -1.74975914513272790-0.00000000368338638i; width = 9.375e-14;
         grid = 1024; depth = 2048; cmapidx = 2;
   end
   kz = zeros(grid+1,grid+1,'uint16');
   z = zeros(grid+1,grid+1);
   state = {center,width,grid,depth,cmapidx,z,kz};
   set(gcf,'userdata',state)
   cx = char(cmaps{cmapidx});
   set(buttons(2),'string',['grid = ' num2str(grid)])
   set(buttons(3),'string',['color: ' cx(find(cx=='/')+1:end)],'value',0)
   iterate(0,depth);
end

% ------------------------

function plotit
   s = width*(-1/2:1/grid:1/2);
   if width > .002
      pix = image(s+real(center),s+imag(center),kz);
      set(get(gca,'title'),'userdata',0)
   else
      pix = image(s,s,kz);
      g = ceil(-log10(width/2));
      f = ['%' num2str(g+6) '.' num2str(g+4) 'f'];
      if imag(center) < 0, s = ' - '; else s = ' + '; end
      title(sprintf([f s f 'i'],real(center),abs(imag(center))));
      set(get(gca,'title'),'userdata',center)
   end
   axis square
   set(gca,'ydir','normal')
   cmapfun = cmaps{cmapidx};
   cmaplen = max(1,max(max(kz)));
   colormap(cmapfun(cmaplen));
   set(pix,'userdata',z)
   drawnow
end

% ------------------------

function buttons = make_buttons
   buttons = zeros(5,1);
   bs = {'depth','grid','color','exit'};
   for k = 1:4
      buttons(k) = uicontrol('string',bs{k},'units','normal', ...
         'position',[.86,.65-.08*k,.13,.06],'style','toggle', ...
         'callback',['mandelbrot(''' bs{k} ''')']);
   end
   set(buttons(1),'string',['depth = ' num2str(depth)])
   set(buttons(2),'string',['grid = ' num2str(grid)])
   cx = char(cmaps{cmapidx});
   set(buttons(3),'string',['color: ' cx(find(cx=='/')+1:end)])
   set(buttons(4),'style','push')
   regionlist = {'full','fringe','seahorses1','seahorses2','buzzsaw', ...
         'west wing','geode','nebula','vortex1','vortex2','vortex3'};
   buttons(5) = uicontrol('style','list','string',regionlist, ...
         'units','normal','fontweight','bold', ...
         'callback','mandelbrot(''regi'')');
   ext = get(buttons(5),'extent');
   set(buttons(5),'position',[.40,.02,.28,ext(4)]);
   set(zoom,'enable','on','actionpostcallback',@zoomer)
end

% ------------------------

function deepen
   pix = get(gca,'child');
   kz = get(pix,'cdata');
   z = get(pix,'userdata');
   % Keep depth = 2^k or 3*2^k.
   if rem(depth,3) == 0
      finaldepth = 4*depth/3;
   else
      finaldepth = 3*depth/2;
   end
   set(buttons(1),'value',0,'callback',[])
   iterate(depth,finaldepth);
   set(buttons(1),'callback','mandelbrot(''depth'')')
end

% ------------------------

function refine
   pix = get(gca,'child');
   xlim = get(gca,'xlim');
   ylim = get(gca,'ylim');
   center = (xlim(1)+xlim(2))/2 + (ylim(1)+ylim(2))/2*i + ...
      get(get(gca,'title'),'userdata');
   x = get(pix,'xdata');
   width = x(end)-x(1);
   % Keep grid = 2^k or 3*2^k.
   if rem(grid,3) == 0
      grid = 4*grid/3;
   else
      grid = 3*grid/2;
   end
   set(buttons(2),'string',['grid = ' num2str(grid)],'value',0);
   kz = zeros(grid+1,grid+1,'uint16');
   z = zeros(grid+1,grid+1);
   iterate(0,depth);
   plotit;
end

% ------------------------

function zoomer(varargin)
   set(zoom,'enable','on','actionpostcallback',@zoomoff)
   get_state
   buttons = flipud(findobj(gcf,'type','uicontrol'));
   pix = get(gca,'child');
   xlim = get(gca,'xlim');
   ylim = get(gca,'ylim');
   x = get(pix,'xdata');
   y = get(pix,'ydata');
   j = [find(abs(x-xlim(1)) == min(abs(x-xlim(1)))), ...
        find(abs(x-xlim(2)) == min(abs(x-xlim(2))))];
   k = [find(abs(y-ylim(1)) == min(abs(y-ylim(1)))), ...
        find(abs(y-ylim(2)) == min(abs(y-ylim(2))))];
   zoomgrid = 2.^(floor(log2(round(sqrt((k(2)-k(1))*(j(2)-j(1)))))));
   j = round((sum(j)-zoomgrid)/2):round((sum(j)+zoomgrid)/2);
   k = round((sum(k)-zoomgrid)/2):round((sum(k)+zoomgrid)/2);
   width = (x(j(end))-x(j(1)) + y(k(end))-y(k(1)))/2;
   axisshift = get(get(gca,'title'),'userdata');
   center = (x(j(end))+x(j(1)))/2 + i*(y(k(end))+y(k(1)))/2 + axisshift;
   kz = zeros(grid+1,grid+1,'uint16');
   z = zeros(grid+1,grid+1);
   iterate(0,depth);
   plotit;
   state = {center,width,grid,depth,cmapidx,z,kz};
   set(gcf,'userdata',state)
   set(buttons(2),'string',['grid = ' num2str(grid)])
   set(zoom,'enable','on','actionpostcallback',@zoomer)
end

% ------------------------

function zoomoff
return
end

end % function mandelbrot
