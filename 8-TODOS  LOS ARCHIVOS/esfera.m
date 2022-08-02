clear x y z;
%dibuja una esfera transparente de radio 1, n es un natural (20, 30,..)
n=input('dame n  ')
[x,y,z]=sphere(n);
surf(x,y,z,'FaceColor','none')
