% Script zerm_nom.m; nominal optimum path & perturbation feedback
% gains for Ex.8.2.2 (ZERMelo problem, ship in linearly-varying 
% current); thn=nom. opt. control, sn=[x y]=nom. state histories, 
% Tn=nom. time-to-go, [Kt K]=perturb. feedback gains; 9/96, 7/5/02	     
%
global thn Tn sn K Kt
%
% Nominal control history th:
c=pi/180; thn=c*[100:5:235]; 
%
% Nominal time-to-go Tn:
N=length(thn); un=ones(1,N); ta=tan(thn); thf=c*240; taf=tan(thf);
Tn=un*taf-ta; 
%
% Nominal state histories:
sc=un./cos(thn); scf=1/cos(thf); yn=sc-un*scf;
xn=(un*asinh(taf)-asinh(ta)-yn.*ta-Tn*scf)/2;
sn=[xn; yn];
%
% Perturbation time-to-go feedback gains:
Kt=cos(thf)*[un; ta];
%
% Perturbation state feedback gains:
xth=(sc-abs(sc))/2+sc.^2.*(un*scf-sc); yth=sc.*ta; 
xthf=un*(scf+abs(scf))/2-scf*(un*scf^2-ta*taf);
ythf=-un*taf*scf; D=xth.*ythf-xthf.*yth; 
K=[-ythf./D; xthf./D];  
