% function tri_grid plots a triangular mesh.
% See Figure 2.17 and List 2.21. 
% Copyright S. Nakamura 1995
function tri_grid(tri_d, xy_d, y_scale)
hold off
[n_tr,n] = size(tri_d);
[n_pt,n] = size(xy_d);
nmax=tri_d(1,1);
x=xy_d(:,2);
y=xy_d(:,3)*y_scale;
tri_num_prnt = input('Anotate element numbers ?  1 yes/ 0 no: ');
pnt_num_prnt = input('Anotate mesh point numbers ? 1 yes/0 no: ');
xmin =min(x);  xmax =max(x); x_cen = 0.5*(xmin + xmax);
ymin =min(y);  ymax =max(y); y_cen = 0.5*(ymin + ymax);
Dx=xmax-xmin; Dy=ymax-ymin;
if Dx<Dy, xmin = x_cen-Dy/2; xmax = x_cen+Dy/2; end
if Dx>Dy, ymin = y_cen-Dx/2; ymax = y_cen+Dx/2; end
clg;  hold off;  clc;  %axis('square')
axis([xmin, xmax,ymin,ymax])
%xlabel('Plot of triangular mesh');   
hold on
del_x = 0.1; del_y = 0.1;  % Adjust location of element no.
for k=1:n_tr
   for l=1:3
      p=tri_d(k,l+1);
      xx(l)=x(p);  yy(l)=y(p);
   end
   xx(4)=xx(1);  yy(4)=yy(1);
   plot(xx,yy)
   x_cen = sum(xx(1:3))/3;  y_cen = sum(yy(1:3))/3;
   if tri_num_prnt == 1 % if 0, elmnt numbers are not printed.
      text(x_cen - del_x, y_cen - del_y, int2str(k))
   end
end
%plot(x,y,'*')
if pnt_num_prnt == 1   % if 0, point numbers are not printed.
   for n=1:n_pt
   text(x(n), y(n), ['(',int2str(n),')'])
   end
end
axis('off')
