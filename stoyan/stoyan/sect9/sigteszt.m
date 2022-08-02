% © Fazekas Istvan 1998; program a Statisztika c. reszhez
% 1. nemparameteres probak

x=normrnd(0,1,50,1); m=mean(x), s=std(x)
y=unifrnd(-sqrt(3),sqrt(3),50,1);
[pranksum,hranksum]=ranksum(x,y,0.05)
[psignrank,hsignrank]=signrank(x,y,0.05)
[psigntest,hsigntest]=signtest(x,y,0.05)
% 2. egymintas u- es t-proba
[httest,sigttest,cittest]=ttest(x,0,0.05)
[hztest,sigztest,ciztest]=ztest(x,0,1,0.05)
u1=norminv(0.975,0,1); a=u1:0.02:4;
figure; plot(-4:0.02:4, normpdf(-4:0.02:4,0,1),'k-');
hold on; fill([-u1 -a],[0 normpdf(-a)],'c');
fill([u1 a], [0 normpdf(a)],'c');
u=m*sqrt(50); plot(u,0:0.025:0.5,'k*');
% 3. ketmintas t-proba
z=normrnd(0,1,75,1);
[httest2,sigttest2,cittest2]=ttest2(x,z,0.05)