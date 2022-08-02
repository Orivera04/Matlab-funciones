function [StressState] = rain2ess(StrainState,E,poisonts)
%STRAIN2STRESS Converts strain to stress.
%   STRAIN2STRESS([EPSX,EPSY,GAMXY],E,POISSONS) Converts a strain state 
%   to the equivalent stress state.
%
%   EPSX:  Normal strain in the X direction.
%   EPSY:  Normal strain in the Y direction.
%   GAMXY:   Shear on the X-Y plane.
%   Together these three are gathered as the STRAINSTATE.
%
%   E:       Young's Modulus
%   POISSONS:Poisson's ratio.
%
%   See also MOHRS2, PPSTRAIN, PRISTRAIN, ROSETTE, STRAINTR,
%      STRESS2STRAIN.

%   Details are to be found in Mastering Mechanics I, Douglas W. Hull,
%   Prentice Hall, 1998

%   Douglas W. Hull, 1998
%   Copyright (c) 1998-99 by Prentice Hall
%   Version 1.00


ex=StrainState(1);
ey=StrainState(2);
lxy=StrainState(3);

StressState(1)=(E/(1-poisonts^2))*(ex+poisonts*ey);
StressState(2)=(E/(1-poisonts^2))*(ey+poisonts*ex);
StressState(3)=lxy*E/(2*(1+poisonts));
