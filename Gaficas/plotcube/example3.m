plot3([-10 10 10 -10 -10 10 10 -10],[-10 -10 -10 -10 10 10 10 10],[-10 -10 10 10 -10 -10 10 10],'k.');
for cntz = -3:1:3
    for cntx = -9:3:9
        if mod(cntz,2) == 0
            rem2 = 1.5;
        else
            rem2 = 0;
        end
        rem = 0.2*rand+0.1;
        plotcube([cntx+rem2 0 (cntz+3)*0.1+cntz],[3-rem 1 1],[0 0 0],[ 1-0.05*rand 1-0.05*rand 1-0.05*rand 1-0.05*rand 1-0.05*rand 1-0.05*rand 1-0.05*rand 1-0.05*rand],0.99,0); drawnow;
        if cntx ~= 9
            plotcube([cntx+1.5+rem2 0 (cntz+3)*0.1+cntz],[rem 1 1],[0 0 0],[ 0.5-0.05*rand 0.5-0.05*rand 0.5-0.05*rand 0.5-0.05*rand 0.5-0.05*rand 0.5-0.05*rand 0.5-0.05*rand 0.5-0.05*rand],1,0); drawnow;
        end
        if cntz ~= 3
            plotcube([1.5 0 (cntz+3)*0.1+cntz+0.55],[18 1 0.1],[0 0 0],[ 0.5-0.05*rand 0.5-0.05*rand 0.5-0.05*rand 0.5-0.05*rand 0.5-0.05*rand 0.5-0.05*rand 0.5-0.05*rand 0.5-0.05*rand],1,0); drawnow;
        end
    end
end