num = [1 2]; den = [conv([1 4],[1 4]) 0]; aa = 161.8;
num = conv(num,[1 .10922]); den = conv(den,[1 .001]);
%
[kbreak,sbreak] = rlpoba(num,den);
rr = rlocus(num,den,sort([0 kbreak' logspace(-2,3) 1e+5]));
axis([-4.5 .5 -5 5]); plot(rr,'-'); grid; axis([-4.5 .5 -5 5]);
xlabel('Real'); ylabel('Imaginary');
[ka,sa] = rootangl(num,den,aa);
hold on; 
plot([0 sa(1)],'--'); plot(sa(1),'*'); 
z = roots(num); plot(z+sqrt(-1)*eps,'ow');
p = roots(den); plot(p+sqrt(-1)*eps,'xw'); plot(-4,.1,'xw');
hold off;
text(real(sa(1)),imag(sa(1)),[' K = ' num2str(ka(1))]);
text(-1.85,1.85*sin(aa*pi/180)/2,num2str(180-aa));