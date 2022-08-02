% Script p6_2_06.m; SRL for helicopter near hover; x=[u q th]';
%                                                    1/98, 7/17/02
%
A=[.026 .013 -.322; 1.26 -1.765 0; 0 1 0]; B=[.086 -7.41 0]'; 
C=[1 0 0]; Q=10.^[-1:.5:5]; N=length(Q); ev=zeros(6,N); R=1;
for i=1:N, H=[A -B*B'; -C'*Q(i)*C -A']; ev(:,i)=eig(H); end
Qi=1e12; z=eig([A -B*B'/R; -C'*Qi*C -A']);
%
figure(1); clf; plot(real(ev),imag(ev),'x',real(z),imag(z),'ro'); 
hold off; grid; xlabel('Real(s) (rad/sec)')
ylabel('Imag(s) (rad/sec)'); axis([-6 0 0 6]); axis('square')
%
A=[A zeros(3,1); 1 0 0 0]; B=[B; 0]; C=[0 0 0 1];
Q=10.^[-1:.5:6]; N=length(Q); ev=zeros(8,N);
for i=1:N, H=[A -B*B'; -C'*Q(i)*C -A']; ev(:,i)=eig(H); end
Qi=1e12; z=eig([A -B*B'/R; -C'*Qi*C -A']);
%
figure(2); clf; plot(real(ev),imag(ev),'x',real(z),imag(z),'ro'); 
hold off; grid; xlabel('Real(s) (rad/sec)')
ylabel('Imag(s) (rad/sec)'); axis([-6 0 0 6]); axis('square')

