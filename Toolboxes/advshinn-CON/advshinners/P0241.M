num = conv([1 0.1],[1 0.1]);
den = [1 9 20 0 0];
[kbreak sbreak] = rlpoba(num,den);
[kmax,smax] = rootangl(num,den,90);
r = rlocus(num,den,sort([0 kbreak' kmax' logspace(-1,3)]));
axis([-6 1 -6 6]); plot(r,'-'); grid; axis([-6 1 -6 6]);
xlabel('Real'); ylabel('Imaginary');
hold on; plot(real(roots(num)),imag(roots(num)),'o'); hold off;
hold on; plot(real(roots(den)),imag(roots(den)),'x'); hold off;
angle = acos(-0.75)*180/pi;   % angle at which zeta = 0.75
[ka sa] = rootangl(num,den,angle);
hold on; plot(sa,'*b'); hold off;
for ii = 1:length(ka)
  text(real(sa(ii)),imag(sa(ii)),[' K = ' num2str(ka(ii))]);
  hold on; plot([0 sa(ii)],'--'); hold off;
end;
