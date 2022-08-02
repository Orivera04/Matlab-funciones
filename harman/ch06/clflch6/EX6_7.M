% EX6_7.M Test Euler method on Dy(t)=y(t) t=[0 1].
%  Compare exact value with Euler solution
%  y(n+1)=y(n)+hy(n)=(1+h)y(n); h=0.1
clear
n=10;                     % Number of intervals
y(1)=1;                   % Initial value
T(1)=0;                   % Initial time
yexact(1)=1;
yerror(1)=0;
h=0.1                    % Fixed step size
for I=1:n;
 T(I+1)=I*h;
 y(I+1)=y(I)*(1+h);
 yexact(I+1)=exp(I*h);   % Exact value
 yerror(I+1)=y(I+1)-yexact(I+1);
end;
format short             % Show four places
test=[T' y' yexact' yerror'];
disp('       t       yn        exp     error')
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
% Modify the script to accept a variable step size and plot the
%  results for various step sizes. Label the plot with the step sizes