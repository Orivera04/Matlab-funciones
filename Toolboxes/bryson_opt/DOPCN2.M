function [u,s,K,phi,psi]=dopcn2(name,un,nu,s0,tf,tol)
%[u,s,K,phi,psi]=dopcn2(name,un,nu,s0,psi,tf,tol) 
% Discrete OPtimization w. hard term. Constraints; uses NR algor. w.
% 2nd deriv. propagated by bkwd Ricc. eqn; fcn file 'name' should  
% calculate f for flg=1, (Phi,Phis,Phiss) for flg=2, and (fs,fu,fss,
% fus,fuu) for flg=3. Inputs: un(i)=initial guess of (scalar) control
% sequence, nu=initial guess of term. Lagrange multiplier vector, s0=
% initial state; tf=final time; tol=tolerance on duavg. Outputs: (u,s)
% =optimal (control, state) histories; K=neighboring optimum feedback
% gain history; phi=perf. index, psi=values of terminal constraints; 
%                                                       4/97, 5/29/02 
%
N=length(un); ns=length(s0); s=zeros(ns,N+1); sn=s; 
Phi=feval(name,0,s0,0,0,2); nt=length(Phi)-1; K=zeros(N-nt,ns); 
ep=1; dua=1; it=0; dt=tf/N; s(:,1)=s0; 
disp('      Iter.     phi      fm      duavg')
while max([dua fm]))>tol,                                        
 % Forward sequence, storing state history sn:
 for i=1:N, u(i)=un(i)-K(i,:)*(s(:,i)-sn(:,i)); t=(i-1)*dt; 
        s(:,i+1)=feval(name,u(i),s(:,i),dt,t,1);
 end; sn=s;
 %P=inv([Zsu fs'; Zuu fu']);
 %la=las*(s(:,N-nt+1)-sn(:,N-nt+1));
 %for i=N-nt+1:N,
 % ds=s(:,i)-sn(:,i); dul=P*[la-Zss*ds; -Zus*ds];
 % u(i)=un(i)+dul(1,:); la=dul([2:ns+1],:); 
 % s(:,i+1)=feval(name,u(i),s(:,i),dt,t,1);
 %end
 % Performance index and terminal boundary conditions:
 [Phi,Phis,Phiss]=feval(name,0,s(:,N+1),0,0,2);
 phi=Phi(1); psi=Phi([2:nt+1]); la=Phis'*[1;nu']; h=zeros(ns,1);
 S=Phiss([1:ns],[1:ns]); 
 for j=1:nt, S=S+nu(j)*Phiss([j*ns+1:(j+1)*ns],:); end
 M1=Phis([2:nt+1],:); Q=zeros(nt); 
 %
 % Backward sequence, storing K and un:
 for i=N:-1:1, t=(i-1)*dt;
  [fs,fu,fss,fus,fuu]=feval(name,u(i),s(:,i),dt,t,3);
  Hu(i)=la'*fu; Zss=zeros(ns); for j=1:ns
    Zss=Zss+la(j)*fss([(j-1)*ns+1:j*ns],:); end
  Zss=Zss+fs'*S*fs; Zus=la'*fus+fu'*S*fs;
  Zsu=Zus'; Zuu=la'*fuu+fu'*S*fu;
  Q=Q+M1*fu*(Zuu*fu')*M1; M=M1*(fs-fu*(Zuu\Zsu'));
  if i<=N-nt, K(i,:)=Zuu\(Zus+fu*M1'*(Q\M)); end
  if i==N-nt, K(i,:)=zeros(ns,1); end
  %las=(S+M'*(Q\M)); 
  %du(i)=-Zuu\(fu'*h+Hu(i));                                  
  la=fs'*la; S=Zss-Zsu*K(i,:); h=fs'*h+Zsu*du(i);
 end
 un=u+du; dua=norm(du)/N; fm=max([Hu psi']);
 disp([it phi fm dua]); it=it+1;
end


% 4/20/97; Open loop E-L EQNS. FROM i=N-nt TO N NOT RIGHT YET!