point_n = 21;
x = linspace(0, 1, point_n);
y = linspace(0, 1, point_n);
[xx, yy] = meshgrid(x, y);
input = [xx(:) yy(:)];
sigma_template = 1/(2*sqrt(2*log(2)));

sigma1 = sigma_template/2;
w1x = exp(-((input(:,1)-0)/sigma1).^2/2);
w2x = exp(-((input(:,1)-1)/sigma1).^2/2);
w1y = exp(-((input(:,2)-0)/sigma1).^2/2);
w2y = exp(-((input(:,2)-1)/sigma1).^2/2);
w1 = w1x.*w1y;
w2 = w1x.*w2y;
w3 = w2x.*w1y;
w4 = w2x.*w2y;
zz1 = (w1*0+w2*1+w3*1+w4*0)./(w1+w2+w3+w4);

sigma2 = sigma_template;
w1x = exp(-((input(:,1)-0)/sigma2).^2/2);
w2x = exp(-((input(:,1)-1)/sigma2).^2/2);
w1y = exp(-((input(:,2)-0)/sigma2).^2/2);
w2y = exp(-((input(:,2)-1)/sigma2).^2/2);
w1 = w1x.*w1y;
w2 = w1x.*w2y;
w3 = w2x.*w1y;
w4 = w2x.*w2y;
zz2 = (w1*0+w2*1+w3*1+w4*0)./(w1+w2+w3+w4);

sigma3 = sigma_template*3/2;
w1x = exp(-((input(:,1)-0)/sigma3).^2/2);
w2x = exp(-((input(:,1)-1)/sigma3).^2/2);
w1y = exp(-((input(:,2)-0)/sigma3).^2/2);
w2y = exp(-((input(:,2)-1)/sigma3).^2/2);
w1 = w1x.*w1y;
w2 = w1x.*w2y;
w3 = w2x.*w1y;
w4 = w2x.*w2y;
zz3 = (w1*0+w2*1+w3*1+w4*0)./(w1+w2+w3+w4);

zz1 = reshape(zz1, point_n, point_n);
zz2 = reshape(zz2, point_n, point_n);
zz3 = reshape(zz3, point_n, point_n);
v_angle = [20 60];

subplot(2,3,1); mesh(xx, yy, zz1);
axis([-inf inf -inf inf -inf inf]); view(v_angle);
xlabel('x'); ylabel('y');
title(['s=' num2str(sigma1)], 'fontname', 'symbol');
subplot(2,3,2); mesh(xx, yy, zz2);
axis([-inf inf -inf inf -inf inf]); view(v_angle);
xlabel('x'); ylabel('y');
title(['s=' num2str(sigma2)], 'fontname', 'symbol');
subplot(2,3,3); mesh(xx, yy, zz3);
axis([-inf inf -inf inf -inf inf]); view(v_angle);
xlabel('x'); ylabel('y');
title(['s=' num2str(sigma3)], 'fontname', 'symbol');

subplot(2,3,4); pcolor(xx, yy, zz1); axis square;
xlabel('x'); ylabel('y'); shading interp;
subplot(2,3,5); pcolor(xx, yy, zz2); axis square;
xlabel('x'); ylabel('y'); shading interp;
subplot(2,3,6); pcolor(xx, yy, zz3); axis square;
xlabel('x'); ylabel('y'); shading interp;

set(findobj(gcf, 'type', 'axes'), 'box', 'on');
colormap(gray);
