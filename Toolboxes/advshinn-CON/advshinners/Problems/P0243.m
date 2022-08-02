num = 0.5*conv(conv([1 3],[1 2]),[1 6]);
den = conv(conv([1 8 20],[1 2 2]),[1 6 45]);
[kbreak sbreak] = rlpoba(num,den);
[kmax,smax] = rootangl(num,den,90);
r = rlocus(num,den,sort([0 kbreak' kmax' logspace(-1,4)]));
axis([-11 1 -8 8]); plot(r,'-'); grid; axis([-11 1 -8 8]);
xlabel('Real'); ylabel('Imaginary');
hold on; plot(real(roots(num)),imag(roots(num)),'o'); hold off;
hold on; plot(real(roots(den)),imag(roots(den)),'x'); hold off;
angle = acos(-0.3)*180/pi;   % angle at which zeta = 0.3
[ka sa] = rootangl(num,den,angle);
hold on; plot(sa,'*b'); hold off;
for ii = 1:length(ka)
  text(real(sa(ii)),imag(sa(ii)),[' K = ' num2str(ka(ii))]);
  hold on; plot([0 sa(ii)],'--'); hold off;
end;
