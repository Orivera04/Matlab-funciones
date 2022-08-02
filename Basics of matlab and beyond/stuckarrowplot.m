set(gcf,'defaultaxesfontsize',15)
set(gcf,'defaulttextfontsize',15)
set(gcf,'defaultaxesfontweight','b')
set(gcf,'defaulttextfontweight','b') 
t = {'help' spiral(3) ; ...
      eye(2) 'I''m stuck'};
tt = {t t ;t' fliplr(t)};
cellplot(tt)
h=findobj('type','surface');
for i=1:length(h),
  set(h(i),'cdata',3*ones(size(get(h(i),'cdata')))),
end,
axes,
set(gca,'pos',[0 0 1 1]),
axis manual,
arrow([.644 .094],[.618 .264]),
axis off
