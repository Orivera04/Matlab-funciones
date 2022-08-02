set(gcf,'DefaultTextFontSize',175)
set(gcf,'DefaultTextFontName','Times')
set(gcf,'DefaultAxesFontSize',24)
clf
axis([0 1 0 1])
hold on
ht = text(.5, .5, 'Myopia');
plt(.5,.5,'+','MarkerSize',200)
va = {'Bottom';'Baseline';'Middle';'Cap';'Top'};
for this_va = va'
  set(ht,'VerticalAlignment',this_va{1})
  str = ['print -deps ' this_va{1}];
  eval(str)
end

set(ht,'VerticalAlignment','middle')
ha = {'Left';'Center';'Right'};
for this_ha = ha'
  set(ht,'HorizontalAlignment',this_ha{1})
  str = ['print -deps ' this_ha{1}];
  eval(str)
end