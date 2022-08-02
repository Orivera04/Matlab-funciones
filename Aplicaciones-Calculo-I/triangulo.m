function triangulo(A,B,C,col,GL)
X=[A(1),B(1),C(1),A(1)];
Y=[A(2),B(2),C(2),A(2)];
h=plot(X,Y);
set(h,'color',col,'linewidth',GL);