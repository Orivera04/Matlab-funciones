function R=rotacuadXY(A,B,C,D,E,F,G,H,M,N)
%Rotación de una cuadrica en XY.
syms x y z X Y Z real;
%ecua=A*x^2+B*y^2+C*z^2+D*x*y+E*x*z+F*y*z+G*x+H*y+M*z+N;
[alfa,beta,gamma]=angrotcuad(A,B,C,D,E,F);
alfa
x=X*cos(alfa)-Y*sin(alfa);
y=X*sin(alfa)+Y*cos(alfa);
z=Z;
v=A*x^2
w=B*y^2
u=v+w;
u=simplify(u)
%R=A*X^2+B*Y^2+C*Z^2+D*X*Y+E*X*Z+F*Y*Z+G*X+H*Y+M*Z+N;
R1=A*x^2+B*y^2+C*z^2+D*x*y+E*x*z+F*y*z+G*x+H*y+M*z+N;
R=simplify(R1);