% Script f05_21.m; altitude & velocity change of Navion 
% A/C % using TLQS; x=[u w q th h]'; u=[de dT]'; 2J=
% ef'*Sf*ef+int[de^2+dT^2]dt, ef=Mf*x(tf)-psi; units 
% ft, sec, crad;                           7/97, 4/4/02
%
A=[-.045 .036 0 -.322 0; -.37 -2.02 1.76 0 0;...
   .191 -3.96 -2.98 0 0; 0 0 1 0 0; 0 -1 0 1.76 0];
B=[0 1; -.282 0; -11 0; zeros(2)]; Qf=1e4;
Ns=50; tf=4; x0=[0 0 0 0 0]'; psi=[10 0 0 0 0]';  
Mf=eye(5); Q=zeros(5); N=zeros(5,2); R=eye(2); 
[x,u,t]=tlqs(A,B,Q,N,R,tf,x0,Mf,Qf,psi,Ns);
%
figure(1); clf; subplot(211), plot(t,x([1 4 5],:)); 
grid; text(1.1,-2,'h (ft)'); axis([0 4 -3 10]) 
text(1.1,1.7,'\theta (crad)')
text(1.1,4.5,'du (ft/sec)')
subplot(212), plot(t,u); xlabel('Time (sec)') 
grid; text(1.1,0,'\delta_e (crad)') 
text(1.1,1.75,'\delta_T (ft/sec/sec)')
%print -deps2 \book_do\figures\f05_22
%
tf=2; x0=[0 0 0 0 0]'; psi=[0 0 0 0 10]';
[x,u,t]=tlqs(A,B,Q,N,R,tf,x0,Mf,Qf,psi,Ns);
figure(2); clf; subplot(211), plot(t,x([1 4 5],:)); 
grid; text(1.42,7,'dh (ft)'); 
text(1.42,1,'du (ft/sec)');
text(.45,5.5,'\theta (crad)');
subplot(212), plot(t,u); grid; xlabel('Time (sec)'); 
text(.45,-6.5,'\delta_e (crad)'); 
text(.22,4.5,'\delta_ (ft/sec/sec)')
%print -deps2 \book_do\figures\f05_21



	
