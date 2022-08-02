% fig10_1
% Copyright S. Nakamura, 1995
figure(1)
set(gcf,'NumberTitle','off','Name','Figure 10.1')

clf,clear
hold off
%axis('square')
axis([-0.5,4,-0.5,2.7]);
hold on
battery_(0.07, 0.3, [0.0, 0], [0.0, 2]);

switch_(0.2,0.7,  [0,0], [3,0]);
resist_(7,0.4,  0.1, [3,0], [3,2]);
coil_a(4,0.2,  0.10, [0,2],[3,2]);

text(1.4,-0.5,'   S','FontSize',[18])
text(3.5,1,'R','FontSize',[18])
text(1.5, 2.4, 'L','FontSize',[18])
text(0.3, 0.7,'Es','FontSize',[18])
text(-0.1,2.2, 'I(t)   ','FontSize',[18])
arrow_(0.3,[0.4,2.2] , [0.8,2.2])
axis('off')

%text(1.2,-0.5,'S.W.')
%text(3.5,1,'R=20 kohm')
%text(1.0, 2.4, 'L=30 mH')
%text(0.1, 0.5,'Es=10 V')
%text(-0.1,2.1, 'i(t)   -> ')

%w=0.4; n=6;x0=-1;y0=-1; x1=0;y1=0;
%coil(n,w, x0,x1,y0,y1);
%w=0.4; n=8;x0=1;y0=1; x1=2;y1=2;
%resist(n,w, x0,x1,y0,y1);
%print x10_3e_diag.ps

