% Script p5_5_19.m; 747 landing flare using TDLQH; x=[du,dw,q,th,h,dt]';
% d=[de,dtc]'; units ft, sec, crad;                        9/97, 7/25/02
%
flg=1; A=[-.021 .122 0 -.322 0 1; -.209 -.530 2.21 0 0 -.044; .017 ...
  -.164 -.412 0 0 .544; 0 0 1 0 0 0; 0 -1 0 2.21 0 0; 0 0 0 0 0 -.25];
B=[.010 -.064 -.378 0 0 0; 0 0 0 0 0 .25]'; N=80; tf=8; Ts=tf/N; 
[Ad,Bd]=c2d(A,B,Ts); Qd=zeros(6); Nd=zeros(6,2); Rd=diag([1 1/3]);
Sf=zeros(6); Mf=[1 0 0 0 0 0; 0 0 0 0 1 0; 0 -1 0 2.21 0 0]; nf=7;
%
% Initial state:
ga0=2.5*pi/180; hdot0=-221*ga0; A4=A([1:4],[1:4]); B4=[B([1:4],1) ...
   A([1:4],6)]; C4=[1 0 0 0; 0 -1 0 2.21]; D4=zeros(2);
xu0=[A4 B4; C4 D4]\[0 0 0 0 0 hdot0]'; dt0=xu0(6); psi=[-15 0 -2]';  
x0=[xu0([1:4]); 65; dt0]; de0=xu0(5);  
%
% Synthesize control and simulate:
if flg==1, [x,d]=tdlqh(Ad,Bd,Qd,Nd,Rd,x0,Sf,Mf,psi,Ts,N); 
elseif flg==2, [x,d]=tdlqhr(Ad,Bd,Qd,Nd,Rd,x0,Sf,Mf,psi,Ts,N,nf);
end; t=tf*[0:1/N:1]; du=x(1,:); dw=x(2,:); th=x(4,:); h=x(5,:);
dt=x(6,:); hd=-dw+2.21*th; de=d(1,:); dtc=d(2,:); deh=[de de(N)];
dtch=[dtc dtc(N)];
%
figure(1); clf; subplot(211), plot(t,h); grid; ylabel('h (ft)')
subplot(212), zohplot(t,deh); hold on; zohplot(t,dtch,'r--'); 
plot(t,dt,'k-.'); grid; xlabel('Time (sec)') 
legend('\delta e (crad)','\delta T_c (ft/sec/sec)',...
   '\delta T (ft/sec/sec)',3)
%
figure(2); clf; subplot(211), plot(t,du,t,th,'r--',t,hd,'k-.'); grid
legend('du (ft/sec)','\theta (crad)','hdot (ft/sec)',2) 
xlabel('Time (sec)')
