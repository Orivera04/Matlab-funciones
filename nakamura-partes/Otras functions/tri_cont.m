% function tri_cont plots contour on a triangula mesh.
% Used in List 2_22.  Copyright S. Nakamura 1995 
function dummy=tri_cont(tri_data,xy_data,f_data,ys)
[n_tr,n] = size(tri_data);
[n_pt,n] = size(xy_data);
nmax=tri_data(1,1);
x=xy_data(:,2);
y=xy_data(:,3);
f = f_data;
tri_num_prnt = input('Anotate element numbers ?  1 yes/ 0 no: ');
pnt_num_prnt = ...
        input('Anotate mesh point numbers ? 1 yes/0 no: ');
xmin =min(x);  xmax =max(x); x_cen = 0.5*(xmin + xmax);
ymin =min(y*ys);ymax =max(y*ys);y_cen = 0.5*(ymin + ymax);
fmin =min(f)+0.01;  fmax =max(f)-0.01;
Dx=xmax-xmin; Dy=ymax-ymin;
n_cont=20;
df = (fmax-fmin)/n_cont;kmax=n_cont;
s = fmin:df:fmax;
if Dx<Dy, xmin = x_cen-Dy/2, xmax = x_cen+Dy/2, end
if Dx>Dy, ymin = y_cen-Dx/2, ymax = y_cen+Dx/2, end
clf;  hold off;  clc;  %axis('square')
axis([xmin, xmax,ymin,ymax]); m=0;
%title('Contour Plot');   
hold on
del_x = 0.1; del_y = 0.1;  % Adjust location of element no.
for k=1:n_tr
  for j=1:3
    p=tri_data(k,j+1);
    xx(j)=x(p);  yy(j)=y(p);
    ff(j) = f(p);
  end
  xx(4)=xx(1);  yy(4)=yy(1); ff(4)=ff(1);
  plot(xx,yy*ys)
  f_min = min([ff(1), ff(2), ff(3)]);
  f_max = max([ff(1), ff(2), ff(3)]);
  for kv = 1:kmax
    if f_min <= s(kv) & s(kv) <= f_max;
      m=0;
      m=0;
      for i=1:3
        if (s(kv) - ff(i)) * (s(kv) - ff(i+1))<= 0,
          m = m + 1;
          if f(i+1) == f(i),  alph=0.5;end
          if f(i+1) ~= f(i),
            alph = (s(kv)-ff(i))/(ff(i+1)-ff(i));
          end
          xp(m)= alph*xx(i+1) + (1-alph)*xx(i);
          yp(m)= alph*yy(i+1) + (1-alph)*yy(i);
        end
        if m == 2,
          plot([xp(1),xp(2)],[yp(1)*ys,yp(2)*ys],'--');
          break
        end
      end
    end
  end
  %==
  x_cen = sum(xx(1:3))/3;  y_cen = sum(yy(1:3))/3;
  if tri_num_prnt == 1 % if 0, elmnt numbers are not printed.
    text(x_cen - del_x, (y_cen - del_y)*ys, int2str(k))
  end
end
% plot(x,y*ys,'*')   % Use if points are to be marked by *.
%=================
if pnt_num_prnt == 1   % if 0, point numbers are not printed.
  for n=1:n_pt
  text(x(n), y(n)*ys, ['(',int2str(n),')'])
  end
end
axis('off')
