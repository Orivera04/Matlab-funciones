function sp=zerm_noc(t,s)			                                                  
% Calculates sp=dot(s) for ZERMelo problem with Neighboring Opt. 
% Control; ship in linear current; thn=nominal optimal control,
% sn=nominal state history, Tn=nominal time-to-go, [K Kt]=
% nbr. opt. feedback gains;                        9/96, 6/13/02	     
%
global thn sn Tn Kt K  
%
% Optimal time-to-go T: finds points i=k & i=k+1 between which
% dT(i) changes sign & interpolates a rough  estimate of T: 
N=length(Tn); k=0; for i=1:N, dT(i)=-Kt(:,i)'*(s-sn(:,i)); end
for i=1:N-1, if dT(i)*dT(i+1)<0, k=i; end; end
ep=dT(k)/(dT(k)-dT(k+1)); T=Tn(k)+ep*(Tn(k+1)-Tn(k));
%
% Refines T by interpolating Kt and sn:
dTi=1; while abs(dTi)>.001,
  Kti=Kt(:,k)+ep*(Kt(:,k+1)-Kt(:,k)); 
  si=sn(:,k)+ep*(sn(:,k+1)-sn(:,k));
  dTi=-Kti'*(s-si); T=T+dTi; ep=(T-Tn(k))/(Tn(k+1)-Tn(k));
end
%
% Finds neighboring optimal control:
thi=thn(k)+ep*(thn(k+1)-thn(k)); Ki=K(:,k)+ep*(K(:,k+1)-K(:,k));
th=thi-Ki'*(s-si);
%
% State rates: 
sp=[cos(th)-s(2); sin(th)];

