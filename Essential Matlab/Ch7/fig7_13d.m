subplot(2,2,1)
x = 0:0.1:1;
errorbar(x,exp(-x),...
    0.5*rand(1,length(x)),'dk')
