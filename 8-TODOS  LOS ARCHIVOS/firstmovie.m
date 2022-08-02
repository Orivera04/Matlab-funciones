
% Script file firstmovie.

% Graphs of y = sin(kx) over the interval [0, pi],
% where k = 1, 2, 3, 4, 5.

m = moviein(5);
x = 0:pi/100:pi;
for i=1:5
   h1_line = plot(x,sin(i*x));
   set(h1_line,'LineWidth',1.5,'Color','m')
   grid
   title('Sine functions sin(kx), k = 1, 2, 3, 4, 5')
   h = get(gca,'Title');
   set(h,'FontSize',12)
   xlabel('x')
   k = num2str(i);
   if i > 1
      s = strcat('sin(',k,'x)');
   else
      s = 'sin(x)';
   end
   ylabel(s)
   h = get(gca,'ylabel');
   set(h,'FontSize',12)
   m(:,i) = getframe;
   pause(2)
end
movie(m)
