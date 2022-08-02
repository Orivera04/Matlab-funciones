function y = rec2ptos(X,Y)
%Esta función encuentra la ecuación de una recta dados 2 ptos. de la misma.

syms x y;
x1=X(1); y1=X(2); x2=Y(1); y2=Y(2);
if x1==x2
    disp(' La ecuación de la recta es:')
    x = x1;
end;
m=(x2-x1)/(y2-y1);
y=y1+m*(x-x1);
line([x1,x2],[y1,y2]);
lde='y = ';
lie=char(y1+m*(x-x1));
title(strcat(lde,lie));
disp('La ecuación de la recta es:')
