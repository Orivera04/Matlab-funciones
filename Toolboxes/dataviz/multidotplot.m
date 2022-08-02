function multidotplot(data,sublabely,sublabelx,subtitle,subLocations)
%  make multipanel plot with dotplots as subplots
%  multidotplot(data,sublabely,sublabelx,subtitle,subLocations)
%  data is treated columnwise
%  sublabely is a cell or string array of y labels
%  sublabelx is the xlabel
%  subtitle is a cell or string array of titles
%  subLocations holds the subplot locations as [rows cols]

% Copyright (c) 1998 by Datatool
% $Revision: 1.00 $

%  calculate panel layout
subrows = max(subLocations(:,1));
subcols = max(subLocations(:,2));

np = size(data,2);

%  get common axis limits
naxis = [floor(min(data(:))) ceil(max(data(:))) -inf inf];

%  make room for ylabels
pos = get(gcf,'DefaultAxesPosition');
oldPos = pos;
shift = 1.3;
pos(1) = shift*pos(1);
pos(3) = pos(3)-(shift-1)*oldPos(1);
set(gcf,'DefaultAxesPosition',pos)

%  make the subplots
%  make selective labels and tick marks
for ii = 1:np
   thisLoc = (subLocations(ii,1)-1)*subcols+subLocations(ii,2);
   subplot(subrows,subcols,thisLoc)
   dotplot(data(:,ii),sublabely)
   axis(naxis)
   title((subtitle(ii)))
   if subLocations(ii,2)~=1
      set(gca,'YTickLabel',[])
   end
   if subLocations(ii,1)~=subrows
      set(gca,'XTickLabel',[])
   else
      if subLocations(ii,2)==round(subcols/2)
         xlabel(sublabelx)
      end
   end
   %  make plots slightly bigger than default
   pos = get(gca,'Position');
   pos(3) = 1.15*pos(3);
   pos(4) = 1.10*pos(4);
   pos(2) = 0.95*pos(2);
   set(gca,'Position',pos)
   set(gca,'FontSize',8)
end

%  Reset default
set(gcf,'DefaultAxesPosition',oldPos)
