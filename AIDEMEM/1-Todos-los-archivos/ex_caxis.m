[im map] =imread('jtl.bmp');
subplot(1,2,1)
imagesc(im), colormap(map)
caxis(gca,[1,max(im(:))])
subplot(1,2,2)
imagesc(im), 
caxis manual
caxis([50, 150])
