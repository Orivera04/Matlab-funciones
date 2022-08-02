z = peaks(16);
subplot(1,3,1);surf(z);shading interp;colormap(gray);
view(-37.5, 30); axis off
subplot(1,3,2); surf(z);shading interp;colormap(gray);
view(0,90); axis off
subplot(1,3,3);surf(z);shading interp;colormap(gray);
view(180,0); axis off
