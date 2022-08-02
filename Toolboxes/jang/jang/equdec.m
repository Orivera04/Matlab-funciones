%======= decision surfaces, including consideration for data density

% Roger Jang, Aug-11-1995

figure;
load equdensi.mat
density = zz;

subplot(2,3,1);
load optideci.mat
pcolor(xx, yy, uu);
axis square; colormap(cool); shading interp
xlabel('x(t)'); ylabel('x(t-1)'); title('Optimal Boundary');
hold on
% plotting boundary as a contour
[junk lineH] = contour(xx, yy, density, [-realmax 0.05 realmax], 'y');
set(lineH, 'linewidth', 3, 'linestyle', '-'); 
hold off

subplot(2,3,2);
load equ2.mat
pcolor(xx, yy, uu);
axis square; colormap(cool); shading interp
xlabel('x(t)'); ylabel('x(t-1)'); title('4-Rule ANFIS Boundary');
hold on
% plotting boundary as a contour
[junk lineH] = contour(xx, yy, density, [-realmax 0.05 realmax], 'y');
set(lineH, 'linewidth', 3, 'linestyle', '-'); 
hold off

subplot(2,3,3);
load equ3.mat
pcolor(xx, yy, uu);
axis square; colormap(cool); shading interp
xlabel('x(t)'); ylabel('x(t-1)'); title('9-Rule ANFIS Boundary');
hold on
% plotting boundary as a contour
[junk lineH] = contour(xx, yy, density, [-realmax 0.05 realmax], 'y');
set(lineH, 'linewidth', 3, 'linestyle', '-'); 
hold off
