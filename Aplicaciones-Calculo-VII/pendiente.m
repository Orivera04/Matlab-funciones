%Ammy Alfaro Caracas
%Elizabeth Almanza C.

clc;
X1=input('de el valor');
Y1=input('de el valor');
X2=input('de el valor');
Y2=input('de el valor');
X3=input('de el valor');
Y3=input('de el valor');
mAB=(Y1-Y2)/(X1-X2)
fprintf('la pendiente de la recta AB es %.2f\n',mAB);
mAC=(Y3-Y2)/(X3-X2)
fprintf('la pendiente de la recta ACes %.2f\n',mAC);
mBC=(Y3-Y2)/(X3-X2)
fprintf('la pendiente de la recta BC es %.2f\n',mBC);
fprintf('la ecuacion de la recta AB:(Y-%f)=%(X-%f)\n',Y1,mAB,X1);
fprintf('la ecuacion de la recta AC:(Y-%f)=%(x-%f)\n',Y2,mAB,X2);
fprintf('la ecuacion de la recta BC:(Y-%f)=%(X-%f(\n',Y3,mBC,X3);
