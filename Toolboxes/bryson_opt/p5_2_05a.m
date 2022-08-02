% Script p5_2_05a; trans. matrix soln. of rendezvous problem with 
% soft term. constr; t in tf, v in v0, y in v0*tf, a in v0/tf;
%                                                   5/98, 3/29/02
%
A=[0 1; 0 0]; B=[0 1]'; x0=[0 1]'; Q=zeros(2); N=[0 0]'; R=1;
tf=1; Mf=eye(2); Qf=3e4; psi=[0 0]'; Ns=40;
[x,a,t]=tlqs(A,B,Q,N,R,tf,x0,Mf,Qf,psi,Ns); y=x(1,:); v=x(2,:); 
%
figure(1); clf; subplot(211),plot(t,y); grid; axis([0 1 0 .2])
text(.2,.09,'y/(v_ot_f)=t(1-t)^2'); subplot(212); 
plot(t,a/4,t,v,'-'); grid; axis([0 1 -1 1]); 
text(.25,.52,'v/v_o=(1-t)(1-3t^2)')
text(.65,.6,'at_f/(4*v_o)=1.5t-1'); xlabel('t/t_f')

