function yp=fop0n2_b(t,y,flag,name,ts,uf,s)
% Subroutine for FOP0N2 (scalar uf);              6/28/02
%
[dum,ns]=size(s); n1=ns*(ns+1)/2;  
la=y(1:ns); S=forms(y(ns+1:n1+ns)); h=y(n1+ns+1:n1+2*ns);
u1=interp1(ts,uf,t); s1=interp1(ts,s,t);
[fs,fu,fss,fsu,fuu]=feval(name,u1,s1,t,3); 
Hu=la'*fu; Hss=zeros(ns); 
for j=1:ns, Hss=Hss+la(j)*fss([(j-1)*ns+1:j*ns],:); end
Hus=la'*fsu; Huu=la'*fuu;
A=fs-fu*(Huu\Hus); B=fu*(Huu\fu'); C=Hss-Hus'*(Huu\Hus);
K=Huu\(Hus+fu'*S);                           
lad=-fs'*la; Sd=-S*A-A'*S-C+S*B*S; hd=-(A-B*S)'*h+K'*Hu;
yp=[lad; forms(Sd); hd]; 