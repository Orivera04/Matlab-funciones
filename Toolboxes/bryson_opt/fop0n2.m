function [t,uf,s,K,Hu,Huu]=fop0n2(name,tu,uf,s0,tf,tol,mxit) 
%FOP0N2 - Function OPptimization with 0 Terminal Constraints using a
% N-r 2nd order algorithm; fcn. file 'name' should be in the MATLAB
% path & calculate sdot=f(s,u) for flg=1, (phi,phis,phiss) for flg=2,
% and (fs,fu,fss,fsu,fuu) for flg=3. Inputs: tu=tu(N1,1), uf=uf(N1,1)=
% initial guess of control history (from FOP0 or FOPC); s0(ns,1)=
% initial state; tf=final time; tol=tolerance on dua. Outputs: t=time
% vector, uf(t)=optimal control, s(t)=optimal state history, K(t)=fdbk
% gain matrix history;                                   7/02, 8/10/02 
%
ns=length(s0); N1=length(uf); it=0; dua=1;  
disp('      Iter     phi    dua')
optn=odeset('RelTol',tol); sn=zeros(N1,ns); K=zeros(N1,ns);
while max(dua)>tol, 
  % Forward integration w. fdfwd & fdbk, storing s(ts) and ts:  
  [ts,s]=ode23('fop0n2_f',[0 tf],s0,optn,name,tu,uf,K,sn);
  Nf=length(ts); 
  %
  % Interpolate uf, sn, K as functions of ts:
  uf1=interp1(tu,uf,ts); sn1=interp1(tu,sn,ts); 
  K1=interp1(tu,K,ts); uf=zeros(Nf,1);
  %
  % Find new uf as a function of ts:
  for i=1:Nf, uf(i)=uf1(i)-K1(i,:)*(s(i,:)'-sn1(i,:)'); end
  clear uf1 K1 sn1
  %
  % Boundary conditions for backward integration:
  [phi,phis,phiss]=feval(name,0,s(Nf,:)',tf,2); 
  laf=phis'; Sf=phiss; hf=zeros(ns,1);
  %
  % Bkwd integration, storing y(tb)=[la(tb); forms(S(tb)); h(tb)]:
  yf=[laf; forms(Sf); hf];
  [tb,y]=ode23('fop0n2_b',[tf 0],yf,optn,name,ts,uf,s); 
  Nb=length(tb);
  %
  % Reverse indices of tb and y:
  tb1=zeros(Nb,1); la1=zeros(Nb,ns);
  for i=1:Nb, tb1(Nb-i+1)=tb(i); y1(Nb-i+1,:)=y(i,:); end
  tb=tb1; y=y1;  
  %
  % New uf(tb) and K(tb) from y(tb):
  uf1=interp1(ts,uf,tb); s1=interp1(ts,s,tb); 
  K=zeros(Nb,ns); uf=zeros(Nb,1); 
  n1=ns*(ns+1)/2; la=y(:,[1:ns]); ys=y(:,[ns+1:ns+n1]);
  h=y(:,[1+ns+n1:n1+2*ns]); Hu=zeros(Nb,1); Huu=Hu; 
  for i=1:Nb
   [fs,fu,fss,fsu,fuu]=feval(name,uf1(i),s1(i,:),tb(i),3);
   Hu(i)=la(i,:)*fu; Hss=zeros(ns); for j=1:ns
      Hss=Hss+la(i,j)*fss([(j-1)*ns+1:j*ns],:); end
   Huu(i)=la(i,:)*fuu; Hus=la(i,:)*fsu; S=forms(ys(i,:)');
   K(i,:)=Huu(i)\(Hus+fu'*S);    
   du=-Huu(i)\(Hu(i)+fu'*h(i,:)'); 
   uf(i)=uf1(i)+du;
  end
  dua=norm(du)/sqrt(Nb); disp([it phi dua]); 
  %
  % New tu, s, and sn:
  tu=zeros(Nb,1); s=zeros(Nb,ns); sn=s;
  tu=tb; s=s1; sn=s1;
  if mxit==0, break; end
  if it>=mxit, break; end; it=it+1;
end
t=zeros(Nb,1); t=tb;




