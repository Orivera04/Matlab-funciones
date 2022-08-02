function []=mohrs(StressState, option, angle)
%MOHRS Draws a Mohr's circle.
%   MOHRS([SIGMAX,SIGMAY,TAUXY],OPTION,ANGLE) Calculates principle stresses,
%   maximum shear, and normal and shear stress on a requested plane.  All of
%   these are presented graphically on a Mohr's circle diagram that can be
%   easily printed out.
%
%   SIGMAX:  Normal stress in the X direction.
%   SIGMAY:  Normal stress in the Y direction.
%   TAUXY:   Shear on the X-Y plane.
%   Together these three are gathered as the STRESSSTATE.
%
%   OPTION: Either 'plane stress' or 'plane strain'.
%   ANGLE: Optional angle of interest will be highlighted on figure.
%
%   See also MOHRS2, PPSTRESS, PRISTRESS, STRESS2STRAIN, STRESSTR.

%   Details are to be found in Mastering Mechanics I, Douglas W. Hull,
%   Prentice Hall, 1998

%   Douglas W. Hull, 1998
%   Copyright (c) 1998-99 by Prentice Hall
%   Version 1.00



sx=StressState(1);
sy=StressState(2);
txy=StressState(3);
center=mean([sx,sy]);
[PrincipleStresses, IPShearMax, ShearMax]=pristress(StressState, option);
PP=ppstress(StressState)';
radius=IPShearMax;
clf
showcirc(radius,[center,0],'r');
hold on
showcirc(PrincipleStresses(1)/2,[PrincipleStresses(1)/2,0],'r--');
showcirc(PrincipleStresses(2)/2,[PrincipleStresses(2)/2,0],'r--');
showcirc(PrincipleStresses(3)/2,[PrincipleStresses(3)/2,0],'r--');
axis ('equal')
edges=axis;
le=edges(1);
hs=(edges(2)-edges(1))/2;
plot ([edges(1)-0.1*edges(1) edges(2)+0.1*edges(2)],[0 0],'b')
plot ([0,0],[edges(3) edges(4)],'b')
plot (center,0,'ro')
plot ([sx,sy],[-txy,txy],'k')
colA=strvcat('Center:','Maximum In Plane Shear:','Maximum Total Shear:');
colA=strvcat(colA,'Principle Stresses:','Principle Planes:');
colB=strvcat(num2str(center,4),num2str(IPShearMax,4),num2str(ShearMax,4));
colB=strvcat(colB,num2str(PrincipleStresses,4),num2str(RD(PP),4));
if nargin==3
  AngleToHorPlane=atan2(txy,(sy-center));
  AngleToRequestPlane=AngleToHorPlane + 2*angle;
  rn=center + radius * cos(AngleToRequestPlane);
  rs=radius * sin(AngleToRequestPlane);
  plot ([center,rn],[0,rs],'r',rn,rs,'rd')
  colA=strvcat(colA,'At angle:','**Normal Stress:','**Shear Stress:');
  colB=strvcat(colB,num2str(RD(angle),4),num2str(rn,4),num2str(rs,4));
end
axis ('equal')
colA=strvcat(colA,'Negative shear causes CCW rotation of element.');
colB=strvcat(colB,' ');
expandaxis (30, 30)
titleblock(colA,colB);
xlabel ('Normal Stress')
ylabel ('Shear Stress')
title (strcat('Mohrs circle:   ',option))
text (sx,-txy,'V')
text (sy,txy,'H')
hold off

