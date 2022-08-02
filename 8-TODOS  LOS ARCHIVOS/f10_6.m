% f10_6
% Copyright S. Nakamura, 1995
figure(1)
set(gcf,'NumberTitle','off','Name','Figure 10.6')

clf,clear
hold off
%axis('square')
axis([-0.5,4,-1.,2.5]);
hold on
battery_(0.07, 0.3, [0.0, 0], [0.0, 2]);

switch_(0.5, 1, [0,0], [1.5,0]);
capacit_(0.1, 0.3, [1.5,0], [3,0])
resist_(6,0.3,   0.2, [3,0], [3,2]);
coil_b(6,0.4, 0.07, [0,2],[3,2]);
%coil_trad(4, 0.3, [0.8,2],[2.2,2]);
line_([0,2],[0.8,2]) 

text(2+0.19,-0.5,'C = 10\mu F','FontSize',[16])
text(0.55,-0.5,'S','FontSize',[16])
text(3.3,1,'R = 100 \Omega','FontSize',[16])

text(1.5, 2.4, 'L = 200 mH','FontSize',[16])
text(0.3, 0.8,'E = 1V DC','FontSize',[16])
text(-0.1,2.2, 'i(t)','FontSize',[16])
arrow_(0.5, [0.3,2.2],[0.7, 2.2])
axis('off')
% h0=text(2.8152,   -0.5089, 'm');
% set(h0,'FontName','Symbol', 'FontSize',[16])
%h1=text(3.9792,    0.9899, 'W');
%set(h1,'FontName','Symbol', 'FontSize',[16])

%print x10_8e_diag.ps
