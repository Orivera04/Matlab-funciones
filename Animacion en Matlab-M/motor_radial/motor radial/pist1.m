function     [tb,x1] = pist1(t,tb,x1,lm,lb,rb)
% t=45*pi/180;
% w=600;
% dt=0.01;
e=10^-10;
% Geometria
% lm=15;
% lb=40;
% rb=10;
c=1;
%estimaciones
%x1=40;
%tb=80*pi/180;

f1=lm*sin(t)-(lb+rb)*cos(tb);
f2=lm*cos(t)+(lb+rb)*sin(tb)-x1;
while abs(f1)>e | abs(f2)>e
    c=c+1;
    df1x=0;
    df1tb=(lb+rb)*sin(tb);
    df2x=-1;
    df2tb=(lb+rb)*cos(tb);
    A=[df1x,df1tb;df2x,df2tb];
    B=[-f1;-f2];
    X=A\B;
    if X==[0;0]
        break
    end
    tb=tb+X(2);
    x1=x1+X(1);
    f1=lm*sin(t)-(lb+rb)*cos(tb);
    f2=lm*cos(t)+(lb+rb)*sin(tb)-x1;
end
x1=lm*cos(t)+(lb+rb)*sin(tb);