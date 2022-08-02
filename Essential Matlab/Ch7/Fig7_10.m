subplot(2,2,1)
       [x y] = meshgrid(-2:.2:2, -2:.2:2);
       z = x .* exp(-x.^2 - y.^2);
       meshc(z),title('(a)'),grid off
subplot(2,2,2)
      
       c = z;       % preserve the original surface
       c(1:11,1:21) = nan*c(1:11,1:21);
       mesh(c), title('(b)'),grid off