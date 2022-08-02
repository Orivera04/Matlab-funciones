function d1=plotfit(g,b,cov)

c=length(g);
g=[0 g];
n=length(cov);

probs=[]; k=length(g);
for i=k:-1:1
   probs=[probs;g(i)-b(1)-b(2)*cov];
end

probs=(exp(probs)./(1+exp(probs)))';
probs=[ones(n,1) probs zeros(n,1)];
d=-diff(probs')';
d1=d(:,5:-1:1);
bar(cov,d1,'stacked')
xlabel('SAT'),ylabel('PROBABILITY')
legend('F','D','C','B','A')
colormap('gray')
