% f3_1
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 3.1')

clear, clf
subplot(211)
axis([-1.8 3.7 -0.5  1.5])
      hold on 
p1 = [0,1];
p2 = [1,1];
p3 = [2,1];
p4 = [3,1];
p5 = [0,0];
p6 = [1,0];
p7 = [2,0];

text(-0.3,  1.,  '20V')
text(-0.3,  0.,  '5V')
text(3.3,  1.,  '0V')
xlabel('(i)  An electric network of resistors')

 
resist_(5, 0.5,0.1,p1,p2)
resist_(5, 0.5,0.1,p2,p3)
resist_(5, 0.5,0.1,p3,p4)
resist_(5, 0.5,0.1,p5,p6)
line_(p6,p7)
resist_(5, 0.5,0.1,p2,p6)
resist_(5, 0.5,0.1,p3,p7)
text( 0.3, 1.3, '2 ohms')
text( 1.3, 1.3, '4 ohms')
text( 2.3, 1.3, '3 ohms')
text( 0.3, -0.3, '3 ohms')
text( 1.1, 0.5, '3 ohms')
text( 2.1, 0.5, '5 ohms')

text( 1.0-0.05, 1.1, 'a')
text( 2.0-0.05, 1.1, 'b')
text( 1.0-0.05, -0.1, 'c')
axis('off')

subplot(212)
hold off
axis([-3 3 -2 2.5])
hold on

p1 = [0,0]         ; text( 0-0.15, 0.2 ,'a')
p2 = [-1,0]        ; text( -1.2,0.05, 'b')
p3 = [-0.5,-2]     ; text( -0.6,-2.05, 'c')

p4 = [0.5, -1.7] ; text( 0.6, -1.7, 'd')
p5 = [1, 0.4];  % , text( 1.2, 0.4, '. . .')
p6 = [-0.1,1.9]  ; text(-0.15,2.2, 'k')
resist_(5, 0.5,0.15,p1,p2)
resist_(5, 0.5,0.05,p1,p3)
resist_(5, 0.5,0.05,p1,p4)
resist_(5, 0.5,0.15,p1,p5)
resist_(5, 0.5,0.05,p1,p6)
xlabel('(ii) A node connected to resistors')
axis('off')







