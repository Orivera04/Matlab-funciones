clear,clc, clf, hold off
N=input('No de vertices del grafo: N=');
M=input('No de lados del grafo: M=');
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
p=1;
ML=zeros(N);
while p<=M
    disp(['lado No.',num2str(p)])
    ind1=input('No del 1er. vértice: ');
    ind2=input('No. del 2o. vértice: ');
    ML(ind1,ind2)=1;
    p=p+1;
end
ML
hold on;
for i=1:N
    for j=1:N
       if ML(i,j)==1
           plot([v(i),v(j)],[w(i),w(j)])
       end
    end
end
%Matriz de adyacencia:
MA=ML;
for i=1:N
    for j=1:N
        if i>j
          MA(i,j)=ML(j,i);
        end
   end
end
MA    