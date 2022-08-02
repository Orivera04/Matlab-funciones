function [u,s,K,Hu,Zuu]=dop0n2(name,un,s0,tf,tol)
%[u,s,K,Hu,Zuu]=dop0n2(name,un,s0,tf,tol)
% Discrete OPtim. w. 0 term. constr. using a Nr algor. with 2nd
% deriv. propagated by bkwd Ricc. eqn; function file 'name' should
% be in the MATLAB path & calculate f for flg=1, (phi,phis,phiss)
% for flg=2, and (fs,fu,fss,fus,fuu) for flg=3; un=initial guess of
% (scalar) control sequence; s0=initial state; tf=final time; tol=
% tolerance on duavg;                                 4/97, 8/21/02 
%
N=length(un); ns=length(s0); s=zeros(ns,N+1); sn=s; K=zeros(N,ns);
dua=1; it=0; dt=tf/N; s(:,1)=s0;   
disp('      Iter.     phi     duavg')
while max(dua) > tol,                                        
 % Forward sequence, storing state histories:
  for i=1:N, t=(i-1)*dt; u(i)=un(i)-K(i,:)*(s(:,i)-sn(:,i));  
   s(:,i+1)=feval(name,u(i),s(:,i),dt,t,1);
  end
 % Performance index and terminal boundary conditions:
  [phi,phis,phiss]=feval(name,0,s(:,N+1),0,0,2); 
  la=phis'; S=phiss; h=zeros(ns,1);
 % Backward sequence, storing du(i) and K(i,:): 
  for i=N:-1:1, t=(i-1)*dt;
   [fs,fu,fss,fus,fuu]=feval(name,u(i),s(:,i),dt,t,3);
   Hu(i)=la'*fu; Zss=zeros(ns); 
   for j=1:ns, Zss=Zss+la(j)*fss([(j-1)*ns+1:j*ns],:); end
   Zss=Zss+fs'*S*fs; Zus=la'*fus+fu'*S*fs; Zuu(i)=la'*fuu+fu'*S*fu;
   K(i,:)=Zuu(i)\Zus; du(i)=-Zuu(i)\(fu'*h+Hu(i));                                  
   la=fs'*la; S=Zss-Zus'*K(i,:); h=fs'*h+Zus'*du(i);
  end
 % New un and sn:
  dua=norm(du)/N; disp([it phi dua]); un=u+du; sn=s; it=it+1;
end

