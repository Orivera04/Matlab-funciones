%	This file displays four t-norm operators

%	Copyright by Jyh-Shing Roger Jang, 6-22-93.

colormap('default');

xx = 0:1:20;
yy = 0:1:20;
aa = 0:0.05:1;
bb = 0:0.05:1;

%bell_x = gbell_mf(xx, [4, 3, 10]);
%bell_y = gbell_mf(yy, [4, 3, 10]);
bell_x = trap_mf(xx, [3, 8, 12, 17]);
bell_y = trap_mf(yy, [3, 8, 12, 17]);

[x,y] = meshgrid(bell_x, bell_y);
[a,b] = meshgrid(aa, bb); % a = mu(x), b = mu(y);

subplot(2,2,1); mesh(aa, bb, min(a, b));
view(-15, 30); xlabel('a'); ylabel('b');
set(gca, 'box', 'on');
title('(a) Min');
subplot(2,2,3); mesh(xx, yy, min(x, y));
view(-15, 30); xlabel('X = x'); ylabel('Y = y');
set(gca, 'box', 'on');

subplot(2,2,2); mesh(aa, bb, a.*b);
view(-15, 30); xlabel('X = a'); ylabel('Y = b');
set(gca, 'box', 'on');
title('(b) Algebraic Product');
subplot(2,2,4); mesh(xx, yy, x.*y);
view(-15, 30); xlabel('X = x'); ylabel('Y = y');
set(gca, 'box', 'on');

figure;

subplot(2,2,1); mesh(aa, bb, max(0, a+b-1));
view(-15, 30); xlabel('X = a'); ylabel('Y = b');
set(gca, 'box', 'on');
title('(c) Bounded Product');
subplot(2,2,3); mesh(xx, yy, max(0, x+y-1));
view(-15, 30); xlabel('X = x'); ylabel('Y = y');
set(gca, 'box', 'on');

z1 = zeros(size(a));
z1(find(b==1)) = a(find(b==1));
z1(find(a==1)) = b(find(a==1));
z2 = zeros(size(x));
z2(find(x==1)) = y(find(x==1));
z2(find(y==1)) = x(find(y==1));
subplot(2,2,2); mesh(aa, bb, z1);
view(-15, 30); xlabel('X = a'); ylabel('Y = b');
set(gca, 'box', 'on');
title('(d) Drastic Product');
subplot(2,2,4); mesh(xx, yy, z2);
view(-15, 30); xlabel('X = x'); ylabel('Y = y');
set(gca, 'box', 'on');
