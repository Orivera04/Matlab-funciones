% edge_dif.m  Edges of three disks after diffusion.
% See Figure D.5; List D.4
close
set(gcf, 'NumberTitle','off','Name', 'edge_dif; L_d4')


clear,clf
load  edge_d
[ni,nj]=size(c);
d=c;
colormap(map)
for iter=1:7
for i=2:ni-1
for j=2:nj-1
 d(i,j)= (d(i-1,j)+d(i,j) + d(i,j-1)+d(i,j) + c(i,j))/(4+0.1);
 end
end
end
end
image(d)

text(ni/10,ni/10,'After a diffusion process','FontSize',[18])
axis('off')

