% f2_9 same as L2_15A   
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 2.9; List 2.15A')

clear,clf,hold off
M = [0: 0.01: 1]';k=1.4;
p0_over_p = (1 + (k-1)/2*M.^2).^(k/(k-1));
plot(M,p0_over_p)
xlabel('M, Mach number')
ylabel('p0/p')
title('Pressure ratio, p(stagnation)/p(static)')

