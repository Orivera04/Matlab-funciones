% f10_23
% Copyright S. Nakamura, 1995
figure(1)
set(gcf,'NumberTitle','off','Name','Figure10.23')

clg,clear
hold off
%axis('square')
axis([-0.5,4.5,-0.3,2.5]);
hold on
battery_(0.06, 0.3, [0.0, 0], [0.0, 2]);

switch_(0.5, 1, [0,0], [1.5,0]);
%capacitor_(0.1, 0.3, [1.5,0], [3,0])
line_([1.5,0], [3,0])
resist_(6,0.3,   0.2, [3,0], [3,2]);
coil_b(6,0.4, 0.07, [0,2],[3,2]);
%coil_trad(4, 0.3, [0.8,2],[2.2,2]);
line_([0,2],[0.8,2]) 

%text(2+0.19,-0.5,'C')
text(0.8,-0.2,'S','FontSize',[24])
text(3.3,1,'R = 20 k','FontSize',[24])
text(1.5, 2.4, 'L = 100 mH','FontSize',[24])
text(0.2, 0.8,'E = 10 V','FontSize',[24])
text(-0.1,2.2, 'I(t)   -> ','FontSize',[24])
axis('off')
h1=text(4.4538,   0.9997, 'W');
set(h1,'FontName','symbol','FontSize',[24])
