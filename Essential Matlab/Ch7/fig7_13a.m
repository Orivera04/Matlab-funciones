x = 0:0.1:1.5;
subplot(2,2,1)
area(x', [x.^2' ...
     exp(x)' exp(x.^2)'])
