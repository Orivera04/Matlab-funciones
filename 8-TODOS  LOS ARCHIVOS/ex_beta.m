for n = 0:5
  for p = 0:n
    fprintf('%4.0f', 1/(beta(p+1,n-p+1)*(n+1))); 
  end;
  fprintf('\n');
end;
x =  0.5:0.05:2;    [xx,  yy] = meshgrid(x);
surfl(xx, yy, beta(xx, yy));
colormap(gray); shading interp
title('\bf{\itB} (x, y)   0.5 < x, y < 2','fontsize',18)