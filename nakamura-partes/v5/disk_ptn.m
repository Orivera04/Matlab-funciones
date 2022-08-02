% disk_ptn.m  Plots three disks by pcolor.
% See Figure D.3
close
set(gcf, 'NumberTitle','off','Name', 'disk_ptn; L_d2')

clear;clf
map=jet;
colormap(map)
disp 'For Student Edition users, ni < 25'
%ni=input('ni = ')
ni=100;
nj= ni*1.20;
ic1=ni/2; ic2=ni/2; ic3=ni/2;
jc1=nj/4; jc2=nj/2; jc3=nj/4*3;
W=ones(ni,nj);
ni20=ni/4;
for i=1:ni
  for j=1:nj
    r1 = sqrt((i-ic1)^2 + (j-jc1)^2);
    r2 = sqrt((i-ic2)^2 + (j-jc2)^2) ;
    r3 =  sqrt((i-ic3)^2 + (j-jc3)^2);
    if r1  <  ni20  W(i,j)=20; end
    if r2  < ni20 , W(i,j)=40; end
    if r3  < ni20 , W(i,j)=60; end
    if r1< ni20 & r2 < ni20,  W(i,j)=30; end
    if r2< ni20 & r3 < ni20,  W(i,j)=50; end
  end
end
pcolor(W);
shading flat;
save disk_d W map ; axis('off')
text(ni/10,ni/10,'Disk pattern','FontSize',[18])
