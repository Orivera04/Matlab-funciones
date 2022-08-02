% L9_4 same as fig9_8 
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 9.8; List 9.4')

clear; clf; hold off
y = [0 0 0 1    1 0 0   1 1 1];
x = [0 0 0 0.2  1 2 2.8 3 3 3];
m = length(y); plot([-1 4], [-1 2], '.'); hold on
xlabel('x'); ylabel('y');  plot(x,y,'o')
for k=3:8
if k==3, z=int2str(k); xk = x(k); yk=y(k); text(xk+0.1,yk,'1, 2, 3');

elseif k==8,z=int2str(k); xk = x(k); yk=y(k); text(xk+0.1,yk, ...
'8, 9, 10');
elseif k>3 & k<8,
  z=int2str(k); xk = x(k); yk=y(k); text(xk+0.1,yk,z)
end
end
t = 0:0.2:1; t2=t.^2; t3=t.^3;
for i=2:m-2
   yb = 1/6*((1-t).^3*y(i-1) + (3*t3-6*t2+4)*y(i) + ...
        (-3*t3 + 3*t2 + 3*t + 1)*y(i+1) + t3*y(i+2) );
   xb = 1/6*((1-t).^3*x(i-1) + (3*t3-6*t2+4)*x(i) +  ...
        (-3*t3 + 3*t2 + 3*t + 1)*x(i+1) + t3*x(i+2) );
   plot(xb,yb)
end
text (-0.6,2.2, 'Cubic b-spline curve on x-y plane', ...
'FontSize',[18])

%print fig9d6.ps
