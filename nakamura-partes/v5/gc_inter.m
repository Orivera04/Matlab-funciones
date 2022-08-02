% GC_inter is called by g_cont.
% Interpolates function on a generalized grid.
% Copyright S. Nakamura, 1995
function [x_,y_] = GC_inter(s_lev,i1,j1,i2,j2,x_grid, y_grid,fun)
  if abs(fun(i1,j1) - s_lev) < 1.0e-5 &  ...
    abs(fun(i2,j2) - s_lev) < 1.0e-5
    x_ = (x_grid(i1,j1) + x_grid(i2,j2))/2;
    y_ = (y_grid(i1,j1) + y_grid(i2,j2))/2;
  else
    a  =  (fun(i2,j2) - s_lev)/(fun(i2,j2) - fun(i1,j1));
%   if  a<0 | a>1, a, end
    b  =  1-a;
    x_ =  x_grid(i1,j1)*a + x_grid(i2,j2)*b;
    y_ =  y_grid(i1,j1)*a + y_grid(i2,j2)*b;
  end
return

