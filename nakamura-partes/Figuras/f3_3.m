% f3_3
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 3.3')

clear; clf; hold off
axis([-0.5,4.5,-4.2,0,-1,1])
view([0,90])
hold on
x=[ 1,1,1,-0.4,0,1,2,3,3,3];
y=-[1,1,1, 2,  3,4,3,2,2,2];
for i=1:3
for j=1:3
text(i-0.3,-j-0.2,0.5, ['A(',int2str(j),',',int2str(i),')'], ...
 'FontSize',[14])
end
end
xs=[0,3;0,3];
ys=[0,0;-3,-3];
zs=[1,1;1,1]*0.1;
%surf(xs,ys,zs)
colormap(hsv)



for L=1:6
if L==1, 
x=[ 1,1,1,-0.2,0,1,2,3,3,3];
y=-[1,1,1, 2,  3,4,3,2,2,2];
end
if L==2, 
x=[ 2,2,2,1,0.2,1,  2,3,3,3];
y=-[1,1,1,2,3.2,4.2,4.2,3,3,3];
end
if L==3, 
x=[ 3,3,3,2,1,0,0,0];
y=-[1,1,1,2,3,4,4,4];
end
if L==4, 
x=4-[ 1,1,1,-0.2,0,1,2,3,3,3];
y=-[1,1,1, 2,  3,4,3,2,2,2];
end
if L==5, 
x=4-[ 2,2,2,1,0.1,1,2,3,3,3];
y=-[1,1,1,2,3,4,4,3,3,3];
end
if L==6, 
x=4-[ 3,3,3,2,1,0,0,0];
y=-[1,1,1,2,3,4,4,4];
end
text(0,-0.5,'Dashed line: - sign', 'FontSize',[14])
text(2.4,-0.5,'Solid line: + sign', 'FontSize',[14])
 
m = length(y); plot([-1 4], [-1 2], '.');  
%xlabel('x'); ylabel('y'); % plot(x,y,'o')
for k=1:m
  z=int2str(k); xk = x(k); yk=y(k);
end
t = 0:0.25:1; t2=t.^2; t3=t.^3;
for i=2:m-2
   yb = 1/6*((1-t).^3*y(i-1) + (3*t3-6*t2+4)*y(i) + ...
        (-3*t3 + 3*t2 + 3*t + 1)*y(i+1) + t3*y(i+2) );
   xb = 1/6*((1-t).^3*x(i-1) + (3*t3-6*t2+4)*x(i) +  ...
        (-3*t3 + 3*t2 + 3*t + 1)*x(i+1) + t3*x(i+2) );
 if L<4  plot(xb,yb,'--');end
 if L>3  plot(xb,yb);end
end
end
axis('off')
%title(' Spaghetti Rule ')


