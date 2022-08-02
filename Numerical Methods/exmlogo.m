% TWO LOGOS
% L-shaped membrane on the covers of the print
% versions of Numerical Computing with MATLAB
% and Experiments with MATLAB.
% Rotate in 3D with the mouse.
% Set which to 'ncm' or 'exm'.

which = 'exm';

% Set up the figure window

clf
shg
switch which
   case 'ncm'
      set(gcf,'color',[0 0 1/4],'colormap',jet(8))
   case 'exm'
      set(gcf,'color',[1/3 0 0],'colormap',flipud(jet(8)))
end
set(gcf,'inverthardcopy','off')
axes('pos',[0 0 1 1])
axis off
daspect([1 1 1])

% Compute MathWorks logo

L = rot90(membranetx(1,32,10,10),2);

% Filled contour plot with transparent lifted patches

b = (1/16:1/8:15/16)';
hold on
for k = 1:8
   [c,h(k)] = contourf(L,[b(k) b(k)]);
   if strcmp(get(h(k),'Type'),'hggroup')
     h(k) = get(h(k),'Children');
   end
   m(k) = length(get(h(k),'xdata'));
   set(h(k),'linewidth',2,'edgecolor','w', ...
      'facealpha',.5,'zdata',4*k*ones(m(k),1))
end
hold off
view(12,30)
axis([0 64 0 64 0 32])
axis vis3d
rotate3d on

% print -djpeg two_logos.jpg
