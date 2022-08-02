% © Fazekas Istvan 1998; program a Statisztika c. reszhez
% modell generalas

m=20; X=unifrnd(-4,4,m,1);
y=zeros(m,1);
for i=1:m
   y(i)=normpdf(X(i),0,1)+normrnd(0,0.02,1,1);
end;
% becsles
[b,r,J]=nlinfit(X,y,'egyfuggv1',[0.5 0.5]);
konf_int_b=nlparci(b,r,J);
xp=[-3:0.05:3];
[yp,del]=nlpredci('egyfuggv1',xp',b,r,J);
figure,
plot(xp,yp,'k-',xp,yp-del,'g-',xp,yp+del,'g-');
nlintool(X,y,'egyfuggv1',[0.5 0.5],0.06);