% human_c.m
% human_capt.m has been renamed to human_c.m
% Note also that function human_captf.m has been renamed to
% h_captf.m 
hold off, clear, clf
set(gcf, 'NumberTitle','off','Name', 'Figure 2.36')
axis([-2 3 0.5 4.2])
hold on
%axis('square')
axis('off')
x0=-1;x1=2;y0=2;y1=2;
Body=10 ; 
Rarm1=10; Rarm2=30; 
Larm1=30; Larm2=90; 
Rleg1=30; Rleg2=90;
Lleg1=90; Lleg2=20; 
h_captf([x0,y0],[x1,y1], Body, Rarm1,Rarm2,Larm1,Larm2, ...
                           Rleg1,Rleg2,Lleg1,Lleg2  )

xlabel('Legend.')
