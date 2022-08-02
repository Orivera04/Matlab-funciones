% cap3_cart2pol_exemplo ()
echo on
% Converte coordenada cartesiana para polar
x=-pi:0.1:pi;
[p,r]=cart2pol(cos(x),sin(x));
polar(p,r)
subplot(1,2,1)
plot(cos(x),sin(x))
title('Coord.cartesiana')
subplot(1,2,2)
polar(p,r)
title('Coord.polar')
