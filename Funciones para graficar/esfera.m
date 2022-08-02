%Dibuja una esfera transparente de radio=1, n es un No. natural(20,30,...)
n=input('dame n  ');
[x,y,z]=sphere(n);
surf(x,y,z,'FaceAlpha','flat','AlphaDataMapping','scaled',...
    'AlphaData',gradient(z),'FaceColor','red')