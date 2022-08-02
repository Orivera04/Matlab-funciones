% Script p6_2_12.m; stabilizing an unstable S/C using a CMG;
% s=[th thdot ph phdot]'; om=h/sqrt(Iy*J)=nutation frequency; 
% mu=n*sqrt([3(Iz-Ix)/Iy]=libration frequency; ep=sqrt(J/Iy); units:
% T in J*om^2, t in 1/om, h in J*om, mu in om; PI=int[Q*ph^2+T^2)dt;
%                                                      12/96, 7/17/02
%
ep=1e-2; mu=1e-2; A=[0 1 0 0; mu^2 0 0 -ep; 0 0 0 1; 0 1/ep 0 0]; 
B=[0 0 0 1]'; C=[0 0 1 0]; D=0; Q=[10.^[-3:.5:5] 1e7];
N=length(Q); ev=zeros(4,N); c=pi/180; 
for i=1:N, [k,S,ev(:,i)]=lqr(A,B,Q(i)*C'*C,1); end
z=ev(:,N); ev=ev(:,[1:N-1]); 
Q2=1; [k2,S,e2]=lqr(A,B,Q2*C'*C,1); s0=[c*1 0 0 0]';
sys=ss(A-B*k2,B,C,D); [ph,t,s]=initial(sys,s0); 
ph=ph/c; u=s*k'; th=s(:,1)/c;
%
figure(1); clf; plot(real(ev),imag(ev),'x',real(z), imag(z),'ro',...
 real(e2),imag(e2),'rs'); grid; axis([-1.5 0 0 1.5]); axis('square')
xlabel('Real(s/\omega)'); ylabel('Imag(s/\omega)')
%
figure(2); clf; plot(real(ev),imag(ev),'x',real(z), imag(z),'ro',...
   real(e2),imag(e2),'rs'); grid; axis([-.012 0 0 .012]); 
axis('square'); xlabel('Real(s/\omega)'); ylabel('Imag(s/\omega)')
%
figure(3); clf; subplot(211), H=plot(t,ph,t,th,'r--'); grid
legend(H,'\phi','\theta'); ylabel('deg')   
subplot(212), plot(t,u); grid  
ylabel('T / J\omega^2'); xlabel('\omega t')  
%
% Note the pitch angle theta is brought close to zero in about 20
% nutation periods (.2 of a libration period) but it takes nearly
% 100 libration periods to `desaturate' the CMG using the gravity
% gradient torque, i.e. bring the gyro axis back near zero. An LQ 
% terminal controller could do this in about half the time with
% the same control authority.
 
