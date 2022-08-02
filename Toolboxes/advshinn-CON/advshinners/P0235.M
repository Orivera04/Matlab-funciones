num = [0.1 1]; den = [conv([1 2],[1 4]) 0];
%
clf; hold off; sbplot(211);
[kbreak sbreak] = rlpoba(num,den);
[kmax,smax] = rootangl(num,den,90);
ii = find(abs(smax) < 1000); kmax = kmax(ii); smax = smax(ii);
r = rlocus(num,den,sort([0 kbreak' kmax' logspace(-1,4)]));
axis([-6 2 -6 6]); plot(r,'-'); grid; hold on; axis([-6 2 -6 6]);
xlabel('Real'); ylabel('Imaginary'); title('Uncompensated');
plot(roots(num)+eps*sqrt(-1),'o');
plot(roots(den)+eps*sqrt(-1),'x');
plot([smax conj(smax)],'*');
for n = 1:length(kmax),
  text(0,imag(smax(n)),[' Kmax = ' num2str(kmax(n))]);
  text(0,-imag(smax(n)),[' Smax = ' num2str(-imag(smax(n))) 'j']);
end;
plot(sbreak,0*sbreak,'*');
for n = 1:length(kbreak),
  text(sbreak(n),.2,[' Sbreak = ' num2str(sbreak(n))]);
end;
%
% Compensated system
num = conv(num,[1 0.0525]); den = conv(den,[1 0.01]);
%
hold off; sbplot(212);
[kbreak sbreak] = rlpoba(num,den);
[kmax,smax] = rootangl(num,den,90);
ii = find(abs(smax) < 1000); kmax = kmax(ii); smax = smax(ii);
r = rlocus(num,den,sort([0 kbreak' kmax' logspace(-1,4)]));
axis([-6 2 -6 6]); plot(r,'-'); grid; hold on; axis([-6 2 -6 6]);
xlabel('Real'); ylabel('Imaginary'); title('Compensated');
plot(roots(num)+eps*sqrt(-1),'o');
plot(roots(den)+eps*sqrt(-1),'x');
plot([smax conj(smax)],'*');
for n = 1:length(kmax),
  text(0,imag(smax(n)),[' Kmax = ' num2str(kmax(n))]);
  text(0,-imag(smax(n)),[' Smax = ' num2str(-imag(smax(n))) 'j']);
end;
plot(sbreak,0*sbreak,'*');
text(sbreak(1),.3,[' Sbreak = ' num2str(sbreak(1))]);
for n = 2:length(kbreak)
  text(sbreak(n),-n/2+.5,[' Sbreak = ' num2str(sbreak(n))]);
end;
hold off;
