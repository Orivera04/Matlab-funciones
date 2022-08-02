% Script p6_2_04.m; LQR for undamped oscillator using eigsystem
% of EL eqns;                                    12/96, 7/17/02
%
Q=1; A=[0 1 0 0; -1 0 0 -1; -Q 0 0 1; 0 0 -1 0]; [V,D]=eig(A); 
[dum,m]=sort(real(diag(D))); disp('Eigvec Matrix of EL Eqns');
disp(V(:,m)); ev=diag(D(:,m)); disp('Eigvals of EL Eqns'); 
disp(ev); disp('Steady-State S Matrix'); Xm=V([1 2],[1 2]);
Pm=V([3 4],[1 2]); Ss=real(Pm/Xm); disp(Ss); B=[0 1]'; K=B'*Ss; 
disp('Steady-State Gains'); disp(K);
for i=1:4, V1(:,i)=V(:,i)/V(3,i); end
disp('Rearranged Eigvec Matrix'); disp(V1);

	    
	