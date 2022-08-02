x = -2.9:0.2:2.9;
y = exp(-x.*x);
subplot(2,2,1)
bar(x,y)
title('Figure 25.15a: 2-D Bar Chart')
subplot(2,2,2)
bar3(x,y,'r')
title('Figure 25.15b: 3-D Bar Chart')
subplot(2,2,3)
stairs(x,y)
title('Figure 25.15c: Stair Chart')
subplot(2,2,4)
barh(x,y)
title('Figure 25.15d: Horizontal Bar Chart')