  colormap(gray); im = double(imread('jtl.bmp'));
  subplot(1,4,1);  imagesc(im);  axis off
  title({'\bfune image',  ' '});
  subplot(1,4,2);  [imx, imy] =  gradient(im); 
  [ar,  mo] = cart2pol(imx, imy);
  im1 = del2(mo);
  imagesc(256-abs(im1));  axis off; 
  title({'\bfLaplacien du module', '\bfdu gradient'});
  subplot(1,4,3); imagesc(1-(im1 <= max(im1(:)/10)));  axis off
  title({'\bfContour à partir', '\bfdu Laplacien'});   
  subplot(1,4,4); im2 = cont(im); 
  imagesc(im2);  axis off
  title({'\bfContour à partir', '\bfdu module du gradient'});   
