num = [1 1]; den = [1 2 0 0];
%
clf; hold off; sbplot(211);
r = rlocus(num,den,[0 logspace(-1,4)]);
axis([-3 1 -5 5]); plot(r,'-'); grid; hold on; axis([-3 1 -5 5]);
title('Phase-Lead Network'); xlabel('Real'); ylabel('Imaginary');
plot(roots(num)+eps*sqrt(-1),'o');
plot(roots(den)+eps*sqrt(-1),'x');
%
num = [1 2]; den = [1 1 0 0];
hold off; sbplot(212);
r = rlocus(num,den,[0 logspace(-1,4)]);
axis([-3 1 -5 5]); plot(r,'-'); grid; hold on; axis([-3 1 -5 5]);
title('Phase-Lag Network'); xlabel('Real'); ylabel('Imaginary');
plot(roots(num)+eps*sqrt(-1),'o');
plot(roots(den)+eps*sqrt(-1),'x');
hold off;
