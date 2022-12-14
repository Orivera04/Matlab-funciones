% fig10_17
% Copyright S. Nakamura, 1995
figure(1)
set(gcf,'NumberTitle','off','Name','Figure 10.17')
clg,clear
hold off
%axis('square')
axis([-0.3,4,-0.5,2.5]);
hold on
%battery_(0.1, 0.2, [0.0, 0], [0.0, 2]);
text(0-0.2 ,0, 'B')

text(0-0.2,2, 'A')
switch_(0.5, 1, [0,0], [2,0]);
capacit_(0.1, 0.3, [2,0], [2,1])
resist_(6,0.5,   0.2, [2,1], [2,2]);
coil_b(6,0.4, 0.07, [0,2],[2.,2]);
%coil_trad(4, 0.3, [0.8,2],[2.2,2]);
line_([2,0],[3.5,0]) 

resist_(6,0.5,   0.1, [2,2], [3.5,2]);
coil_b(6,0.4, 0.07, [3.5,2],[3.5,0]);
text(2+0.19, 0.5,'C')
text(2+0.19, 1.5,'Ra')
text(0.9,-0.3,'S')
text(3.7,1,'Lb')
text(1., 2.2, 'La')
text(2.7, 2.2, 'Rb')
text(-0.1, 1.0,'e(t)')
text( 0.5,2.-0.2, 'i1(t)'); arrow_(0.4, [0.8, 2-0.2], [1.2, 2-0.2] )
text( 2.3,2.-0.2, 'i2(t)');arrow_(0.4, [2.6, 2-0.2], [3.0, 2-0.2] )
 axis('off')

line_([0,0], [0,0.8])
line_([0,1.2], [0,2])
ellip_( 0, 1, 0.3, 0.2)

