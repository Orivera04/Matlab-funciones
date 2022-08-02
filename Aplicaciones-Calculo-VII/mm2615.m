% mm2615.m
x = -2.9:0.2:2.9;
y = exp(-x.*x);
subplot(2,2,1)
bar(x,y)
title('Figure 26.15a: 2-D Bar Chart')
subplot(2,2,2)
bar3(x,y,'r')
title('Figure 26.15b: 3-D Bar Chart')
subplot(2,2,3)
stairs(x,y)
title('Figure 26.15c: Stair Chart')
subplot(2,2,4)
barh(x,y)
title('Figure 26.15d: Horizontal Bar Chart')
set(gcf,'Renderer','painters')