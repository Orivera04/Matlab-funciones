shades = zeros(9,3);
shades(1:3,1) = [.3;.7;1];
shades(4:6,2) = [.3;.7;1];
shades(7:9,3) = [.3;.7;1];
colormap(shades)
shadeimage = round(rand(25)*8+1);
colorimage = shadeimage;
colorimage(colorimage<4)= 3;
colorimage(colorimage >=4 & colorimage < 7) = 6;
colorimage(colorimage >=7 & colorimage < 10) = 9;
subplot(1,2,1)
image(shadeimage)
subplot(1,2,2)
image(colorimage)

