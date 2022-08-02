%	Animation of membership functions composed of two sigmoid functions.

%	Copyright (c) 1993 Jyh-Shing Roger Jang, U. C. Berkeley
%	jang@eecs.berkeley.edu
%	Permission is granted to modify and re-distribute this code
%	in any manner as long as this notice is preserved.
%	All standard disclaimers apply.

%	Roger Jang, 6-5-93.
%	Roger Jang, 12-20-95.

clc; echo on;
% This program shows how to construct MF's from the abs. difference and
% the product of two sigmoidal functions. 
echo off;

set(gcf, 'position', [10 344 560 620]);
x = (-10:0.2:10)';
subplot(311); h1 = plot(x, nan*[x x]);
set(h1,'erasemode','background')
title('Two sigmoidal MFs');
axis([-10 10 0 1]);
set(gca, 'xticklabels', []);

subplot(312); h2 = plot(x, nan*x, 'r-', x, nan*x, 'co');
axis([-10 10 0 1]);
title('Absolute difference of two sigmoidal MFs');
set(h2,'erasemode','xor')
set(gca, 'xticklabels', []);

subplot(313); h3 = plot(x, nan*x, 'g-', x, nan*x, 'yo');
axis([-10 10 0 1]);
title('Product of two sigmoidal MFs');
set(h3,'erasemode','xor')
set(gca, 'xticklabels', []);

stop = 0;
stopH = uicontrol('string', 'Stop', 'callback', 'stop=1;', 'inter', 'yes');

i = 0;
while ~stop,
	i = i+0.04;
	a1 = 4*sin(i);
	c1 = 8*cos(i);
	a2 = 4*sin(i+pi/2);
	c2 = -8*cos(i);
	y1 = sig_mf(x, [a1, c1]);
	y2 = sig_mf(x, [a2, c2]);
	y3 = abs(y2 - y1);
	y4 = y1.*y2;
	set(h1(1), 'YData', y1)
	set(h1(2), 'YData', y2)
	set(h2, 'YData', y3)
	set(h3, 'YData', y4)
	drawnow
end
