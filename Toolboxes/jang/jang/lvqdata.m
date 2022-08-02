% LVQ data distribution

r = 1;
c1 = 0;
c2 = 2*r*exp(0); 
c3 = 2*r*exp(j*pi/2);
c4 = 2*r*exp(j*5*pi/6);
c5 = 2*r*exp(j*7*pi/6);
c6 = 2*r*exp(j*3*pi/2);

point_n = 50;
k = 2;
x1 = (randn(point_n,1) + j*randn(point_n, 1))/k + c1*ones(point_n,1);
x2 = (randn(point_n,1) + j*randn(point_n, 1))/k + c2*ones(point_n,1);
x3 = (randn(point_n,1) + j*randn(point_n, 1))/k + c3*ones(point_n,1);
x4 = (randn(point_n,1) + j*randn(point_n, 1))/k + c4*ones(point_n,1);
x5 = (randn(point_n,1) + j*randn(point_n, 1))/k + c5*ones(point_n,1);
x6 = (randn(point_n,1) + j*randn(point_n, 1))/k + c6*ones(point_n,1);

class1 = [x1; x2];
class2 = [x3; x4; x5; x6];
blackbg;
subplot(2,2,1);

h = plot(real(class1), imag(class1), 'x', real(class2), imag(class2), 'o');
set(h, 'markersize', 4);
axis equal; axis square
hold on

line(real(c1), imag(c1), 'linestyle', 'x', ...
	'markersize', 5, 'linewidth', 2,'color','w'); 
line(real(c2), imag(c2), 'linestyle', 'x', ...
	'markersize', 5, 'linewidth', 2,'color','w'); 
line(real(c3), imag(c3), 'linestyle', 'o', ...
	'markersize', 5, 'linewidth', 2,'color','w'); 
line(real(c4), imag(c4), 'linestyle', 'o', ...
	'markersize', 5, 'linewidth', 2,'color','w'); 
line(real(c5), imag(c5), 'linestyle', 'o', ...
	'markersize', 5, 'linewidth', 2,'color','w'); 
line(real(c6), imag(c6), 'linestyle', 'o', ...
	'markersize', 5, 'linewidth', 2,'color','w'); 

text(real(c1)+0.2, imag(c1), 'C1', 'fontweight', 'bold');
text(real(c2)+0.2, imag(c2), 'C2', 'fontweight', 'bold');
text(real(c3)+0.2, imag(c3), 'C3', 'fontweight', 'bold');
text(real(c4)+0.2, imag(c4), 'C4', 'fontweight', 'bold');
text(real(c5)+0.2, imag(c5), 'C5', 'fontweight', 'bold');
text(real(c6)+0.2, imag(c6), 'C6', 'fontweight', 'bold');

hold off

bound = axis;
xmax = max(abs(bound(1)), bound(2));
ymax = max(abs(bound(3)), bound(4));
axis([-xmax xmax -ymax ymax]);

boundary = [xmax+j*ymax;
	r*sqrt(2)*exp(j*pi/4);
	r/sqrt(3)*2*exp(j*2*pi/3);
	r/sqrt(3)*2*exp(j*3*pi/3);
	r/sqrt(3)*2*exp(j*4*pi/3);
	r*sqrt(2)*exp(-j*pi/4);
	xmax-j*ymax];
line(real(boundary), imag(boundary), 'linestyle', '-', 'color', 'w');

text(-3, 2.5, 'Class 1', 'fontweight', 'bold');
text(2.0, -1.5, 'Class 2', 'fontweight', 'bold');
set(gca, 'xtick', []);
set(gca, 'ytick', []);

xlabel('x1');
ylabel('x2');
