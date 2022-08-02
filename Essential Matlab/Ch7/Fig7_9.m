subplot(2,2,1)
       [x y] = meshgrid(-2.1:0.15:2.1, -6:0.15:6);
       u = 80 * y.^2 .* exp(-x.^2 - 0.3*y.^2);    
       contour(u,'k'),title('(a)')
subplot(2,2,2)
contour3(u,'k'),title('(b)'),grid off                                
