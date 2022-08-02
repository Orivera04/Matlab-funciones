function A=poisson1(n)
% © Stoyan Gisbert 1998; program a Linearis algebra c. reszhez

al=n*n;n1=n-1;nn=n1*n1;
c=-al*ones(n,1);     % Ezutan c a csak -al ertekekb"ol 
                     % allo oszlopvektor
c1=c;
for k=1:n1
   c1(k*n1)=0;
end
c2=[-al;c1(1:nn-1)]; % c1-hez kepest a nullak 
                     % egyet lecsusztak c2-ben.
A=[c,c1,-4*c,c2,c];  % a ritka matrix atloi
A=spdiags(A,[-n1,-1,0,1,n1],nn,nn);