clear, clf, hold off
axis([0,10,0,10]);
hold on;
plot([1,2,2,1,1],[2,2,3,3,2]);
text(1,1.6,'Haga clic dentro del cuadro para terminar')
i=0;
while 1
[x,y,boton]=ginput(1);
if boton ==1, plot(x,y,'+r');i=i+1;v(i)=x;w(i)=y;end;
if boton ==2, plot(x,y,'oy');end;
if boton ==3, plot(x,y,'*g');end;
if x>1 & x<2 & y>2 & y<3,break; end
end
hold off
close
i
v
w
plot(v,w)


