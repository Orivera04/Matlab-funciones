% © Fazekas Istvan 1998; program a Statisztika c. reszhez
% 1. kis, kozepes, nagy minta

for i=1:3,
   m=3*9^i; x=normrnd(0,1,1,m);
   [n,a]=hist(x,(-3:1/i:3)); figure;
   plot((-3.2:0.05:3.2), normpdf((-3.2:0.05:3.2),0,1));
   hold on; bar(a,i*n/m); hold off;
end;
% 2. ritka, jo, suru hisztogram
m=1500; x=normrnd(0,1,1,m);
for i=1:3,
   k=8/(4^i);[n,a]=hist(x,(-3:k:3)); figure;
   plot((-3.2:0.05:3.2), normpdf((-3.2:0.05:3.2),0,1),'k-');
   hold on; bar(a,n/(m*k),'c'); hold off;
end;