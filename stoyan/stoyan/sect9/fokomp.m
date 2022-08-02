% © Fazekas Istvan 1998; program a Statisztika c. reszhez
% 1. 3dim minta generalas

n=150;
a1=[1 -1 1]'; a1=a1./sqrt(3); a2=[1 0 -1]'; a2=a2./sqrt(2);
a3=[1 2 1]'; a3=a3./sqrt(6); A=[a1 a2 a3];
D=A*diag([4 1 0.1])*A'; X=mvnrnd(zeros(3,1),D,n);
[Fi,Fk,Saj,Hott]=princomp(X);
maradek=pcares(X,2);
[pc,var,expl]=pcacov(D);
% 2. 2dim minta generalas
m=1000; D2=[4 1; 1 2];
X2=mvnrnd(zeros(2,1),D2,m);
[Fi2,Fk2,Saj2,Hott2]=princomp(X2);
v=zeros(2,301);
figure; axis([-8 8 -8 8]); hold on;
plot(X2(:,1),X2(:,2),'c.');hold on;
for i=1:2
   for j=1:2
      v(j,:)=(0:Fi2(j,i)/100:3*Fi2(j,i))*sqrt(Saj2(i));
   end
   plot(v(1,:),v(2,:),'b-'); hold on;
end;