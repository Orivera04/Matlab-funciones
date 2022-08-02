clf; sbplot(211);
num = 20*conv([1 0.3],[1 1]);
den = conv(conv([1 0.5],[1 9]),[1 -0.35 0.15]);
[kbreak sbreak] = rlpoba(num,den);
[kmax,smax] = rootangl(num,den,90);
r = rlocus(num,den,sort([0 kbreak' kmax' 1.40223 logspace(-1,3,200) linspace(1.4,1.46,8)]));
%[n,m]=size(r); ii=61:n; sa=r(ii,1); r(ii,1)=r(ii,3); r(ii,3)=sa;
axis([-11 1 -8 8]); plot(r,'-'); grid; hold on; axis([-11 1 -8 8]);
title('Part A'); xlabel('Real'); ylabel('Imaginary');
plot(real(roots(num)),imag(roots(num)),'o');
plot(real(roots(den)),imag(roots(den)),'x');
angle = acos(-0.5)*180/pi;   % angle at which zeta = 0.5
[ka sa] = rootangl(num,den,angle);
plot(sa,'*b');
for ii = 1:length(ka)
  text(real(sa(ii)),imag(sa(ii)),[' K = ' num2str(ka(ii))]);
  plot([0 sa(ii)],'--'); 
end;
%
hold off; sbplot(212);
num = conv([1 1],20*conv([1 0.3],[1 4]));
den = conv([1 0.1],[1 9.15 27.32 33.65 8.48]);
[kbreak sbreak] = rlpoba(num,den);
[kmax,smax] = rootangl(num,den,90);
r = rlocus(num,den,sort([0 kbreak' kmax' logspace(-1,3)]));
axis([-6 1 -6 6]); plot(r,'-'); grid; hold on; axis([-6 1 -6 6]);
title('Part B'); xlabel('Real'); ylabel('Imaginary');
plot(real(roots(num)),imag(roots(num)),'o');
plot(real(roots(den)),imag(roots(den)),'x');
angle = acos(-0.5)*180/pi;   % angle at which zeta = 0.5
[ka sa] = rootangl(num,den,angle);
plot(sa,'*b');
for ii = 1:length(ka)
  text(real(sa(ii)),imag(sa(ii)),[' K = ' num2str(ka(ii))]);
  plot([0 sa(ii)],'--');
end;
hold off;
