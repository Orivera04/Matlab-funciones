x=linspace(0,1,500);y=10.^x;
subplot(2,2,1);plot(x,y,'linewidth',3);title('\bflinéaire','fonts',16);axis tight
subplot(2,2,2);loglog(x,y,'linewidth',3);title('\bfloglog','fonts',16);axis tight
subplot(2,2,3);semilogx(x,y,'linewidth',3);title('\bfsemilogx','fonts',16);axis tight
subplot(2,2,4);semilogy(x,y,'linewidth',3);title('\bfsemilogy','fonts',16);axis tight
