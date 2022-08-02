echo on
% cap3_logplot_exemplo( )
x=linspace(0,2,20);
y=exp(x);
subplot(2,2,1)
plot(x,y)
title('Linear')
subplot(2,2,2)
semilogx(x,y)
title('Semilog Y')
subplot(2,2,3)
semilogy(x,y)
title('Semilog Y')
subplot(2,2,4)
loglog(x,y)
title('Log Log')