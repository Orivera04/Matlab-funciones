function zoomer
% ZOOMER  Avoid duplicate xtick and ytick labels.
% Do not call directly, instead:
%    set(zoom(gcf),'ActionPostCallback','zoomer')

reltol = .005;
xlim = get(gca,'xlim');
if diff(xlim) < reltol*max(abs(xlim))
   xt = xlim(1) + [1 3 5]/6*diff(xlim);
   e = -ceil(log10(diff(xlim)/max(abs(xlim))));
   f = sprintf('%%%d.%df',e+6,e+2);
   for k = 1:length(xt)
      xl(k,:) = sprintf(f,xt(k));
   end
   set(gca,'xtick',xt,'xticklabel',xl);
else
   set(gca,'xtickmode','auto','xticklabelmode','auto');
end

ylim = get(gca,'ylim');
if diff(ylim) < reltol*max(abs(ylim))
   yt = ylim(1) + [1 3 5]/6*diff(ylim);
   e = -ceil(log10(diff(ylim)/max(abs(ylim))));
   f = sprintf('%%%d.%df',e+6,e+2);
   for k = 1:length(yt)
      yl(k,:) = sprintf(f,yt(k));
   end
   set(gca,'ytick',yt,'yticklabel',yl);
else
   set(gca,'ytickmode','auto');
   set(gca,'yticklabelmode','auto');
end
