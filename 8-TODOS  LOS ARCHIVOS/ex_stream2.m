f = inline('sin(abs(z).^2/20).*exp(-abs(z).^2)');
x= linspace(-2, 2, 21); [xx, yy]= meshgrid(x);
z = f(xx+i*yy);
surf(z), shading interp; colormap(gray); axis off
[u,v]=gradient(z); h=streamslice(u,v);      
for i=1:length(h); 
  zi = interp2(z,get(h(i), 'xdata'), get(h(i),'ydata'));
  set(h(i),'zdata', zi, 'Color', 'k');
end
alpha 0.5