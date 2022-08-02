num = [1 2]; den = [conv([1 4],[1 4]) 0]; aa = 161.8;
%
[kbreak,sbreak] = rlpoba(num,den);
r = rlocus(num,den,sort([0 kbreak' logspace(-2,3) 1e+5]));
axis([-4.5 .5 -5 5]); plot(r,'-'); grid; axis([-4.5 .5 -5 5]); 
xlabel('Real'); ylabel('Imaginary');
[ka,sa] = rootangl(num,den,aa);
hold on; plot([0 sa],'--'); plot(sa,'*'); hold off;
text(real(sa),imag(sa),[' K = ' num2str(ka)]);
text(-1.85,1.85*sin(aa*pi/180)/2,num2str(180-aa));
