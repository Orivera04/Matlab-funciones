%f2_17a same as l2_21:  plots   Figure 2.17(a) 
% See the first plot of Figure 2.17
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 2.17(a)')
clear,clf
load cell_.DAT
load point_.DAT
tri_grid(cell_,point_, 1.8)

