% function g_cont plots a curvilinear grid or 
% contour on the curvilinear gird. Used in L2_23.m
% Copyright S. Nakamura, 1995 
function g_cont(x, y, f, s)
x_max=max(max(x));
x_min=min(min(x));
y_max=max(max(y));
y_min=min(min(y));
axis('square')
axis([x_min,x_max,y_min,y_max]); hold on
axis('off');
kmax=length(s);
fprintf('Type 1 if you wish to plot grid only.\n')
fprintf('Type 0 if you wish to plot contour.\n')
m_plot=input('?');
if m_plot == 1
   [ni,nj] = size(x);
   for j=1:nj
      plot(x(:,j),y(:,j))
   end
   for i=1:ni
      plot(x(i,:),y(i,:))
   end
   return
end
fprintf('Type 1 if you wish to plot grid also.\n')
fprintf('Type 0 if you wish to plot contour only.\n')
m_plot=input('?');
if m_plot == 1
   [ni,nj] = size(x);
   for j=1:nj
      plot(x(:,j),y(:,j))
   end
   for i=1:ni
      plot(x(i,:),y(i,:))
   end
else

   [ni,nj] = size(x);

   for j=1:nj-1:nj
      plot(x(:,j),y(:,j))
   end

   for i=1:ni-1:ni
      plot(x(i,:),y(i,:))
   end
end
for i = 1:ni-1
  for j=1:nj-1
    f_min = min([f(i,j), f(i+1,j), f(i,j+1), f(i+1,j+1)]);
    f_max = max([f(i,j), f(i+1,j), f(i,j+1), f(i+1,j+1)]);
    ip = i+1;
    jp = j+1;
    for k = 1:kmax
      if f_min <= s(k) & s(k) <= f_max
        l=0;
        if (s(k) - f(i,j)) * (s(k) - f(ip,j)) <= 0; l=l+1;
          [xp(l),yp(l)] = GC_inter(s(k),i,j,ip,j,x, y,f);
        end
        if (s(k) - f(ip,j)) * (s(k) - f(ip,jp)) <= 0,l=l+1;
          [xp(l),yp(l)] = GC_inter(s(k),ip,j,ip,jp,x, y,f);
        end
        if (s(k) - f(i,j)) * (s(k) - f(i,jp)) <= 0,l=l+1;
          [xp(l),yp(l)] = GC_inter(s(k),i,j,i,jp,x, y,f);
        end
        if (s(k) - f(i,jp)) * (s(k) - f(ip,jp)) <= 0,l=l+1;
          [xp(l),yp(l)] = GC_inter(s(k),i,jp,ip,jp,x, y,f);
        end
        if l >= 2, plot([xp(1),xp(2)], [yp(1),yp(2)], '--');
        end
        if l == 4 plot([xp(3),xp(4)], [yp(3),yp(4)], '--');
        end
      end
    end
  end
end
return

