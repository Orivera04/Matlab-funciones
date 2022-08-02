% Exercicios_Propostos_09
echo on
syms x y
p1 = 6000 - 2*x
p2 = 9000 - 4*y
z = x + y
C = 60000 + 500*z
L = p1*x + p2*y - C
diff(L,x)
diff(L,y)
diff(diff(L,x))
diff(diff(L,y))
x=5500/4;
y=8500/8;
eval(L)
