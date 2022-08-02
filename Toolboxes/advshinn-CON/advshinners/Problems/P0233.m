num = [1 1]; den = [conv([1 3],[1 6]) 0];
%
clf; hold off; sbplot(211);
[kbreak sbreak] = rlpoba(num,den);
[kmax,smax] = rootangl(num,den,90);
r = rlocus(num,den,sort([0 kbreak' kmax' logspace(-1,4)]));
axis([-7 2 -6 6]); plot(r,'-'); grid; hold on; axis([-7 2 -6 6]);
xlabel('Real'); ylabel('Imaginary'); title('Uncompensated');
plot(real(roots(num)),imag(roots(num)),'o');
plot(real(roots(den)),imag(roots(den)),'x');
plot(real([smax conj(smax)]),imag([smax conj(smax)]),'*');
for n = 1:length(kmax),
  text(0,imag(smax(n)),[' Kmax = ' num2str(kmax(n))]);
  text(0,-imag(smax(n)),[' Smax = ' num2str(-imag(smax(n))) 'j']);
end;
plot(sbreak,0*sbreak,'*');
for n = 1:length(kbreak),
  text(sbreak(n),0,[' Sbreak = ' num2str(sbreak(n))]);
end;
%
% Compensated system
num = conv(num,[1 0.16]); den = conv(den,[1 0.01]);
%
hold off; sbplot(212);
[kbreak sbreak] = rlpoba(num,den);
[kmax,smax] = rootangl(num,den,90);
r = rlocus(num,den,sort([0 kbreak' kmax' logspace(-1,4)]));
axis([-7 2 -6 6]); plot(r,'-'); grid; hold on; axis([-7 2 -6 6]);
xlabel('Real'); ylabel('Imaginary'); title('Compensated');
plot(real(roots(num)),imag(roots(num)),'o');
plot(real(roots(den)),imag(roots(den)),'x');
plot(real([smax conj(smax)]),imag([smax conj(smax)]),'*'); 
for n = 1:length(kmax),
  text(0,imag(smax(n)),[' Kmax = ' num2str(kmax(n))]);
  text(0,-imag(smax(n)),[' Smax = ' num2str(-imag(smax(n))) 'j']);
end;
plot(sbreak,0*sbreak,'*');
for n = 1:length(kbreak)
  text(sbreak(n),-n/2+.5,[' Sbreak = ' num2str(sbreak(n))]);
end;
hold off;
