num = [0.685 1]; den = conv(conv([1 1],[1 1]),[1 22 149]);
%
[kbreak,sbreak] = rlpoba(num,den);
r = rlocus(num,den,sort([0 kbreak' logspace(0,4)]));
v = 292; v = 180;
rr = rlocus(num,den,v);
axis([-15 0 -8 8]); plot(r,'-'); grid; axis([-15 0 -8 8]);
xlabel('Real'); ylabel('Imaginary');
hold on;
z = roots(num); plot(z+sqrt(-1)*eps,'ow');
p = roots(den); plot(p+sqrt(-1)*eps,'xw'); plot(-1,.2,'xw');
plot(rr+sqrt(-1)*eps,'*b'); text(-3,3,['* k=' num2str(v)]);
hold off;
