% fig4_12
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 4.12')

clear clg , hold off
plot([-0.3,1,2,3.3], [0,0,0,0])
hold on
plot([1,1], [0.2,0])
plot([2,2], [0.2,0])
%plot([1,2], [0.1,0.1], ':')
axis([0.7,2.2,-0.2, 0.4])
text(1.5, 0.11,'h','FontSize',[18])
text(1,-0.1,'s=s1','FontSize',[18])
text(1,-0.2,'t=0','FontSize',[18])
text(1,0.4,'f(s1)','FontSize',[18])
text(1,0.3,'f`(s1)','FontSize',[18])
text(2-0.05,-0.1,'s2','FontSize',[18])
text(2-0.05,-0.2,'t=h','FontSize',[18])
text(2-0.05,0.4,'f(s2)','FontSize',[18])
text(2-0.05,0.3,'f`(s2)','FontSize',[18])
%text(3-0.1,-0.1,'si+2')
%text(0-0.1,-0.1,'si-1')
plot([ 1 2 ],[ 0 0 ],'o')
axis('off')
 arrow_(0.1, [1.4,0.1],[1.0,0.1])
 arrow_(0.1, [1.6,0.1],[2.0,0.1])
% print fig4d12.ps
