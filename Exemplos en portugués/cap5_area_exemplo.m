% cap5_area_exemplo
x=1:0.2:6;
y=sin(x);
subplot(1,3,1)
area(x,y)
title('Area')
subplot(1,3,2)
bar(x,y)
title('Bar')
subplot(1,3,3)
barh(x,y)
title('Barh')
