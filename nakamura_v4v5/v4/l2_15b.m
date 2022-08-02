% L2_15B : Figure 2.10 
% Pressure ratio vs. Mach number
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 2.10; List 2.15B')

clear; clf; hold off;
M = [0:0.01:1]';
k=1.4;
p0_over_p = (1 + (k-1)/2*M.^2).^(k/(k-1));
hold on
axis('square');                 %makes graph square
plot(M,p0_over_p)
xlabel('Mach number, M')
ylabel('p0/p')
title('Pressure ratio, p(stagnation)/p(static)')
text(0.45, 1.55, 'Compressible')
Mb= [0: 0.01: 0.7]';
p0_over_pb = 1 + k/2*Mb.^2;
plot(Mb,p0_over_pb,'--')
text(0.5, 1.1, 'Incompressible')

