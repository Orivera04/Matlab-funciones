function ticklabelx(labx,strx)

if nargin == 1
   strx='';
end

Xt=get(gca, 'Xtick');
Yt=get(gca, 'Ytick');
Xl=get(gca, 'XLim');
Yl=get(gca, 'Ylim');

% Place the new Xtick labels
tx = text(Xt,Yl(1)*ones(1,length(Xt)),labx);
set(tx,'HorizontalAlignment','center','VerticalAlignment','top')
      
% Remove the default XTicklabels
set(gca,'XTickLabel','')

%Find the extent of the XtickLabels
for i = 1:length(tx)
   extx(i,:) = get(tx(i),'Extent');
end
   
posx=get(get(gca, 'xlabel'), 'position');
xlabel(strx, 'Position', [posx(1) min(min(extx)) posx(3)])
