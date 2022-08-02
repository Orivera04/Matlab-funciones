% f4_13
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 4.13')

clear,clf
a = 3;
b = 3;
c = [0,0,0,1; 0,0,1,0; 1,1,1,1; 3,2,1,0]\[1; a; 4; 0];
d = [0,0,0,1; 0,0,1,0; 1,1,1,1; 3,2,1,0]\[1; 0; 2; b];
s = 0:0.01:1;
x = polyval(c,s); y = polyval(d,s);  plot(x,y)

hold on
plot([1,4],[1,2],'o')
text(0.8,1.1, 'A: s=0','FontSize',[14])
text(0.8,0.9, '(x=1, y=1)','FontSize',[14])
text(0.8,0.75, 'dy/dx=0','FontSize',[14])
text(3.8, 2.1, 'B: s=1','FontSize',[14])
text(3.8, 2.25, 'dx/dy=0','FontSize',[14])
text(3.8, 2.4, '(x=4, y=2)','FontSize',[14])
plot([1,3],[1,1],'--')
plot([4,4],  [2,1.5],'--')


xlabel('X'); ylabel('Y');



axis([0.6 4.65 0.6 2.5])
%print fig4d13.ps
