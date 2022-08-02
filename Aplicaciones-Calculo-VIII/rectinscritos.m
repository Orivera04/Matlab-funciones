%Dibujo de rectángulos bajo una curva
%Definir función a graficar y su dominio.
fun=input('f(x)=');
f=inline(fun);
a=input('a= ');
b=input('b= ');
nptos=input('No. de ptos: ');
x=linspace(a,b,nptos)
y=f(x);
plot(x,y);
hold on;
w=(b-a)/(nptos-1);
for i=1:nptos-2    
h(i)=f(a+i*w);
rectangle('Position', [a+i*w 0 w h(i)]);
end
hold off

