x0 = -2 ; y0 = -1.5 ; d = 3 ; n = 512 ;
maxit = 256 ;

x = linspace(x0, x0+d, n) ;
y = linspace(y0, y0+d, n) ;
[x,y] = meshgrid(x, y) ;
C = x + y*1i ;
Z = C ;
K = ones(n, n) ;
for k = 1:maxit
    a = find((real(Z).^2 + imag(Z).^2) < 4);
    Z(a) = (Z(a)).^2 + C(a) ;
    K(a) = k ;
end
figure(1) ; clf
colormap(jet(maxit)) ;
image(x0 + [0 d], y0 + [0 d], K) ;
set(gca, 'YDir', 'normal') ;
axis equal
axis tight
