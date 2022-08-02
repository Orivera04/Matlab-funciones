% f2_32 plots Figure 2.32
% Copyright S. Nakamura, 1995
close
set(gcf, 'NumberTitle','off','Name', 'Figure 2.32')
clear,clf, hold off
axis([0,9,0,8])
hold on
p1=[2,4]; p2 = [6,4];
n = 6; u = 0.5; w=0.5;
coil_b(n,u,w, p1,p2)
hold off
