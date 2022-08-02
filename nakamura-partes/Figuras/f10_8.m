% f10_8
% Copyright S. Nakamura, 1995
figure(1)
set(gcf,'NumberTitle','off','Name','Figure 10.8')

%  x10_9diag.m  
clf,clear
hold off
%axis('square')
axis([-0.5,4,-0.4,2.5]);
axis('off')
hold on
battery_(0.07, 0.3, [0.0, 0.], [0.0, 2]);
switch_(0.2, 0.7 , [0.,0], [3,0]);
resist_(6, 0.3,  0.1, [3,0], [3,2]);
coil_a(5,0.3,   0.07,  [3.,2],[0.,2]);

%text(2-0.05,-0.7,'C')
text(1.5,-0.2,'S','FontSize',[18])
text(3.3,1,'R=20\Omega ','FontSize',[18])
text(1.2, 2.4, 'L=50 mH','FontSize',[18])
text(0.4, .8,'E=10V DC','FontSize',[18])
text(-0.1,2.2, 'I(t) ','FontSize',[18])
arrow_(0.5, [0.3,2.2],[0.7, 2.2])


axis('off')
%h2=text(3.8233,    0.9692, 'W');
%set(h2,'FontName','symbol','FontSize',[18]) 
%text(1.2,-0.5,'S.W.')
%text(3.5,1,'R=20 kohm')
%text(1.0, 2.4, 'L=30 mH')
%text(0.1, 0.5,'E=10 V')
%text(-0.1,2.1, 'i(t)   -> ')

%w=0.4; n=6;x0=-1;y0=-1; x1=0;y1=0;
%coil(n,w, x0,x1,y0,y1);
%w=0.4; n=8;x0=1;y0=1; x1=2;y1=2;
%resist(n,w, x0,x1,y0,y1);
%print x10_9diag.ps
