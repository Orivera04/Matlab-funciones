%  book_2_11.m
%  calls normalqqplot

load singer

allData = [Alto_1;      Bass_1;      Soprano_1;   Tenor_1; ...     
      Alto_2;      Bass_2;      Soprano_2;   Tenor_2];
allNames = {'Soprano_2'; 'Soprano_1'; 'Alto_2'; 'Alto_1'; 'Tenor_2';...
      'Tenor_1'; 'Bass_2'; 'Bass_1'};
labels = {'Singer'; 'Unit Normal Quantile'; 'Height (inches)'};

%  set uniform plot limits
allMin = min(allData(:));
allMax = max(allData(:));
allAxis = [-2.2 2.2 allMin allMax];

%  determine subplot params
np = length(allNames);
plotRows = ceil(sqrt(np));
plotCols = floor(np/plotRows);
%  compute label locations
xLabelPos = floor((np+np+1)/2);
yLabelPos = floor((plotRows+1)/2)*plotCols+1;

for ii = 1:np
   subplot(plotRows+1,plotCols,ii)
   eval(['temp=',allNames{ii},';']);
   normalqqplot(temp)
   title(char(allNames(ii)),'interpreter','none')
   xlabel('')
   axis(allAxis)
   %  suppress most tick labels
   if ii<np-plotCols+1
      set(gca,'XTickLabel',[])
   end
   if rem(ii,plotCols)~=1
      set(gca,'YTickLabel',[])
   end
   %  make plots slightly bigger than default
   pos = get(gca,'Position');
   pos(3) = 1.15*pos(3);
   pos(4) = 1.10*pos(4);
   set(gca,'Position',pos)
   set(gca,'FontSize',8)
   if ii==xLabelPos
      xlabel(labels(2))
   end
   if ii==yLabelPos
      ylabel(labels(3))
   end

end
