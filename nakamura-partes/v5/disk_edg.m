% disk_edg.m plots edges extracted from three disks.
% See Appendix D; Figure D.4
set(gcf, 'NumberTitle','off','Name', 'disk_edg; L_d3')
clear,clf
load  disk_d    %reads W and map
[ni,nj]=size(W);
colormap(map)
c = zeros(size(W));
for i=2:ni-1
for j=2:nj-1
 c(i,j)= (W(i-1,j)-W(i,j))^2 + (W(i+1,j)-W(i,j))^2 ...
     + (W(i,j-1)-W(i,j))^2 + (W(i,j+1)-W(i,j))^2;
  if c(i,j) > 0, c(i,j) = 55; end
end
end
image(c);axis('off')
text(ni/10,ni/10,'Extracted edge pattern','FontSize',[18])
save edge_d c map

