function diagonal3(v,w)
%Dibuja diagonales de poligono un poligoni convexo
poliplot(v,w);
hold on;
n=length(v);
for i=2:n-3
    plot([v(1),v(i+1)],[w(1),w(i+1)],'r')
end