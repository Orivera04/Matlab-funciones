xv = -1:.1:1;
yv = -1:.2:1;
tv = 1:5;
[x,y,t] = ndgrid(xv, yv, tv);
B = (1 - exp(-(2*x).^2 - y.^2))./t;
Nx = length(xv);
Ny = length(yv);
Nt = length(tv);

clf
count = 0;
top = max(max(max(B)));
for yi = 1:Ny
 for ti = 1:Nt
  count = count + 1;
  pos = pickbox(Ny,Nt,count,0,0,.2);
  ax = axes('pos',pos,...
            'ylim',[0 top],...
            'nextplot','add');
  plt(xv,B(:,yi,ti),'.')
  if count~=51
   set(gca,'xticklabel','',...
           'yticklabel','')
  end
  if count == 51
   xlabel('x')
   ylabel('B')
  end
  if count<6
   title(['Time = ' ...
           num2str(tv(ti)) ' s'])
  end
  if rem(count-1,5)==0
   text(-3,0.5,['y = ' ...
                num2str(yv(yi))])
  end
 end
end
