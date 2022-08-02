% Script f05_03.m; perfect rendezvous example for double 
% integrator plant; t in tf; v in vo, y in vo*tf, a in vo/tf;
% nu=[nu_y nu_v]';                                 2/94, 4/3/02
%
D=1/12; A=[1 -1/2; -1/2 1/3]; b=[1 1]'; nu=A*b/D; t=[0:.01:1]';
U=ones(101,1); T=U-t; T2=T.*T; a=-nu(1)*T-nu(2)*U; 
v=nu(1)*(T2-U)/2-nu(2)*t+U; 
y=-nu(1)*(T2.*T-U)/6-nu(2)*(T2-U)/2+(1-nu(1)/2-nu(2))*t;
% 
figure(1); clf; subplot(211), plot(t,y); grid
axis([0 1 0 .15]); text(.46,.06,'y/(v_ot_f)');
subplot(212), plot(t,a/4,t,v,'-'); grid; axis([0 1 -1 1])
text(.28,.52,'v/vo'); text(.68,.52,'at_f/(4v_o)')
xlabel('t/t_f')
%print -deps2 f05_03
