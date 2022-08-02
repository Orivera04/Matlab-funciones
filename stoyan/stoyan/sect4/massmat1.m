function B=massmat1(n)
% © Stoyan Gisbert 1998; program a Linearis algebra c. reszhez

al=1/(12*n*n);n1=n-1;nn=n1*n1;
c=al*ones(n,1); c1=c;
for k=1:n1
   c1(k*n1)=0;
end
c2=[al;c1(1:nn-1)];      % al kivetelevel idaig ez 
                         % ugyanaz mint az A-nal
B=[c1,c,c1,6*c,c2,c,c2]; % az atlok "osszeallitasa
B=spdiags(B,[-n1-1,-n1,-1,0,1,n1,n1+1],nn,nn);