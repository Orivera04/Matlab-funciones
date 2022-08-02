set(gcf,'DefaultTextFontSize',36)
clf
x = linspace(1,2);
y = gamma(x);
plt(x,y)
text(1.01,gamma(1.01),' \Gamma (x) = \int_0^\infty t^{x - 1}e^{-t} dt')
set(gca,'FontSize',36)

