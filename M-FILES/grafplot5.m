%Dibuja el grafo G y encuentra la matriz de enlaces ME
%y los enlaces e para cada vértice.
clear,clc, clf, hold off
N=input('No de vertices del grafo: N=');
axis([-1,10,-1,10]);grid on;
hold on;
plot([-1,0,0,-1,-1],[-1,-1,1,1,-1],'r');
text(-0.7,-0.5,'clic');text(-0.7,0.5,'clic');
i=0;
while 1
[x,y,boton]=ginput(1);
if boton ==1, plot(x,y,'or');
i=i+1;v(i)=x;w(i)=y;
text(v(i)+0.1,w(i)+0.1,['#',num2str(i)]);
end;
if boton ==2, plot(x,y,'oy');end;
if boton ==3, plot(x,y,'*g');end;
if i>N,break;end
if x>-1 & x<0 & y>-1 & y<1,break; end
end
hold off
close
n=i-1;v=round(v);w=round(w);
hold on; grid on;
for k=1:n
    plot(v(k),w(k),'ok')
    text(v(k)+0.1,w(k)+0.1,['v',num2str(k)]);
end
axis([0,10,0,10]);grid on;
MA=zeros(N); %Matriz de adyacencia.
             %ME: Matriz de enlaces.
for i=1:N-1
    ind=input(['vértices conectados con v#',num2str(i),' ']);
    ME(i,:)=input(['fila#',num2str(i),' de ME: ']);
    MA(i,ind)=1;
end
k=1; e1=0;e2=0;
for i=1:N
for j=1:N  
    if MA(i,j)==1
           plot([v(i),v(j)],[w(i),w(j)])
           e1(k)=i; e2(k)=j; k=k+1;
    end                         
end
end
E=[e1',e2'];
ini=find(E==1);
mat_ini=E(ini,:);
e=frec(e1);
e=[e,0];
