% cap3_quad_exemplo
echo on
x=0:0.1:2;
x=-1:0.05:3;
xq=0:0.05:2;
y=cap3_funcao1(x);
yq=cap3_funcao1(xq);
plot(x,y)
hold
area(xq,yq)