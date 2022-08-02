plot3([-10 10 10 -10 -10 10 10 -10],[-10 -10 -10 -10 10 10 10 10],[-10 -10 10 10 -10 -10 10 10],'k.');
for cnth = -5:1:5
    for cntr = 0:0.5:2*pi
        plotcube([4*cos(cntr) 4*sin(cntr) cnth],[2 1 1],[0 pi/2+cntr 0],[ 1-0.05*rand 1-0.05*rand 1-0.05*rand 1-0.05*rand 1-0.05*rand 1-0.05*rand 1-0.05*rand 1-0.05*rand],0.99,1); drawnow;
    end
end