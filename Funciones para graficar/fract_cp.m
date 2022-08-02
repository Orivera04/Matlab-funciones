% fract_cp.m plots a Fractal image in color plates 
% by Henon's model.  See also color plates.
% Copyright S. Nakamura, 1995
close
set(gcf, 'NumberTitle','off','Name', 'Figure D.6: fractal_;  L_d5  ')

clf,clear, W=ones(201,201); colormap(jet)
hold on
L=10;
for y=0.1:0.01:1
  for x=.1;0.01; 1.2 ;
    L=L+2; if L>64 L=1; end
    a=0.24; b=0.9708; alph=76.1135;
    for n=1:100
      xb=x;yb=y;
      x=a*xb-b*(yb-xb^2);
      y=b*xb + a*(yb-xb^2);
      if abs(x)>10 | abs(y)>10 break;end
      nx = fix((real(x)+1)* 100);
      ny = fix((real(y)+1)* 100);
      if nx<1 nx=1;end; if nx>200 nx = 200;end
      if ny<1 ny=1;end; if ny>200 ny=200; end
      W(nx,ny) = L;
    end
  end
end
image(W); axis([1,200,1,200]); axis('off'); hold off

