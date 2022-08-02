function [s,K,Hu,phi,psi]=dopcn2(name,un,nu,s0,tf,tol)                    
%DOPCN2 - Disc. Optim. w. term. Constr. using a Nr algor.   		      
%[s,K,Hu,phi,psi]=dopcn2(name,u,nu,s0,tf,tol);
% Uses Riccati matrix S & aux. matrices M, Q; function file'name' 
% calculates f for flg=1,(Phi,Phis,Phiss) for flg=2, and (fs,fu,
% fss,fus,fuu) for flg=3. Inputs: un=init. guess of optimal (scalar)
% ctrl. sequence, nu=init. guess of term. Lagrange mult. vector;
% s0=initial state, tf=final time; tol=tolerance on duavg. Outputs:
% s=optimal state sequence, K=feedback gain sequence, Hu=statio-
% narity condition (should be zero);                   5/97, 5/30/02 
%
N=length(un); ns=length(s0); nt=length(nu); s=zeros(ns,N+1); 
sn=s; K=zeros(N,ns); dua=1; it=0; dt=tf/N; s(:,1)=s0;   
disp('      Iter.     phi     duavg')
while max(dua) > tol,   
 % Forward sequence, storing state histories:
 for i=1:N, 
  u(i)=un(i)-K(i,:)*(s(:,i)-sn(:,i));
  s(:,i+1)=feval(name,u(i),s(:,i),dt,(i-1)*dt,1);
 end
 %
 % Performance index & terminal BCs:
 [Phi,Phis,Phiss]=feval(name,u(N),s(:,N+1),dt,tf,2);
 nt1=length(Phi); nt=nt1-1; phi=Phi(1); psi=Phi([2:nt1]);
 la=Phis'*[1; nu]; S=Phiss([1:ns],[1:ns]);
 for j=1:nt, S=S+nu(j)*Phiss([j*ns+1:(j+1)*ns],:); end
 M1=Phis([2:nt1],:); Q=zeros(nt); K=zeros(N-nt,ns);
 h=zeros(ns,1);
 %
 % Backward sequence, storing du(i) and K(i,:): 
 for i=N:-1:1, t=(i-1)*dt;
  [fs,fu,fss,fsu,fuu]=feval(name,u(:,i),s(:,i),dt,t,3);
  Hu(i)=la'*fu; Zss=zeros(ns); 
 for j=1:ns, Zss=Zss+la(j)*fss([(j-1)*ns+1:j*ns],:); end
 Zss=Zss+fs'*S*fs; Zus=la'*fsu+fu'*S*fs; 
 Zuu=la'*fuu+fu'*S*fu; M=M1*(fs-fu*(Zuu\Zus));
 if i<=N-nt, K(i,:)=Zuu\(Zus+fu'*M1'*(Q\M)); 
  else K(i,:)=zeros(1,ns); end
 du(i)=-Zuu\(fu'*h+Hu(i)');
 la=fs'*la; S=Zss-Zus'*K(i,:); Q=Q+M1*fu*(Zuu\fu')*M1'; M1=M;
 h=fs'*h+Zus'*du(i);
 end
 %
 % New un and sn:
 dua=norm(du)/N; disp([it phi psi dua]; sn=s; un=u+du;
 it=it+1;
end     


