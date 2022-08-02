% Script uh_60f.m; UH-60 near hover; ds/dt=A*s+B*d; y=C*s+D*d;
% s=[u v w p q r ph th]'; d=[db da dc dp]'; y=[u v w r,p]'; units: 
% (u v w) in 30 ft/sec, (p q r) in 25 deg/sec, (ph th) in 25 deg; 
% d in deg of swashplate tilt; data from Keeyoung Choi (Advanced
% Rotorcraft Technology);                                  8/12/98
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
Am=[0 1 0 0 0; -.8 -1.6 0 0 0; 0 0 -2.9 0 0; 0 0 0 -1 0; ...
    0 0 0 0 -2.9]; 
Bm=[0 0 0 0; .8 0 0 0; 0 2.9 0 0; 0 0 1 0; 0 0 0 2.9];
Cm=[1 zeros(1,4); zeros(3,2) eye(3)]; Dm=zeros(4);
%
% Feedback gains:
[K,S,ev]=lqr(A,B,200*C'*C,eye(4));
%
% Feedforward:
[XX,UX,XU,UU]=modfol(A,B,C,D,Am,Bm,Cm,Dm);
um=(6076/3600)*(1/30)*[10 0 -2 0]'; t=[0:.075:15]';
sys=ss(Am,Bm*um,Cm,Dm*um); [ym,tm,xm]=step(sys,t);
um1=um; for i=1:200, um1=[um1 um]; end
d=UX*xm'+UU*um1+K*(XX*xm'+XU*um1);         % Fdfwd controls
um=(30*3600/6076)*ym(:,1); vm=(30*3600/6076)*ym(:,2);
wm=(30*3600/6076)*ym(:,3); 
%
% Simulate with fdfwd + fdbk:
sys1=ss(A-B*K,B,C,D); [y,ts,x]=lsim(sys1,d,tm);
u=(30*3600/6076)*y(:,1); v=(30*3600/6076)*y(:,2);
w=(30*3600/6076)*y(:,3); p=25*x(:,4); q=25*x(:,5); r=25*x(:,6);
db=d(1,:)-K(1,:)*x'; da=d(2,:)-K(2,:)*x'; dc=d(3,:)-K(3,:)*x'; 
dp=d(4,:)-K(4,:)*x'; ph=25*x(:,7); th=25*x(:,8);
%
figure(1); clf; subplot(221), plot(ts,u,'b-',ts,v,'r--',ts,w,'k-.');
grid; legend('u','v','w',2); hold on; 
plot(ts,um,'b--',ts,vm,'r--',ts,wm,'k--'); ylabel('knots'); hold off;
subplot(222), plot(ts,q,'b-',ts,p,'r--',ts,r,'k-.'); grid; 
legend('q','p','r',4); ylabel('deg/sec'); subplot(223),
plot(ts,db,'b-',ts,da,'r--',ts,dc,'k-.',ts,dp,'c:'); grid; 
legend('\delta_b','\delta_a','\delta_c','\delta_p'); 
axis([0 15 -1 3]); ylabel('deg swashplate tilt'); xlabel('Time (sec)'); 
subplot(224), plot(ts,th,'b-',ts,ph,'r--'); grid;
legend('\theta','\phi',4); ylabel('deg'); xlabel('Time (sec)');
 
