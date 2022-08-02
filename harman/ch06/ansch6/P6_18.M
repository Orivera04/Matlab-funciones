% P6_18.M Create square wave
%
c=ones(10,1);
d=[1;0;1;0];
kron(d,c);
x=[1:40]';
plot(x,kron(d,c),'*')
title('Square wave')
xlabel('x')
ylabel('y')
%
% Add comments to explain the program
