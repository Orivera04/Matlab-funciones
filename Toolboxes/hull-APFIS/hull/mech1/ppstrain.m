function [PrinciplePlanes]=ppstrain(StrainState)
%PPSTRAIN The principle planes of a strain state.
%   PPSTRAIN([EPSX,EPSY,GAMXY]) Calculates the principle planes of a 
%   strain state.
%
%   EPSMAX:  Normal strain in the X direction.
%   EPSMAY:  Normal strain in the Y direction.
%   GAMXY:   Shear on the X-Y plane.
%   Together these three are gathered as the STRAINSTATE.
%
%   See also MOHRS2, PRISTRAIN,  ROSETTE, STRAIN2STRESS, STRAINTR.

%   Details are to be found in Mastering Mechanics I, Douglas W. Hull,
%   Prentice Hall, 1998

%   Douglas W. Hull, 1998
%   Copyright (c) 1998-99 by Prentice Hall
%   Version 1.00


ex=StrainState(1);
ey=StrainState(2);
gxy=StrainState(3);
PrinciplePlanes(1,1)=atan2((gxy/(ex-ey)),1)/2;
PrinciplePlanes(2,1)=PrinciplePlanes(1)+DR(90);
