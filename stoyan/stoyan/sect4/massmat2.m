function B=massmat2(n)
% © Stoyan Gisbert 1998; program a Linearis algebra c. reszhez

al=1/(12*n*n);n1=n-1;nn=n1*n1;
c=al*ones(n1,1);
B=spdiags([c,6*c,c],[-1,0,1],n1,n1);
B=kron(speye(n1),B);
c1=al*ones(nn,1); c2=c1;
for k=1:n1
   c2(k*n1)=0;
end
c3=[al;c2(1:nn-1)];
B=spdiags([c2,c1,c1,c3],[-n1-1,-n1,n1,n1+1],B);