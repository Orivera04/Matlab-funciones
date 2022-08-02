%======= decision surfaces, including consideration for data density

% Roger Jang, Aug-11-1995

figure;
load optideci.mat
opti = uu;

load equdensi.mat
density = zz;

subplot(2,2,1);
surf(xx, yy, opti.*density);
axis([-inf inf -inf inf -1 1]);
view([-20 70]);
set(gca, 'box', 'on');
title_str = 'optimal decision surface';
xlabel('x(t)'); ylabel('x(t-1)'); title('optimal decision surface');

subplot(2,2,2);
load equ2.mat
surf(xx, yy, uu.*density);
axis([-inf inf -inf inf -1 1]);
view([-20 70]);
set(gca, 'box', 'on');
title_str = 'optimal decision surface';
xlabel('x(t)'); ylabel('x(t-1)'); title('optimal decision surface');

subplot(2,2,3);
load equ3.mat
surf(xx, yy, uu.*density);
axis([-inf inf -inf inf -1 1]);
view([-20 70]);
set(gca, 'box', 'on');
title_str = 'optimal decision surface';
xlabel('x(t)'); ylabel('x(t-1)'); title('optimal decision surface');

subplot(2,2,4);
load equ4.mat
surf(xx, yy, uu.*density);
axis([-inf inf -inf inf -1 1]);
view([-20 70]);
set(gca, 'box', 'on');
title_str = 'optimal decision surface';
xlabel('x(t)'); ylabel('x(t-1)'); title('optimal decision surface');
