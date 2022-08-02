clf
peaks(20)
h = findobj('type','surface');
set(h,'FaceColor',[.5 .5 .5 ],...
    'edgecolor',[.5 .5 .5])
xl = [-3    -3     3     ];
yl = [-3     3    -3     ];
zl = [ 8     8     8     ];
cols = [1 1 1
        1 1 0
	0 1 0];

for i=1:length(xl)
  light('pos',[xl(i),yl(i),zl(i)],'col',cols(i,:))
end
pltlight
axis off