function [PriStrains, IPShearMax, ShearMax]=pristrai(State,option,poisonts)
%PRISTRAIN Principal strains.
%   [PS,IPSM,SM]=PRISTRESS([EPSX,EPSY,GAMXY],OPTION) is the Principle 
%   Stresses, In-Plane Shear Maximum and the Shear Maximum.
%
%   EPSMAX:  Normal strain in the X direction.
%   EPSMAY:  Normal strain in the Y direction.
%   GAMXY:   Shear on the X-Y plane.
%   Together these three are gathered as the STRAINSTATE.
%
%   OPTION:  Either 'plane stress' or 'plane strain'.
%
%   See also MOHRS2, PPSTRAIN, ROSETTE, STRAIN2STRESS, STRAINTR.

%   Details are to be found in Mastering Mechanics I, Douglas W. Hull,
%   Prentice Hall, 1998

%   Douglas W. Hull, 1998
%   Copyright (c) 1998-99 by Prentice Hall
%   Version 1.00

option=lower(option);

if nargin==2
  poisonts=0.3;
end %default poisonts
ex=State(1);
ey=State(2);
gxy=State(3);
center=mean([ex,ey]);
radius=sqrt(((ex-ey)/2)^2+(gxy/2)^2);
PrincipleStrains(1)=center-radius;
PrincipleStrains(2)=center+radius;
if strcmp(option,'plane stress')
  PrincipleStrains(3)=(-1*(poisonts/(1-poisonts)))*(ex+ey);
elseif strcmp(option,'plane strain')
  PrincipleStrains(3)=0;
else 
  disp ('Only options plane strain and plane stress are supported')
end
PriStrains=sort(PrincipleStrains);
IPShearMax=radius*2;
ShearMax=PriStrains(3)-PriStrains(1);
