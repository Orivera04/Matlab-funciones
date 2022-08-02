function [s,K,Kf,Hu,phi,psi]=dampc(name,u,nu,s0,tf,psi)                    
%DAMPC - Discrete Auxiliary Minimum Problem w. term. Constraints    		      
%[s,K,Kf,Hu,phi,psi]=dampc(name,u,nu,s0,tf);
% Bkwd sweep of Riccati matrix S & aux. matrices M, Q; fcn. file 
% 'name' should calculate f for flg=1,(Phi,Phis,Phiss) for flg=2,
% (fs,fu,fss,fus,fuu) for flg=3. Inputs: u=candidate optimal ctrl. 
% sequence, nu=term. Lagrange mult. vector, s0=initial state, tf=
% final time, psi=desired value of term. constraints. Outputs: s=
% optimal state sequence, (K,Kf)=feedback gain sequences, Hu=sta-
% tionarity condition (should be zero);                 5/97, 5/30/02 
%
% Optimum s(i) sequence:
N=length(u); ns=length(s0); s=zeros(ns,N+1); dt=tf/N; s(:,1)=s0;
for i=1:N, s(:,i+1)=feval(name,u(i),s(:,i),dt,(i-1)*dt,1); end
%
% Nbr. Opt. Fdbk. Gains K(i,:) using a Backward Sweep: 
[Phi,Phis,Phiss]=feval(name,u(N),s(:,N+1),dt,tf,2); nt1=length(Phi); 
nt=nt1-1; if nargin<6, psi=zeros(nt,1); end; phi=Phi(1); 
psi=Phi([2:nt1]); la=Phis'*[1; nu]; S=Phiss([1:ns],[1:ns]); 
for j=1:nt, S=S+nu(j)*Phiss([j*ns+1:(j+1)*ns],:); end
M1=Phis([2:nt1],:); Q=zeros(nt); K=zeros(N-nt,ns); Kf=zeros(N-nt,nt); 
for i=N:-1:1
 [fs,fu,fss,fsu,fuu]=feval(name,u(:,i),s(:,i),dt,(i-1)*dt,3);
 Hu(i)=la'*fu; Zss=zeros(ns); 
 for j=1:ns, Zss=Zss+la(j)*fss([(j-1)*ns+1:j*ns],:); end
 Zss=Zss+fs'*S*fs; Zus=la'*fsu+fu'*S*fs; Zuu=la'*fuu+fu'*S*fu;
 M=M1*(fs-fu*(Zuu\Zus));
 if i<=N-nt, 
     K(i,:)=  Zuu\(Zus+fu'*M1'*(Q\M));
     Kf(i,:)=(Zuu\fu')*(M1'/Q);
 else K(i,:)=zeros(1,ns); Kf(i,:)=zeros(1,nt); 
 end
 S=Zss-Zus'*(Zuu\Zus); Q=Q+M1*fu*(Zuu\fu')*M1';  M1=M; la=fs'*la;
end
    


