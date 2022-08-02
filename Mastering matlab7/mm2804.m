x = -7.5:.5:7.5;           % data
[X Y] = meshgrid(x);       % create plaid data
R = sqrt(X.^2 + Y.^2)+eps; % create sombrero
Z = sin(R)./R;

subplot(2,2,1)
surf(X,Y,Z,Z)    % default color order
colormap(gray)
shading interp
axis tight off
title('Figure 28.4a: Default, Z')

subplot(2,2,2)
surf(X,Y,Z,Y)   % Y axis color order
shading interp
axis tight off
title('Figure 28.4b: Y axis')

subplot(2,2,3)
surf(X,Y,Z,X-Y) % diagonal color order
shading interp
axis tight off
title('Figure 28.4c: X - Y')

subplot(2,2,4)
surf(X,Y,Z,R)   % radius color order
shading interp
axis tight off
title('Figure 28.4d: Radius')

