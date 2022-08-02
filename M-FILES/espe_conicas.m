%Casos especiales de cónicas. Ec.general Ax^2+By^2+Cx+Dy+F=0

Coef=input('Dar los coeficientes [A,B,C,D,F]= ');
A=Coef(1);B=Coef(2);C=Coef(3);D=Coef(4);F=Coef(5);    
d=B*C^2+A*D^2-4*A*B*F    
if A==0&B==0
    disp('La ecuación representa una recta o conjunto vacío')
elseif A*B~=0&d==0
    disp('La ecuación representa un punto')
elseif A*B>0&d<0
    disp('La ecuación representa conjunto vacío')
elseif A~=0&B==0&D==0
    disp('La ecuación representa dos rectas')
elseif A==0&B~=0&C==0
    disp('La ecuación representa dos rectas o conjunto vacío')
else
   disp('La ecuación representa una cónica') 
end