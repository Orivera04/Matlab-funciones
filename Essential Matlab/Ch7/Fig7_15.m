a = 2;
q = 1.25;
th = 0:pi/40:5*pi;
subplot(2,2,1)
axis off
plot(a*th.*cos(th), a*th.*sin(th), 'k'), ...
     title('(a) Archimedes')    % or use polar
axis off
subplot(2,2,2)
plot(a/2*q.^th.*cos(th), a/2*q.^th.*sin(th), 'k'), ...
     title('(b) Logarithmic')   % or use polar
axis off