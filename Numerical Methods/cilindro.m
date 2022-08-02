%dibuja un cilindro de altura 1 y radio r, transparente con cylinder de
%Matlab
r=input('dame el radio ')
[x,y,z]=cylinder(r,30)
surfc(x,y,z,'FaceAlpha','flat','AlphaDataMapping','scaled',...
    'AlphaData',gradient(z),'FaceColor','red')
