subplot(1,3,1), [cs,h] = contour(peaks); clabel(cs,h,'labelspacing',72)
subplot(1,3,2), cs = contour(peaks); clabel(cs)
subplot(1,3,3), [cs,h] = contour(peaks); 
clabel(cs,h,'fontsize',15,'color','r','rotation',0)
get(h,  'type')
