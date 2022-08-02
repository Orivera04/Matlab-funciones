% f10_24
% Copyright S. Nakamura, 1995
figure(1)
set(gcf,'NumberTitle','off','Name','Figure10.24')

clear
p1 = [0. ,10];
p2 =[0.0,9.5];
p3=[0.0, 7.5];
p4=[0,7];
p5=[0,6];
clg
h1=[-3,10];
h2 = [3,10];
axis('square')
axis([-5,5,5,10.5])
hold on
d2 = p2 +[-.5, 0];
d3 = p3 +[-.5, 0];

coil_a(5,0.3,  0.3, p3+[.5,0],p2+[.5,0])
d2 = p2 +[-.5, 0];
d3 = p3 +[-.5, 0];
damper_( 0.3, d3-[.0,0],d2-[.0,0])
%spring_(15, 0.5, p2,p3)
line_(p3, p4)
line_(p3+[-.5, 0], p3+[.5,0])
line_(p2+[-.5, 0], p2+[.5,0])
line_(p1,p2)
line_([-4,10], [4,10])


box_(1.2,p4,p5)
p6 = [0,6] - [0,0.5];
text(0,5.3, 'F(t)')
arrow_(0.5, p5,p6)
%title(' X10_7Fig.m')
a0 = [-2,7.5];
a1=[-2,6.5];
a2=[-2,6];
arrow_d(0.5, a1,a2)
%line_dot(a0,a1)
L1= [-2.2,6];
L2= [0,6];
line_dot(L1,L2)
L1= [-2.5,6.5];
L2= [-1,6.5];
line_dot(L1,L2)
text(-2.2, 5.7, 'y(t)')
text(1.4,6.5,'M=5 kg')
text(1.4,8.5,'k=3.2 N/m')
%text(-1.5,8.5,'B ')
text(-4, 6.5,'y(0)=0')
axis('off')
