% Illustration of 2D MFs
% J.-S. Roger Jang, 1993

colormap(gray);
xx = -10:1:10;
yy = -10:1:10;
trap_xx = trap_mf(xx, [-6, -2, 2, 6]);
trap_yy = trap_mf(yy, [-6, -2, 2, 6]);
[trap_x,trap_y]=meshgrid(trap_xx, trap_yy);
[x,y]=meshgrid(xx, yy);

subplot(2,2,1); surfl(x, y, min(trap_x,trap_y),[-20, 30]);
xlabel('X'); ylabel('Y'); title('(a) z = min(trap(x), trap(y))');
set(gca, 'box', 'on');
subplot(2,2,2); surfl(x, y, max(trap_x,trap_y), [-20, 30]);
xlabel('X'); ylabel('Y'); title('(b) z = max(trap(x), trap(y))');
set(gca, 'box', 'on');

bell_xx = gbell_mf(xx, [4, 3, 0]);
bell_yy = gbell_mf(yy, [4, 3, 0]);
[bell_x,bell_y]=meshgrid(bell_xx, bell_yy);
[x,y]=meshgrid(xx, yy);

subplot(2,2,3); surfl(x, y, min(bell_x,bell_y), [-20, 30]);
xlabel('X'); ylabel('Y'); title('(c) z = min(bell(x), bell(y))');
set(gca, 'box', 'on');
subplot(2,2,4); surfl(x, y, max(bell_x,bell_y), [-20, 30]);
xlabel('X'); ylabel('Y'); title('(d) z = max(bell(x), bell(y))');
set(gca, 'box', 'on');
