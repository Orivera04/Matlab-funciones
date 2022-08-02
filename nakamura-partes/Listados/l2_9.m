% L2_9: Illustration of semilogx 
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Plotted by List 2.9')

clear,clf,hold off
t = .1:.1:3;
semilogx(t,exp(t.*t))
grid
xlabel('t'); ylabel('exp(t.*t)');

