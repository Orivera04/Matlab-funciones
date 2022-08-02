num = [1 1.38];
den = [conv([1 9.5+sqrt(-1)*15.3],[1 9.5-sqrt(-1)*15.3]) 0 0];
[kbreak,sbreak] = rlpoba(num,den);
r = rlocus(num,den,sort([0 kbreak' logspace(1,4)]));
rr = rlocus(num,den,627.6);
%r(1,1:2) = r(1,3:4); r(1,3:4) = zeros(1,2); %fix for line plots
axis([-10 5 -20 20]); plot(r,'-'); grid; axis([-10 5 -20 20]);
xlabel('Real'); ylabel('Imaginary');
hold on;
z = roots(num); plot(z+sqrt(-1)*eps,'ow');
p = roots(den); plot(p+sqrt(-1)*eps,'xw'); plot(0,.2,'xw');
plot(rr,'*b'); text(2,6,'* K = 627.6');
hold off;
