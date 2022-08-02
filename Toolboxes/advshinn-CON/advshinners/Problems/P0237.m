num = 0.0201*conv([1 0.888],[1 0.112]);
den = [conv(conv([1 0.3],[1 0.5]),conv([1 0.2],[1 0.05])) 0];
%
[kbreak sbreak] = rlpoba(num,den);
[kmax,smax] = rootangl(num,den,90);
r = rlocus(num,den,sort([0 kbreak' kmax' logspace(-1,4)]));
axis([-2 1 -2 2]); plot(r,'-'); grid; axis([-2 1 -2 2]);
xlabel('Real'); ylabel('Imaginary');
hold on; plot(real(roots(num)),imag(roots(num)),'o'); hold off;
hold on; plot(real(roots(den)),imag(roots(den)),'x'); hold off;
angle = acos(-0.5)*180/pi;  % angle at which zeta = 0.5
[ka sa] = rootangl(num,den,angle);
hold on; plot(sa,'*b'); hold off;
for ii = 1:length(ka)
  text(real(sa(ii)),imag(sa(ii)),[' K = ' num2str(ka(ii))]);
end;
