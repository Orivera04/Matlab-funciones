function y=tablazat(ff,a,b,n)
% az f fuggveny ertekei az [a,b] intervallumban
% n pontban, az a+i*(b-a)/n, i=0,1,...,n alappontokban
% az eredmeny az y=[x,f(x)] tablazatban jelenik meg
%
% © Molnarka Gy''oz''o 1998; program a Matlab programozasa c. reszhez

k=(b-a)/n;
x=a:k:b;
z=eval(ff);
y=[x,z];