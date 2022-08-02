function     [t2,x2] = pist3(ppx,ppy,t2,x2,a2,lm,lb,rb)
        %    [t3,x3] = pist3(ppx(3),ppy(3),t3,x3,a3);

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
%a2=(90-72)*pi/180;
f1=ppx+lb*cos(t2)-x2*cos(a2);
f2=ppy-lb*sin(t2)+x2*sin(a2);
while abs(f1)>e | abs(f2)>e
    c=c+1;
    df1t2=-lb*sin(t2);
    df1x2=-cos(a2);
    df2t2=-lb*cos(t2);
    df2x2=sin(a2);
    A=[df1t2,df1x2;df2t2,df2x2];
    B=[-f1;-f2];
    X=A\B;
    if X==[0;0]
        break
    end
    t2=t2+X(1);
    x2=x2+X(2);
    f1=ppx+lb*cos(t2)-x2*cos(a2);
    f2=ppy-lb*sin(t2)+x2*sin(a2);
end
