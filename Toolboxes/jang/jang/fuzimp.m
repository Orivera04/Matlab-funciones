%	This file displays different fuzzy implication functions and
%	the resulting fuzzy relations

%	Copyright by Jyh-Shing Roger Jang, 6-2-93.

xx = 0:1:20;
yy = 0:1:20;
aa = 0:0.05:1;
bb = 0:0.05:1;

bell_x = gbell_mf(xx, [4, 3, 10]);
bell_y = gbell_mf(yy, [4, 3, 10]);

[x,y] = meshgrid(bell_x, bell_y);
[a,b] = meshgrid(aa, bb); % a = mu(x), b = mu(y);

subplot(221); mesh(aa, bb, min(a, b));
view(-15, 30); xlabel('X = a'); ylabel('Y = b'); set(gca, 'box', 'on');
title('(a) Min');
subplot(223); mesh(xx, yy, min(x, y));
view(-15, 30); xlabel('X = x'); ylabel('Y = y');

subplot(222); mesh(aa, bb, a.*b);
view(-15, 30); xlabel('X = a'); ylabel('Y = b'); set(gca, 'box', 'on');
title('(b) Algebraic Product');
subplot(224); mesh(xx, yy, x.*y);
view(-15, 30); xlabel('X = x'); ylabel('Y = y');

figure;

subplot(221); mesh(aa, bb, max(0, a+b-1));
view(-15, 30); xlabel('X = a'); ylabel('Y = b'); set(gca, 'box', 'on');
title('(c) Bounded Product');
subplot(223); mesh(xx, yy, max(0, x+y-1));
view(-15, 30); xlabel('X = x'); ylabel('Y = y');

z1 = zeros(size(a));
z1(find(b==1)) = a(find(b==1));
z1(find(a==1)) = b(find(a==1));
z2 = zeros(size(x));
z2(find(x==1)) = y(find(x==1));
z2(find(y==1)) = x(find(y==1));
subplot(222); mesh(aa, bb, z1);
view(-15, 30); xlabel('X = a'); ylabel('Y = b'); set(gca, 'box', 'on');
title('(d) Drastic Product');
subplot(224); mesh(xx, yy, z2);
view(-15, 30); xlabel('X = x'); ylabel('Y = y');

figure;

subplot(221);
mesh(aa, bb, min(1, 1-a+b));
view(-15, 30); xlabel('X = a'); ylabel('Y = b'); set(gca, 'box', 'on');
title('(a) Zadeh''s Arithmetic Rule');
subplot(223);
mesh(xx, yy, min(1, 1-x+y));
view(-15, 30); xlabel('X = x'); ylabel('Y = y');

subplot(222);
mesh(aa, bb, max(min(a,b), 1-a));
view(-15, 30); xlabel('X = a'); ylabel('Y = b'); set(gca, 'box', 'on');
title('(b) Zadeh''s Max-Min Rule');
subplot(224);
mesh(xx, yy, max(min(x,y), 1-x));
view(-15, 30); xlabel('X = x'); ylabel('Y = y');

figure;

subplot(221); mesh(aa, bb, max(1-a, b));
view(-15, 30); xlabel('X = a'); ylabel('Y = b'); set(gca, 'box', 'on');
title('(c) Boolean Fuzzy Implication');
subplot(223); mesh(xx, yy, max(1-x, y));
view(-15, 30); xlabel('X = x'); ylabel('Y = y');

z1 = zeros(size(a));
z1(find(a<=b)) = ones(size(find(a<=b)));
z1(find(a>b)) = b(find(a>b))./a(find(a>b));
z2 = zeros(size(x));
z2(find(x<=y)) = ones(size(find(x<=y)));
z2(find(x>y)) = y(find(x>y))./x(find(x>y));
subplot(222); mesh(aa, bb, z1);
view(-15, 30); xlabel('X = a'); ylabel('Y = b'); set(gca, 'box', 'on');
title('(d) Goguen''s Fuzzy Implication');
subplot(224); mesh(xx, yy, z2);
view(-15, 30); xlabel('X = x'); ylabel('Y = y');
