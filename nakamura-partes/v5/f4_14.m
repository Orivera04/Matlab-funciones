% f4_14
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 4.14')

clear,clf
a = 3;
b = 3;
c = [0,0,0,1; 0,0,1,0; 1,1,1,1; 3,2,1,0]\[1; a; 4; 0];
d = [0,0,0,1; 0,0,1,0; 1,1,1,1; 3,2,1,0]\[1; 0; 2; b];
s = 0:0.01:1;
x = polyval(c,s); y = polyval(d,s);  plot(x,y)
xlabel('X'); ylabel('Y');

%print fig4d14.ps
