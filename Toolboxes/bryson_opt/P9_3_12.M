% Script p9_3_12.m; max range glide using energy-state approx 
% (analytical solution); compare to mass-point solution of 
% e09_3_2.m;                                        5/97, 3/31/02
%
alm=1/12; eta=.5;; gas=atan(2*eta*alm); Vs=sqrt(cos(gas)/alm);
V0=1.1*Vs; h0=1; E0=h0+V0^2/2; E2=Vs^2/2; E12=[E0:(E2-E0)/18:E2];
x12=(E0*ones(1,19)-E12)/tan(gas); x1=x12(19); Vf=1/sqrt(3*alm);
Ef=Vf^2/2; a=4*alm^2; E2f=[E2:(Ef-E2)/20:Ef]; 
for i=21:-1:1,
 x2f(i)=x1+(1/(eta*a))*log((1+a*E2^2)/(1+a*E2f(i)^2));
end; xa=[x12 x2f]; Ea=[E12 E2f];
%
figure(1); clf; plot(xa,Ea,'r.'); grid; hold on;
load \book_do\examples\glid1; E=h+V.^2/2; E=[E Ef]; x=[x -f];
plot(x,E); hold off; axis([0 70 0 9]); xlabel('x - Range');
ylabel('E - Energy'); legend('E_{approx}','E_{exact}');
title('Pb. 9.3.12 - Max Range Glide Using Energy-State Approximation');
	