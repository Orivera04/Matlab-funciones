% f2_33 plots Figure 2.33
% Copyright S. Nakamura, 1995
hold off, clear, clg
set(gcf, 'NumberTitle','off','Name', 'Figure 2.33')

axis([-5 14 -5 14])
hold on
%axis('square')
axis('off')
x0=-1;x1=2;y0=2;y1=2;
Body=10 ; 
Rarm1=10; Rarm2=30; 
Larm1=30; Larm2=90; 
Rleg1=30; Rleg2=90;
Lleg1=90; Lleg2=20; 
human_([x0,y0],[x1,y1], Body, Rarm1,Rarm2,Larm1,Larm2, ...
                           Rleg1,Rleg2,Lleg1,Lleg2  )
human_([2,0],[5,1], Body, Rarm1,Rarm2,Larm1,Larm2, ...
                           Rleg1,Rleg2,Lleg1,Lleg2  )
human_([3,1],[6,1], -Body, Rarm1,Rarm2,Larm1,Larm2, ...
                           Rleg1,Rleg2,Lleg1,Lleg2  )
human_([-3,1],[-1.,1], Body*1.1,-Rarm1,Rarm2,Larm1,Larm2, ...
                           Rleg1,Rleg2,Lleg1,Lleg2  )
human_([-4,4],[-2.,4], Body, Rarm1,Rarm2,Larm1,Larm2, ...
                           Rleg1,Rleg2,Lleg1,Lleg2  )
human_([7,0.5],[10.5,0.5], Body, -Rarm1,Rarm2*2,Larm1,Larm2, ...
                           Rleg1,Rleg2,Lleg1,Lleg2  )
human_([9.5,-2],[13,-2], 2*Body, -Rarm1,-Rarm2,Larm1,Larm2, ...
                           Rleg1,Rleg2,Lleg1,Lleg2  )

xlabel('Seven noisy kids are coming.')
