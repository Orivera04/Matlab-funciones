% L2_8   Graph not shown in the book. 
% Illustration of semilog plot.
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Graph plotted by List 2.8')

clear,clf,hold off
t = .1:.1:3;
semilogy(t,exp(t.*t))
grid
xlabel('t'); ylabel('exp(t.*t)');

