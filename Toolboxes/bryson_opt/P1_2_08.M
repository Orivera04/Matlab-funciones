% Script p1_2_08.m; solves Pbs. 1.2.8(d) & (e); min glide angle and
% min descent rate;                                  10/96, 6/27/02
%
% Part (d);
alm=1/12; eta=1/2; al=alm; ga=atan(2*eta*alm); V=sqrt(cos(ga)/al);
disp('      al         ga       V      Vsin(ga)')
disp([al ga V V*sin(ga)])
%
% Part (e)
ze=1/(2*eta*alm); al=alm*sqrt(ze^2-1-sqrt(ze^4-8*ze^2));
ga=atan(eta*(al+alm^2/al)); V=sqrt(cos(ga)/al);
disp([al ga V V*sin(ga)])
%
% Alternate part (e)
optn=optimset('Display','Iter');
al2=fminbnd('drate',1.4*alm,2.2*alm,optn,alm,eta),
drmin=drate(al2,alm,eta), V=1/(al2^2+eta^2*(al2^2+alm^2)^2)^(1/4)
ga=atan(eta*(al2+alm^2/al2))
%
al1=[1.4:.02:2.2]*alm; 
for i=1:length(al1), J(i)=drate(al1(i),alm,eta); end
%
figure(1); clf; plot(al1/alm,J,al2/alm,drmin,'o'); grid
ylabel('Descent Rate/sqrt(gl)'); xlabel('\alpha/\alpha_m')
   
