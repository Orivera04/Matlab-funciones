% Script p6_2_05.m; LQR for inverted pendulum using eigen=
% system of Hamiltonian matrix;              12/96, 7/17/02
%
H=[0 1 0 0; 1 0 0 -1; -1 0 0 -1; 0 0 -1 0],[V,D]=eig(H);
[dum,l]=sort(real(diag(D))); disp('Eigvec Matrix of H');
disp(V(:,l)); ev=diag(D(:,l)); disp('Eigvals of H'); 
disp(ev); disp('Steady-State S Matrix'); Xm=V([1 2],[1 2]);
Pm=V([3 4],[1 2]); Ss=real(Pm/Xm); disp(Ss); B=[0 1]'; 
K=B'*Ss; disp('Steady-State Gains');
disp(K); for i=1:4, V1(:,i)=V(:,i)/V(3,i); end
disp('Rearranged Eigvec Matrix'); disp(V1);


	    
	