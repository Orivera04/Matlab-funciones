% Script e02_3_3.m; analytical solution for minimum drag nose shape
% in hypersonic flow (Isaac Newton, 1686);            1/98, 6/24/02
%
el1=[1:4]; optn=optimset('Display','Iter','MaxIter',100);  
figure(1); clf; 
for i=1:4,
 el=el1(i); uo=.5; 
 uo=fsolve('newton',uo,optn,el); rl=4*uo^3/(1+uo^2)^2;
 du=(1-uo)/100; u=[uo:du:1]; un=ones(1,101);
 r=rl*(1+u.^2).^2./(4*u.^3);
 lx=(rl/4)*(3./(4*u.^4)+un./u.^2-7*un/4+log(u)); x=el*un-lx;
 %
 plot(x,r,x,-r,'b',[el el],[-r(101) r(101)],'b'); hold on
end; hold off; axis([0 4 -1.1 1.1]); grid
ylabel('r/a'); xlabel('x/a'); text(3.15,-.5,'C_d = .098')
text(.6,-.3,'.750'); text(1.35,-.3,'.321'); text(2.1,-.3,'.165')
