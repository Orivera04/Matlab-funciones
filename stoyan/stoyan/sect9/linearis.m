% © Fazekas Istvan 1998; program a Statisztika c. reszhez
% modell generalas

n=30; x1=ones(n,1); xs=([1:n])';
x2=(-1).^xs+0.2*normrnd(0,1,n,1);
x3=xs./n+unifrnd(0,0.1,n,1);
X=[x1 x2 x3 x2.^2 x3.^2 x2.*x3];
b0=[2 3 3 1 0.4 0.1]';
Y=X*b0+normrnd(0,0.3, n,1);
% 1. legkisebb negyzetes becsles
[b,bint,r,rint,stats]=regress(Y,X,0.1);
% modell kivalasztas (konstans nem kell)
rstool([x2 x3],Y,'quadratic');
regstats(Y,[x2 x3],'quadratic');
% 2. lepesenkenti becsles
% uj model generalas (konstans ne legyen)
Xl=[x2 x3 x2.^2 x3.^2 x2.*x3];
b0l=[3 3 1 0.4 0.1]';
Yl=Xl*b0l+normrnd(0,0.3, n,1);
[bl,bintl,rl,rintl,statsl]=regress(Yl,Xl,0.1);
stepwise(Xl,Yl,[1 2 3]);
% 3. polinom illesztes
% uj model generalas (egyvaltozos model)
yp=x2.^3+x2.^2+x2+1+normrnd(0,0.1,n,1);
[p,S]=polyfit(x2,yp,3);
polytool(x2,yp,2);
[yuj,delta]=polyconf(p,1,S);