function [PrincipleStresses, IPShearMax, ShearMax]=pristress(State,option)
%PRISTRESS Principal stresses.
%   [PS,IPSM,SM]=PRISTRESS([SIGMAX,SIGMAY,TAUXY],OPTION) is the Principle 
%   Stresses, In-Plane Shear Maximum and the Shear Maximum.
%
%   SIGMAX:  Normal stress in the X direction.
%   SIGMAY:  Normal stress in the Y direction.
%   TAUXY:   Shear on the X-Y plane.
%   Together these three are gathered as the STRESSSTATE.
%
%   OPTION: Either 'plane stress' or 'plane strain'.
%
%   See also MOHRS, PPSTRESS, STRESS2STRAIN, STRESSTR.

%   Details are to be found in Mastering Mechanics I, Douglas W. Hull,
%   Prentice Hall, 1998

%   Douglas W. Hull, 1998
%   Copyright (c) 1998-99 by Prentice Hall
%   Version 1.00

option=lower(option);

sx=State(1);
sy=State(2);
txy=State(3);
center=mean([sx,sy]);
radius=sqrt(((sx-sy)/2)^2+txy^2);
PrincipleStresses(1)=center-radius;
PrincipleStresses(2)=center+radius;
if strcmp(option,'plane stress')
  PrincipleStresses(3)=0;
elseif strcmp(option,'plane strain')
  PrincipleStresses(3)=9999;
  disp ('Not fully supported yet: e-mail author for update; hull@mtu.edu');
else 
  disp ('Only options plane strain and plane stress are supported')
  clear PrincipleStresses
  return
end
PrincipleStresses=sort(PrincipleStresses);
IPShearMax=radius;
ShearMax=max([abs(PrincipleStresses/2) radius]);

