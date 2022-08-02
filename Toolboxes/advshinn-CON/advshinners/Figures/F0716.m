num = [1 1.429];
den = [conv([1 14+sqrt(-1)*8.944],[1 14-sqrt(-1)*8.944]) 0 0];
[kbreak,sbreak] = rlpoba(num,den);
r = rlocus(num,den,sort([kbreak' logspace(2,4,200)]));
%r(1,1:2) = r(1,3:4); r(1,3:4) = zeros(1,2); % fix for line plot
axis([-20 5 -10 10]); plot(r,'-'); grid; axis([-20 5 -10 10]);
xlabel('Real'); ylabel('Imaginary');
hold on;
z = roots(num); plot(z+sqrt(-1)*eps,'ow');
p = roots(den); plot(p+sqrt(-1)*eps,'xw');
for i = 2:2:4
  text(sbreak(i),0,[' K=' num2str(kbreak(i))]);
end;
hold off;
