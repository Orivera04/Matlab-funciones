point_n = 20;
x = linspace(0, 1, point_n);
y = linspace(0, 1, point_n);
mfx = zmf(x, [0 1]);
mfy = smf(y, [0 1]);

[mfxx mfyy] = meshgrid(mfx, mfy);

blackbg;
subplot(2,2,1);
zz1 = mfxx.*mfyy;
surf(x, y, zz1);
xlabel('x'); ylabel('y');
view([-10 35]);
set(gca, 'box', 'on');

subplot(2,2,3);
pcolor(x, y, zz1);
hold on; conH1 = contour(x, y, zz1); hold off
shading interp; axis square;
xlabel('x'); ylabel('y');

subplot(2,2,2);
zz2 = min(mfxx, mfyy);
surf(x, y, zz2);
xlabel('x'); ylabel('y');
xlabel('x'); ylabel('y');
view([-10 35]);
set(gca, 'box', 'on');

subplot(2,2,4);
pcolor(x, y, zz2);
hold on; conH2 = contour(x, y, zz2); hold off
shading interp; axis square;
xlabel('x'); ylabel('y');

lineHndls=findobj(gcf,'Type','line');
set(lineHndls,'LineWidth',2, 'color', 'k');
