num = [1 .98];  % [1 -.93] removed from num & den
den = conv([1 -.2],[1 -1]);   % [1 -.93] removed from num & den
[kbreak,sbreak] = rlpoba(num,den);
[kmax,smax] = rootmag(num,den,1);
[kk,ss] = rootangl(num,den,90);
r = rlocus(num,den,sort([kbreak' kmax' kk' linspace(0,15)]));
axis([-5 2 -2.5 2.5]); plot(r,'-'); grid; axis([-5 2 -2.5 2.5]);
xlabel('Real'); ylabel('Imaginary');
hold on;
z = roots(num); plot(z+sqrt(-1)*eps,'ow');
p = roots(den); plot(p+sqrt(-1)*eps,'xw');
w = linspace(0,2*pi); plot(cos(w),sin(w),'--');
plot(real(smax),imag(smax),'*b');
text(real(smax(1)),imag(smax(1)),[' Kmax = ' num2str(kmax(1))]);
text(real(smax(2)),imag(smax(2)),[' Kmax = ' num2str(kmax(2))]);
text(real(smax(4)),imag(smax(4)),[' Kmin = ' num2str(kmax(4))]);
hold off;
