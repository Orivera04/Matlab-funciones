% Script uh_60.m; UH-60 near hover; ds/dt=A*s+B*d; y=C*s+D*d;
% s=[u v w p q r ph th]'; d=[db da dc dp]'; y=[u v w r,p]'; units: 
% (u v w) in 30 ft/sec, (p q r) in 25 deg/sec, (ph th) in 25 deg; 
% d in deg of swashplate tilt; data from Keeyoung Choi (Advanced
% Rotorcraft Technology);                                 8/12/98
%
A=[-.0187  .0014  .0205 -.0173  .0130 -.0039    0  -.3735; ...
   -.0058 -.0631 -.0007 -.0142 -.0172  .0067 .3731  .0014; ...
    .0271 -.0051 -.3214 -.0029  .0030  .0281 .0173 -.0293; ...
   -.1640 -2.6689 -.0448 -2.9213 -1.4098 .0168  0     0  ; ...
    .0854  .1414  .3035  .2320 -.5368 -.0660    0  -.0001; ...
    .1702  .3348 -.0141 -.1286 -.1190 -.2846    0     0  ; ...
      0      0      0      1   -.0036  .0787    0     0  ; ...
      0      0      0      0    .9989  .0463    0     0  ];
B=[.0198 .0004  .0146     0 ; -.0012  .0197 -.0021 .0067; ...
   .0005 .0001 -.1757 -.0024; -.1249 2.1729 -.1169 .2087; ...
   -.3589 -.0033 .1802 -.0850; .0049  .1286 .3731 -.1919; ...
   0 0 0 0; 0 0 0 0];
C=[eye(3) zeros(3,5); zeros(1,5) 1 0 0]; D=zeros(4);
%
% LQR stabilization:
[K,S,ev]=lqr(A,B,200*C'*C,eye(4));
%
% Step response to command for (u,w)=(10,-2) knots, v=r=0:
C1=eye(8); D1=zeros(8,4); yc=(6076/3600)*(1/30)*[10 0 -2 0]'; t=[0:.075:15];
[y,y1,d]=stepcmd(A,B,C,D,K,yc,C1,D1,t);
u=(30*3600/6076)*y(:,1); v=(30*3600/6076)*y(:,2); w=(30*3600/6076)*y(:,3); 
%
figure(1); clf; subplot(221), plot(t,u,t,v,'r--',t,w,'k-.'); grid; 
legend('u','v','w',2); hold on; plot([0 8],[10 10],'b-.',[0 8],...
   [-2 -2],'k-.',[0 8],[0 0],'r--'); ylabel('knots'); hold off;
subplot(222), plot(t,25*y1(:,[4:6]),[0 8],[0 0],'r-.'); grid;
ylabel('deg/sec'); subplot(223), plot(t,d); grid; 
legend('\delta_b','\delta_a','\delta_c','\delta_p'); 
axis([0 15 -3 8]); ylabel('deg'); xlabel('Time (sec)'); 
subplot(224), plot(t,25*y1(:,[7:8])); grid;
legend('\phi','\theta',4); ylabel('deg'); xlabel('Time (sec)');
 
