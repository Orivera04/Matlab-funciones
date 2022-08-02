function ticklabely(laby,stry)

if nargin == 1
   stry='';
end

%Xt=get(gca, 'Xtick');
Yt=get(gca, 'Ytick');
Xl=get(gca, 'XLim');
%Yl=get(gca, 'Ylim');


%Place the new YTick labels
ty = text(Xl(1)*ones(1,length(Yt)),Yt,laby);
set(ty,'HorizontalAlignment','right','VerticalAlignment','middle')

% Remove the default YTicklabels
set(gca,'YTickLabel','')

%Find the extent of the YtickLabels
for i = 1:length(ty)
  exty(i,:) = get(ty(i),'Extent');
end

posy=get(get(gca, 'ylabel'), 'position');
ylabel(stry, 'Position', [min(min(exty)) posy(2) posy(3)]);
