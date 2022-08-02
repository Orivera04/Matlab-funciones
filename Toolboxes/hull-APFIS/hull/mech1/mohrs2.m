function []=mohrs2(StrainState, option, poissons, angle)
%MOHRS2 Draws a Mohr's circle.
%   MOHRS2([EPSX,EPSY,GAMXY],OPTION,POISSONS,ANGLE) Calculates principle
%   strains, maximum shear, and normal and shear strains on a requested
%   plane.  All of these are presented graphically on a Mohr's circle 
%   diagram that can be easily printed out.
%
%   EPSX:    Normal strain in the X direction.
%   EPSY:    Normal strain in the Y direction.
%   GAMXY:   Shear on the X-Y plane.
%   Together these three are gathered as the STRAINSTATE.
%
%   OPTION:  Either 'plane stress' or 'plane strain'.
%   ANGLE:   Optional angle of interest will be highlighted on figure.
%
%   See also MOHRS, PPSTRAIN, PRISTRAIN,  ROSETTE, STRAIN2STRESS,
%      STRAINTR.

%   Details are to be found in Mastering Mechanics I, Douglas W. Hull,
%   Prentice Hall, 1998

%   Douglas W. Hull, 1998
%   Copyright (c) 1998-99 by Prentice Hall
%   Version 1.00


StrainState=StrainState*1e6;
ex=StrainState(1);
ey=StrainState(2);
gxy=StrainState(3);
center=mean([ex,ey]);
[PS, IPShearMax, ShearMax]=pristrain(StrainState,option,poissons);
PP=ppstrain(StrainState)';
radius=IPShearMax/2;
clf
showcirc(radius,[center,0],'r');
hold on
showcirc(PS(2)-mean([PS(1),PS(2)]),[mean([PS(2),PS(1)]),0],'r--');
showcirc(PS(3)-mean([PS(1),PS(3)]),[mean([PS(3),PS(1)]),0],'r--');
showcirc(PS(3)-mean([PS(2),PS(3)]),[mean([PS(3),PS(2)]),0],'r--');
axis ('equal')
edges=axis;
le=edges(1);
hs=(edges(2)-edges(1))/2;
plot ([edges(1)-0.1*edges(1) edges(2)+0.1*edges(2)],[0 0], 'b')
plot ([0,0],[edges(3) edges(4)],'b')
plot (center,0,'ro')
plot ([ex,ey],[-gxy/2,gxy/2],'k')
colA=strvcat('Center:','Maximum In Plane Shear:','Maximum Total Shear:');
colA=strvcat(colA,'Principle Strains:','Principle Planes:');
colB=strvcat(num2str(center,4),num2str(IPShearMax,4),num2str(ShearMax,4));
colB=strvcat(colB,num2str(PS,4),num2str(RD(PP),4));
if nargin==4
  AngleToHorPlane=atan2(gxy/2,(ey-center));
  AngleToRequestPlane=AngleToHorPlane + 2*angle;
  rn=center + radius * cos(AngleToRequestPlane);
  rs=radius * sin(AngleToRequestPlane);
  plot ([center,rn],[0,rs],'r',rn,rs,'rd')
  colA=strvcat(colA,'At angle:','**Normal Strain:','**Shear Strain:');
  colB=strvcat(colB,num2str(RD(angle),4),num2str(rn,4),num2str(rs,4));
end
axis ('equal')
expandaxis (30, 30)
titleblock(colA,colB);
xlabel ('Normal Strain')
ylabel ('Shear Strain/2')
title (strcat('Mohrs circle:   ',option,' mu notation'))
text (ex,-gxy/2,'X')
text (ey,gxy/2,'Y')
hold off
