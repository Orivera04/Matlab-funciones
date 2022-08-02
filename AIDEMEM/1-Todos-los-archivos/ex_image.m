im = double(imread('../d/jtl.bmp'));
figure(1);image(im);colormap(gray); 
figure(2);imagesc(im);colormap(gray);
figure(3);map=contrast(im,512);image(im);colormap(map);