% L2_23 lots contour on a curvilinear grid.
% (See Figure 2.18 and 2.19) 
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figures 2.18 and 19')

clear, clf
[x, y ,f] = td_data;
f_max = max(max(f));
f_min = min(min(f));
kmax=20;
for k=1:kmax
     ELV(k)=(k-1)/kmax*(f_max-f_min)*0.9999 + f_min ;
end
g_cont(x, y, f, ELV);
axis([-10,15, -15,10])
axis('square')
axis('off')


