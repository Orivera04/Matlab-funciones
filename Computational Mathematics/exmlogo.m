function exmlogo
% EXMLOGO "Experiments with MATLAB" logo.
% L-shaped membrane using the "Experiments with MATLAB" color scheme.
% Rotate3d is on.

% Set up the figure window

clf
shg
chocolate4 = [139 69 19]/256;
set(gcf,'color',chocolate4,'colormap',(hot(8)))
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
   set(h(k),'linewidth',2,'edgecolor','k', ...
      'facealpha',.5,'zdata',4*k*ones(m(k),1))
end
hold off
view(12,30)
axis([0 75 0 60 0 30])
rotate3d
