% © Fazekas Istvan 1998; program a Statisztika c. reszhez
% 1. relativ gyakorisag es valoszinuseg

X=rand(20,299);
y=sum(X<0.4);[n,z]=hist(y,0:20);
figure, bar(0:20,binopdf(0:20,20,0.4)), hold on;
plot(z,n./299,'r*');
% 2. maxhely
[maxi,hely]=max(binopdf(0:20,20,0.4));
maxhely=hely-1, maxert=maxi
ketmaxhely=maxi==binopdf(hely,20,0.4)
%legrovidebb konfidencia intervallum
t=binoinv(0.2,20,0.4);
f=binoinv(0.8+[0 binocdf(0:t-1,20,0.4)],20,0.4);
[mini,hol]=min(f-[0:t]);
miniintervallum=[hol-1,hol-1+mini]
hanyminiintervallum=sum(mini==f-[0:t])
% 3. binomialis es normalis
figure, bar(50:110,binopdf(50:110,200,0.4)), hold on;
m=200*0.4;s=sqrt(m*0.6);
plot(50:0.2:110,normpdf(50:0.2:110,m,s),'r-');
% binomialis es Poisson
figure, bar(0:20,binopdf(0:20,200,0.01)), hold on;
plot(0:20,poisspdf(0:20,200*0.01),'r*');