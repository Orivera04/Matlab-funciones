function scattermatrix(data,label)
%  plot a matrix of scatter plots
%  scattermatrix(data,label)
%  takes data columnwise in pairs
%  label is a cell or string array of labels for diagonal boxes

% Copyright (c) 1998 by Datatool
% $Revision: 1.00 $

nseries = size(data,2);  % number of data series

%  if labels are not given, make some
if nargin<2
   for ii = 1:nseries
      label{ii} = ['Series' int2str(ii)];
   end
end

for ic = 1:nseries
   for ir = 1:nseries
      subplot(nseries,nseries,(nseries-ir)*nseries+ic)
      if ir==ic
         %  position and size label
         scatter(data(:,ic),data(:,ir),1,'w')
         naxis = axis;
         tx = 0.5*(naxis(1)+naxis(2));
         ty = 0.5*(naxis(3)+naxis(4));
         hg = text(tx,ty,char(label(ic)),'HorizontalAlignment','center');
         set(hg,'FontSize',round(27/nseries))
      else
         %  plot data points
         scatter(data(:,ic),data(:,ir))
      end
      %  make plots slightly bigger than default
      pos = get(gca,'Position');
      pos(3:4) = 1.13*pos(3:4);
      set(gca,'Position',pos)
      set(gca,'FontSize',round(24/nseries))
      box on
      %  place labels on overall edges
      if ir~=1
         set(gca,'XTickLabel',[])
      end
      if ic~=1
         set(gca,'YTickLabel',[])
      end
   end
end


