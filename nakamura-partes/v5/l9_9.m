% L9_9 same as f9_15 
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 9.15; List 9.9')

clear,clf
x_af=[1.0000  0.6638  0.4397  0.2900  0.1896  0.1221  ...
      0.0765  0.0455  0.0243  0.0099       0 ];
y_af=[0.0021  0.0668  0.0939  0.1000  0.0946  0.0836  ...
      0.0705  0.0569  0.0431  0.0282       0 ];
m=length(x_af);
x = [x_af, x_af(m-1:-1:1)];  % Whole airfoil profile
y = [y_af, -y_af(m-1:-1:1)];
plot(x,y+0.3)
hold on
plot(x_af,y_af+0.3,'or')
axis([-0.1, 1.1 ,-0.6, 0.6])
n=length(x);
arc(1)=0;  % Arc length measured from trailing edge
for i=2:n
   arc(i)=arc(i-1)+sqrt((x(i)-x(i-1))^2+(y(i)-y(i-1))^2);
end
L = arc(m);
s = stret_(15+1, L,  0.02, 0.02);
xcut=interp1(arc, x, s, 'spline');  % c-spline
ycut=interp1(arc, y, s, 'spline');  % c-spline
plot(x,y-0.3)
plot(xcut,ycut-0.3,'x')
axis([-0.3, 1.1 ,-0.6, 0.6])
text(-0.1, 0.1, 'o: given data points','Fontsize',[18])
text(-0.1,-0.5, 'x: points to cut the surface','Fontsize',[18])
axis('off')

