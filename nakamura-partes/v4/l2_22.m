% L2_22 plots contour on a triangular mesh.
% (see the second plot in Figure 2.17)
% Copyright S. Nakamura
set(gcf, 'NumberTitle','off','Name', 'Figure 2.17(b)')
clear,clf
load cell_.DAT
load point_.DAT
load f_.DAT
tri_cont(cell_,point_,f_, 1.8)

