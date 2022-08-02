plot3([-10 10 10 -10 -10 10 10 -10],[-10 -10 -10 -10 10 10 10 10],[-10 -10 10 10 -10 -10 10 10],'k.');

for cntf = 1:1:1000
    color1 = 0.5+sin(2*pi*cntf/1000)/2;
    color2 = 0.5+sin(3*pi*cntf/1000)/2;
    color3 = 0.5+sin(4*pi*cntf/1000)/2;
    color4 = 0.5+sin(5*pi*cntf/1000)/2;
    color5 = 0.5+sin(6*pi*cntf/1000)/2;
    color6 = 0.5+sin(7*pi*cntf/1000)/2;
    color7 = 0.5+sin(8*pi*cntf/1000)/2;
    color8 = 0.5+sin(9*pi*cntf/1000)/2;
    h1 = plotcube([5*cos(4*pi*cntf/1000) 5*sin(4*pi*cntf/1000) 0],[5 5 5],[2*pi*cntf/100 pi*cntf/100 0],[ color1 color2 color3 color4 color5 color6 color7 color8],0.5+sin(4*pi*cntf/1000)/2,1); pause(0.04);
    delete(h1);
end



