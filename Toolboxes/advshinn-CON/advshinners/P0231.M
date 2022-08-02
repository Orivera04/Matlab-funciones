num = 1; den = [1 6 10 0];
%
[kbreak sbreak] = rlpoba(num,den);
[kmax,smax] = rootangl(num,den,90);
r = rlocus(num,den,sort([0 kbreak' kmax' logspace(-1,4)]));
axis([-5 2 -6 6]); plot(r,'-'); grid; axis([-5 2 -6 6]);
xlabel('Real'); ylabel('Imaginary');
hold on; plot(real(roots(num)),imag(roots(num)),'o'); hold off;
hold on; plot(real(roots(den)),imag(roots(den)),'x'); hold off;
hold on; plot([smax conj(smax)],'*'); hold off;
text(0,imag(smax),[' Kmax = ' num2str(kmax)]);
text(0,-imag(smax),[' Smax = ' num2str(-imag(smax)) 'j']);
hold on; plot(sbreak,0*sbreak,'*'); hold off;
for n = 1:length(kbreak),
  text(sbreak(n),0,[' Sbreak = ' num2str(sbreak(n))]);
end;
[kangl,sangl] = rootangl(num,den,180-60);
rangl = rlocus(num,den,kangl);
hold on; plot(rangl,'*'); plot([0 sangl],'--w'); hold off;
text(real(sangl),imag(sangl),['K = ' num2str(kangl)]);
text(real(sangl),-imag(sangl),['S = ' num2str(real(sangl)) num2str(-imag(sangl)) 'j']);
text(max(rangl),0,['S = ' num2str(max(rangl))]);
