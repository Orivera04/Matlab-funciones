% clc
% clear all
function     [xx,yy,x,t2] = blogpiston(t1,x,t2)

%Tolerancia e
e=0.001;
%Dimensiones del sistema
lm=35;
lb=56;

%estimaciones
%  x=70;
%  t2=30*pi/180;
%definicion de F
f1=lm*sin(t1)-lb*sin(t2);
f2=lm*cos(t1)+lb*cos(t2)-x;
while abs(f1)>e | abs(f2)>e
    df1x=0;
    df1t2=-lb*cos(t2);
    df2x=-1;
    df2t2=-lb*sin(t2);
    A=[df1x,df1t2;df2x,df2t2];
    B=[-f1;-f2];
    X=A\B;
    if X==[0;0]
        break
    end
    x=x+X(1);
    t2=t2+X(2);
    %definicion de F con los nuevos x y t2
    f1=lm*sin(t1)-lb*sin(t2);
    f2=lm*cos(t1)+lb*cos(t2)-x;
end

xx=[0,lm*sin(t1),0];
yy=[0,lm*cos(t1),x];

