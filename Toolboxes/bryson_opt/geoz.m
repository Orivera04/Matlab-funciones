function sp=geoz(ph,th)
% Subroutine for p7_3_3d;                  7/7/02
%
global thf phf; 
num=tan(th)*cos(phf)-tan(thf)*cos(ph);
den=tan(thf)*sin(ph)-tan(th)*sin(phf);
phm=atan(num/den); thm=atan(tan(th)/cos(phm-ph));
be=acos(cos(thm)/cos(th))*sign(phm-ph);
sp=tan(be)*cos(th);