% MANDEL.M Produces a plot af the famous Mandelbrot set.
% see: http://eulero.ing.unibo.it/~strumia/Mand.html

% The generator is z = z^m + c.  Try changing the parameters:

%m = 1, 2, 3 ... 50 etc.

m = 2;

clf
col=20;
N=400; 
cx=-.6; 
cy=0; 
l=1.5; 
x=linspace(cx-l,cx+l,N); 
y=linspace(cy-l,cy+l,N);
[X,Y]=meshgrid(x,y); 
Z=zeros(N); 
C=X+i*Y; 
for k=1:col; 
  Z=Z.^m+C; 
end 
W=exp(-abs(Z));
colormap copper(256); 
imagesc(W); 
axis('square','equal','off');
