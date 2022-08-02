function vibrating_string
% VIBRATING_STRING   Wave equation in one dimension.
%   Solutions of the one-dimensional wave equation are expressed
%   as a time-varying weighted sums of the first nine modes.
%   The one-dimensional domain is an interval of length pi, so the k-th
%   frequency and mode are lambda(k) = k^2 and u(k) = sin(k*x).

m = 11;   % Number of grid points
speed = 1;
bvals = [0; 0; 0; 0];
t = 0;

while bvals(4) == 0

   % Initialize figure

   shg
   clf
   set(gcf,'colormap',hot(64))
   b = zeros(1,4);
   for k = 1:4
      b(k) = uicontrol('style','toggle','value',bvals(k), ...
          'units','normal','position',[.08+.15*k .03 .14 .05]);
   end
   set(b(1),'string','modes/wave')
   set(b(2),'string','slower')
   set(b(3),'string','faster')
   set(b(4),'string','stop')
   if bvals(2)==1
      speed = speed/sqrt(2);
      set(b(2),'value',0);
   end
   if bvals(3)==1
      speed = speed*sqrt(2);
      set(b(3),'value',0);
   end
   bvals = cell2mat(get(b,'value'));
   modes = bvals(1)==0;

   x = (0:4*m)/(4*m)*pi;
   orange = [1 1/3 0];
   gray = get(gcf,'color');
   if modes

      % Modes

      for k = 1:9
         subplot(3,3,k)
         h(k) = plot(x,zeros(size(x)));
         axis([0 pi -3/2 3/2])
         set(h(k),'color',orange,'linewidth',3)
         set(gca,'color',gray','xtick',[],'ytick',[])
      end
      delta = 0.005*speed;
      bvs = bvals;
      while all(bvs == bvals)
         t = t + delta;
         for k = 1:9
            u = sin(k*t)*sin(k*x);
            set(h(k),'ydata',u)
         end
         drawnow
         bvs = cell2mat(get(b,'value'));
      end

   else

      % Wave

      % The coefficients.

      a = 1./(1:9);

      h = plot(x,zeros(size(x)));
      axis([0 pi -9/4 9/4])
      set(h,'color',orange,'linewidth',3)
      set(gca,'color',gray','xtick',[],'ytick',[])
      delta = 0.005*speed;
      bvs = bvals;
      while all(bvs == bvals)
         t = t + delta;
         u = zeros(size(x));
         for k = 1:9
            u = u + a(k)*sin(k*t)*sin(k*x);
         end
         set(h,'ydata',u)
         drawnow
         bvs = cell2mat(get(b,'value'));
      end
   end
   bvals = bvs;
end
set(b(1:3),'vis','off')
set(b(4),'string','close','callback','close(gcf)')
