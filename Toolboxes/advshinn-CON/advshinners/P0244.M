clf; hold off; sbplot(211);
num = [1 1];
den = [1 6 9 0];
[kbreak sbreak] = rlpoba(num,den);
[ku su] = rootangl(num,den,180-41.41);
r = rlocus(num,den,sort([0 kbreak' logspace(-1,4)]));
axis([-4 2 -6 6]); plot(r,'-'); grid; hold on; axis([-4 2 -6 6]);
xlabel('Real'); ylabel('Imaginary'); title('Uncompensated');
plot(roots(num)+eps*sqrt(-1),'o');
plot(roots(den)+eps*sqrt(-1),'x');
plot(sbreak,0*sbreak,'*');
text(sbreak,0,[' Sbreak = ' num2str(sbreak)]);
plot([0; su],'--');
%
% Compensated system
hold off; sbplot(212);
num = conv(num,[1 0.0188]);
den = conv(den,[1 0.001]);
[kbreak sbreak] = rlpoba(num,den);
[kc sc] = rootangl(num,den,180-41.41);
r = rlocus(num,den,sort([0 kbreak' logspace(-1,4)]));
axis([-4 2 -6 6]); plot(r,'-'); grid; hold on; axis([-4 2 -6 6]);
xlabel('Real'); ylabel('Imaginary'); title('Compensated');
plot(roots(num)+eps*sqrt(-1),'o');
plot(roots(den)+eps*sqrt(-1),'x');
plot(sbreak,0*sbreak,'*');
for n = 1:length(kbreak)
  text(sbreak(n),-n/2+.5,[' Sbreak = ' num2str(sbreak(n))]);
end;
plot([0; sc],'--');
hold off;
