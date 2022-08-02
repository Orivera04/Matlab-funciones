% P6_19.M Test Euler method on Dy=y with h=0.2.
% y(n+1)=y(n)+hy(n)=(1+h)y(n)
clear
n=5
y(1)=1
T(1)=0
yexact(1)=1
yerror(1)=0
h=0.2
for I=1:n;
 T(I+1)=I*h;
 y(I+1)=y(I)*(1+h);
 yexact(I+1)=exp(I*h);
 yerror(I+1)=y(I+1)-yexact(I+1);
end;
test=[T' y' yexact' yerror'];
disp('       t        yn       exp      error')
disp(' ')
disp(test)
pause
clf
plot(T,yexact,'-',T, y,'x')
title('First Order Equation, Euler (-x-) and exact solution')
xlabel('Time')
ylabel('y(t)')
legend('Exp', 'Euler')
%
% Add comments to explain the operation of the M-file.
% Add an fprintf statement before the pause to explain
%  the display
