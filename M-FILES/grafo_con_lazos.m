%Grafo con lazos en cada v?rtice
%Intodcir los v?rtices del grafo:
v=input('1as. coordenadas de v?rtices: ');
w=input('2as. coordenadas de v?rtices: ');
n=numel(v);
axis([0 10 0 10]);
hold on;
for i=1:n-1
plot(0.2*cos(0:0.2:6.28)+v(i),0.2*sin(0:0.2:6.28)+w(i));
plot(v(i),w(i),'*r');
text(v(i),w(i)+0.4,['v(',num2str(i),')'],'FontSize',12)
end
plot(v,w)