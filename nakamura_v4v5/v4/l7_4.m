% L7_4: Newton Iteration 2D; See Example 7.9
% Copyright S. Nakamura, 1995
clear,clg, fprintf('\n')
dx = 0.01; dy = 0.01;
x = input('Initial guess for x? ');
y = input('Initial guess for y? ');
for n=1:50
  s = [x,y];
  xp = x + dx;
  yp = y + dy;
  J(1,1) = (f_f1(xp, y) - f_f1(x,y))/dx;
  J(1,2) = (f_f1(x, yp) - f_f1(x,y))/dy;
  J(2,1) = (f_f2(xp, y) - f_f2(x,y))/dx;
  J(2,2) = (f_f2(x, yp) - f_f2(x,y))/dy;
  f(1) = f_f1(x,y);
  f(2) = f_f2(x,y);
  ds = - J\f';
  x = x + ds(1);
  y = y + ds(2);
fprintf('n=%2.0f,  x=%12.5e,  y=%12.5e', n,x,y)
fprintf('f(1)=%10.2e, f(2)=%10.2e\n', f(1), f(2))
  if (abs(f(1))<1.0e-9 & abs(f(2))<1.0e-9), break; end
end

