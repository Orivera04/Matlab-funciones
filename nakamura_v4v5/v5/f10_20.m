% fig10_20 same as L10_12 
% Copyright S. Nakamura, 1995
figure(1)
set(gcf,'NumberTitle','off','Name','Figure 10.20; List 10.12')
clear, clf
while 1
  y2 = input('Type gradient, y2(0); or -99999 to quit:  ');
  if y2 < -88888, close, break, end
  A = 0.0001; P=0.01; hc = 120; k = 60; b=293;
  a=P*hc/A/k;
  n=1; x(1)=0; h = 0.01;
  y(:,1) = [493;y2];
   while x<=0.3
     k1 = h*f_shoot(y(:,n),      x(n),     a,b);
     k2 = h*f_shoot(y(:,n)+k1/2, x(n)+h/2, a,b);
     k3 = h*f_shoot(y(:,n)+k2/2, x(n)+h/2, a,b);
     k4 = h*f_shoot(y(:,n)+k3,   x(n)+h,   a,b);
     y(:,n+1) = y(:,n) + (1/6)*(k1 + 2*k2 + 2*k3 + k4);
     x(n+1) = n*h;
     if (x(n)-0.2001)*(x(n)-0.1999)<0
        y2_end = y(2,n+1); break,
     end
     n=n+1;
   end
% y2_end=(y(1,n+1)-y(1,n))/h;
  plot(x,y(1,:), '-', x,y(2,:)/10,':');
  xlabel('x (s)'), ylabel(' y : -   and v/10 : ...')
  text(0.15, -200, ['y2(0.2)=', num2str(y2_end)] )
  text(0.02, -200, ['Guess for y2(0)=', num2str(y2)] )
  text(x(10),  y(1,10)-20, 'y1(x)' )
  text(x(10),  y(2,10)/10-20  , 'y2(x)/10' )
 axis([0,0.2,-300,500])
end

