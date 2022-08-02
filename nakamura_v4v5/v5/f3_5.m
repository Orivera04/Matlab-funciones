% f3_5
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 3.5')

clear
p0 = [-1,0];
p1 = [2,0];
p2 =[2,0];
p3=[2,2];
p4=[2,3];
p5=[2,4];
p6=[2,5];
p7=[2,6.5];
p8=[2,7];
clf%axis('square')
axis([-0,4,1.9, 6.5])
hold on
box_(0.5,p3,p4)     ;, text(2.3,0,'M2','FontSize',[14])
box_(0.5,p5,p6)     ;, text(4.3,0,'M3')
%coil_(5,0.4, 0.1, p2+[0.,0.1],p3+[0.,00.1])

%b=(p2+[0.,0.1]+p3+[0.,00.1])/2
%text(b(1)-0.1,b(2)+0.1, 'K1')


coil_a(3,0.4, 0.1, p4,p5)
b=(p4+[0.,0.]+p5+[0.,00.])/2;
text(b(1)-0.4,b(2)+0.1, 'k12','FontSize',[14])

coil_a(4,0.4,  0.06, p6+[0.,0.0],p7+[0.,0.0])
b=(p6+[0.,0.1]+p7+[0.,00.1])/2;
text(b(1)-0.4,b(2)+0.1, 'k01','FontSize',[14])



%title(' spring_mass_diag')
a1=[1,6.5];
a2=[3,6.5];
line_(a1,a2);


p0 = [2.5,4.5];
p1 = [2.5,4];
arrow_(0.2,p0,p1)
text( 2.7, 4,'y1(displacement)','FontSize',[14])
text(1.9,4.5,'m1','FontSize',[18])

p0 = [2.5,2.3];
p1 = [2.5,2];
arrow_(0.3,p0,p1)
text( 2.7, 2,'y2(displacement)','FontSize',[14])

text(1.9,2.5,'m2','FontSize',[14])

a0 = [2, 4];
a1=  [2.6, 4];
line_dot(a0,a1)
b0 = [2.4,4.5];
b1 = [2.6,4.5];

line_(b0,b1)



a0 = [2, 2];
a1=  [2.6, 2];
line_dot(a0,a1)

b0 = [2.4,2.3];
b1 = [2.6,2.3];

line_(b0,b1)

axis('off')
