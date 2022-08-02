% f7_9
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 7.9')

clg
axis([-0.8 2.3 -0.0 1.3])
hold on
p1 = [0, 1];
p2=[1,1];
p3 = [2, 1];
p4 = [0, 0];
p5=[1,0];
p6 = [2, 0];

resist_(5, 0.5,0.1, p1, p2)
resist_(5, 0.5,0.1, p2, p3)
resist_(8, 0.5,0.1, p2, p5)
resist_(8, 0.5,0.1, p3, p6)
line_(p4, p6)
text( 0.4, 1.2, 'R1','FontSize',[18])
text( 0.4, 0.9, 'I1 ','FontSize',[18])
arrow_(0.5, [0.5, 0.9], [0.7, 0.9])
text( 1.4, 0.9, 'I2 ','FontSize',[18])
arrow_(0.5, [1.5, 0.9], [1.7, 0.9])
text( 1.4, 1.2, 'R2','FontSize',[18])
text( 1.1, 0.5, 'R3','FontSize',[18])
text( 2.1, 0.5, 'R4','FontSize',[18])
text( 0.3, 0.5, '100 V','FontSize',[18])
battery_(0.07, 0.3, p4, p1)
axis('off')
%print nonlinResis.ps
