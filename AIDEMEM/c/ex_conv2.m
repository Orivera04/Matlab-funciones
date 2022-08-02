a = [10*ones(100,50),30*ones(100,50)]+10*rand(100); 
subplot(1,4,1);imagesc(a);
colormap(gray);title('image brute'); 
b = ones(11)/(11*11); c = conv2(a, b, 'same');
subplot(1,4,3);imagesc(c);title('image lissée'); 
subplot(1,4,2);surf(a(1:3:end, 1:3:end)); shading('interp');
subplot(1,4,4);surf(c(1:3:end, 1:3:end)); shading('interp');