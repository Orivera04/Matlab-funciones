% Script p6_2_15.m; cont. ctrl. helic. (OH-6A) deceleration to hover w.
% const. gains; s=[u w q theta v r p phi psi x y h]'; d=[dc de da dr]'; 
% s in ft, sec, crad, d in deci-in;                       9/97, 7/17/02 
%
A11=[-.0257 .0113 .013 -.3216; -.0422 -.3404 .0001 -.0093; ...
        1.26 -.6 -1.7645 0; 0 0 .9986 0];
A12=[.0004 -.0006 -.0081 0; -.044 .0147 .0005 .0171; ...
        -.26 .0719 .3763 0; 0 .0532 0 0];
A21=[.0158 -.0194 -.0084 0; -2.62 3.1 -.1724 0; ...
        .03 -.19 -1.136 0; 0 0 -.0015 0];
A22=[-.0435 .0034 -.0134 .3216; -.170 -.8645 -1.075 0; ...
     -4.620 -.2873 -4.92 0; 0 .0289 1 0]; A=[A11 A12; A21 A22];
A=[A zeros(8,4); 0 0 0 0 0 1 0 0 0 0 0 0; ...
   1 zeros(1,11); 0 -1 zeros(1,10); 0 0 0 0 1 zeros(1,7)];
B=[.0216 .086 -.0028 -.003; -.7343 -.0016 .0011 -.003; -.785 -7.408 ...
   .35 -.096; 0 0 0 0; -.0057 .0038 .0514 .153; 9.507 .493 1.982 ...
   -25.68; 1.206 1.874 12.79 -.781; zeros(5,4)];
C=[zeros(4,8) eye(4)]; N=zeros(12,4); Qy=eye(4); Q=C'*Qy*C; R=Qy; tf=6;
s0=[10 1 0 -.3555 0 0 0 .1714 0 -15 0 1.5]';
[k,S,ev]=lqr(A,B,Q,R); sys=ss(A-B*k,B,C,zeros(4)); 
[y,t,s]=initial(sys,s0,6); d=-k*s'; 
%
figure(1); clf; subplot(211), plot(t,s(:,[1 2 5 6])); grid 
axis([0 6 -2 10]); text(1.25,7,'u'); text(1.2,-1.5,'v')
text(2.1,.9,'r'); text(.6,1.2,'w'); ylabel('ft/sec & crad/sec')
subplot(212), plot(t',d(1,:)); hold on; plot(t',d(2,:),'r--');
plot(t',d(3,:),'k-.'); plot(t',d(4,:),'c:'); grid
xlabel('Time (sec)'); hold off; ylabel('deci-inches') 
legend('\delta_c','\delta_e','\delta_a','\delta_r',4) 
%
figure(2); clf; subplot(211), plot(t,s(:,[4 8 9])); grid
ylabel('crad'); axis([0 6 -5 25]); text(.6,12,'\theta')
text(1.9,4.5,'\phi'); text(.6,2,'\psi')
subplot(212), plot(t,s(:,[10:12])); grid; xlabel('Time (sec)')
ylabel('ft'); text(1.1,-7,'x'); text(1.1,3,'h'); text(1.1,-2.5,'y')
   
      