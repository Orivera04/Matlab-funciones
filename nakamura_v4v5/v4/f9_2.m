% f9_2   
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 9.2')

clear clg , hold off
plot([-0.3,1,2,3.3], [0,0,0,0])
hold on
plot([1,1], [0.2,0])
plot([2,2], [0.2,0])
plot([1,2], [0.1,0.1], ':')
axis([-0.5,3.5,-0.3, 0.5])
text(1.5, 0.18,'hi','FontSize',[18])
text(1,-0.1,'si','FontSize',[18])
text(1,-0.2,'t=0','FontSize',[18])
text(1,0.4,'fi','FontSize',[18])
text(1,0.3,'f`i','FontSize',[18])
text(2-0.1,-0.1,'si+1','FontSize',[18])
text(2-0.1,-0.2,'t=hi','FontSize',[18])
text(2-0.1,0.4,'fi+1','FontSize',[18])
text(2-0.1,0.3,'f`i+1','FontSize',[18])
text(3-0.1,-0.1,'si+2','FontSize',[18])
text(0-0.1,-0.1,'si-1','FontSize',[18])
plot([0 1 2 3],[0 0 0 0],'o')
axis('off')
%print fig9d2.ps
