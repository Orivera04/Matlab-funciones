% Script p5_2_19.m; 747 landing flare using TLQS; s=[du dw q th h dt]';
% d=[de dtc]'; units ft, sec, crad; sdot=As+Bd;           8/97, 3/31/02
%
flg=2; A=[-.021 .122 0 -.322 0 1; -.209 -.530 2.21 0 0 -.044; .017 ...
   -.164 -.412 0 0 .544; 0 0 1 0 0 0; 0 -1 0 2.21 0 0; 0 0 0 0 0 -.25];
B=[.010 -.064 -.378 0 0 0; 0 0 0 0 0 .25]'; Q=zeros(6); N=zeros(6,2);
R=diag([1 1/3]); tf=8; Mf=[1 0 0 0 0 0; 0 0 0 0 1 0; 0 -1 0 2.21 0 0];
Qf=1e5; psi=[-15 0 -2]'; Ns=160; tol=1e-4;  
%
% Equilibrium state on glide slope:
ga0=2.5*pi/180; hdot0=-221*ga0;                % ga0=glide slope angle
A4=A([1:4],[1:4]); B4=[B([1:4],1) A([1:4],6)]; D4=zeros(2);
C4=[1 0 0 0; 0 -1 0 2.21]; su0=[A4 B4; C4 D4]\[0 0 0 0 0 hdot0]';
dw0=su0(2); th0=su0(4); dt0=su0(6); s0=[su0(1:4); 65; dt0];  
%
if flg==1, [s,d,t]=tlqs(A,B,Q,N,R,tf,s0,Mf,Qf,psi,Ns); du=s(1,:);
   dw=s(2,:); th=s(4,:); h=s(5,:); dt=s(6,:); hd=-dw+2.21*th;
   de0=su0(5); de=d(1,:); dtc=d(2,:);
elseif flg==2, [s,d,t,tk,K,uf]=tlqsr(A,B,Q,N,R,tf,s0,Mf,Qf,psi,tol);
   Nt=length(t); un=ones(Nt,1); du=s(:,1); dw=s(:,2); th=s(:,4);
   h=s(:,5); dt=s(:,6); hd=-dw+2.21*th; de0=su0(5); Nk=length(tk);
   tk1=tk([80:Nk]); K1=K([80:Nk],:); uf1=uf([80:Nk],:);
end;
%
if flg==1, figure(1); clf; subplot(211), plot(t,h); grid;
 ylabel('h (ft)'); subplot(212), plot(t,du,t,th,'r--',t,hd,'k-.'); 
 grid; legend('\delta u (ft/sec)','\theta (crad)','hdot (ft/sec)',2); 
xlabel('Time (sec)');
%
figure(2); clf; subplot(211), 
plot(t,de,t,dtc,'r--',t,dt,'k-.',0,de0,'ro'); grid; xlabel('Time (sec)'); 
legend('\delta_e (crad)','\delta_{tc} (ft/sec/sec)',...
      '\delta_t (ft/sec/sec)',3);
%
elseif flg==2, figure(1); clf; subplot(211), plot(t,[du th hd]); grid;
text(1.2,2,'\delta u (ft/sec)'); text(1.2,-3.5,'\theta (crad)');
text(1.2,-8,'hdot (ft/sec)'); xlabel('Time (sec)');
subplot(212); plot(tk1,uf1); grid; axis([0 8 -100 10]);
text(5.1,-50,'\delta e (crad)'); ylabel('Fdfwd Control Signals');
text(2.5,-22,'\delta T_c (ft/sec/sec)'); xlabel('Time (sec)');
%
figure(2); clf; subplot(211), plot(t,h); grid; ylabel('h (ft)');
subplot(212), plot(t,d,t,dt,0,de0,'ro'); grid; xlabel('Time (sec)');
text(.6,.5,'\delta e (crad)'); text(5.2,-2,'\delta T (ft/sec/sec)');
text(.6,-5.5,'\delta_T_c (ft/sec/sec)');
%
figure(3); clf; subplot(211); plot(tk1,K1(:,[1:6])); grid;
ylabel('Throttle Fdbk Gains'); axis([0 8 -220 600]);
subplot(212); plot(tk1,K1(:,[7:12])); grid; axis([0 8 -100 300]);
ylabel('Elevator Fdbk Gains'); xlabel('Time (sec)');
end
