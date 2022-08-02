%Area bajo una curva usando rectángulos circunscritos
%Definir función a graficar y su dominio.
fun=input('f(x)=');
f=inline(fun);
a=input('a= ');
b=input('b= ');
nptos=input('No. de ptos: ');
x=linspace(a,b,nptos);
y=f(x);
plot(x,y);
hold on;
w=(b-a)/(nptos-1);
areaprox=0;
for i=1:nptos-1    
h(i)=f(a+i*w);
areaprox=areaprox+w*h(i);
rectangle('Position', [a+(i-1)*w 0 w h(i)]);
end
areaprox
hold off

