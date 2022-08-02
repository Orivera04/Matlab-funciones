function sp=fop0n2_f(t,s,flag,name,tu,uf,K,sn)
% Subroutine for FOP0N2 - fwd integ. sdot=f(s,u); 6/22/02
%
uf1=interp1(tu,uf,t); K1=interp1(tu,K,t);
sn1=interp1(tu,sn,t); uff=uf1-K1*(s-sn1'); 
sp=feval(name,uff,s,t,1);


