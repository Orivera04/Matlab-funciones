% Script f06_08.m; track/sideforce control for 747 in landing 
% configuration (also in CSA); x=[v r p phi psi y]'; u=[da dr]';
% y=[y ay]'; units ft, sec, crad;                   8/92, 4/4/02
%
A=[-.089 -2.19 0 .319 0 0; .076 -.217 -.166 0 0 0; ...  
   -.602 .327 -.975 0 0 0; 0 .15 1 0 0 0; 0 1 0 0 0 0; ...
    1 0 0 0 2.19 0];
B=[0 .0264 .227 0 0 0; .0327 -.151 .0636 0 0 0]';
C=[0 0 0 0 0 1; -.089 0 0 0 0 0]; D=[0 0; 0 .0327];
Qy=diag([1 64]); R=eye(2); Q=C'*Qy*C; N=C'*Qy*D; R=R+D'*Qy*D;
k=lqr(A,B,Q,R,N); ev=eig(A-B*k); x0=[0,0,0,0,0,-10]';
C1=[C-D*k; 0 0 0 1 0 0; 0 0 0 0 1 0; 1 0 0 0 0 0;-k];
D1=zeros(7,2); t=[0:.25:25]'; u=zeros(101,2);
y=lsim(A-B*k,B,C1,D1,u,t,x0); y(:,1)=y(:,1)+10*ones(size(t));
%
figure(1); clf; subplot(211), plot(t,y(:,[1:2])); grid 
axis tight; text(11,8.5,'y (ft)'); text(11,2,'a_y (ft/sec/sec)')
subplot(212), plot(t,y(:,[3:4])); grid; xlabel('Time (sec)')
axis tight; text(11,-1.5,'\phi (deg)'); text(8,1.5,'\psi (deg)')
%print -deps2 \book_do\figures\f06_08
%
figure(2); clf; subplot(211), plot(t,y(:,[6 7])); grid 
axis tight; text(2,6,'\delta a (deg)'); text(4,3,'\delta r (deg)') 
axis([0 25 -5 10]); subplot(212), plot(t,y(:,5)); grid
xlabel('Time (sec)'); text(8,1.5,'v (ft/sec)'); axis tight
%print -deps2 \book_do\figures\f06_09
 