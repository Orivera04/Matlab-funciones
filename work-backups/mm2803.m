N=17;
data=[1:N+1;1:N+1]';
subplot(1,3,1)
map=mmrgb2gray(hsv(N));
colormap(map)
pcolor(data)
set(gca,'XtickLabel','')
title('Figure 28.3: Auto Limits')
caxis auto
subplot(1,3,2)
pcolor(data)
axis off
title('Extended Limits')
caxis([-5,N+5]) % extend the color range
subplot(1,3,3)
pcolor(data)
axis off
title('Restricted Limits')
caxis([5,N-5]) % restrict the color range

