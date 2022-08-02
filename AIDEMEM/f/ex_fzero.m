f= inline('x.^3./(1+x) -1','x');
x1=fzero(f,[1 2])
x2=fzero(f,[0 1])
