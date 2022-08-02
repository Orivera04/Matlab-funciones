function [PrinciplePlanes]=ppstress(StressState)
%PPSTRESS The principle planes of a stress state.
%   PPSTRESS([SIGMAX,SIGMAY,TAUXY]) Calculates the principle planes of a 
%   stress state.
%
%   SIGMAX:  Normal stress in the X direction.
%   SIGMAY:  Normal stress in the Y direction.
%   TAUXY:   Shear on the X-Y plane.
%   Together these three are gathered as the STRESSSTATE.
%
%   See also MOHRS, PRISTRESS, STRESS2STRAIN, STRESSTR.

%   Details are to be found in Mastering Mechanics I, Douglas W. Hull,
%   Prentice Hall, 1998

%   Douglas W. Hull, 1998
%   Copyright (c) 1998-99 by Prentice Hall
%   Version 1.00

sx=StressState(1);
sy=StressState(2);
txy=StressState(3);
PrinciplePlanes(1,1)=atan2((2*txy/(sx-sy)),1)/2;
PrinciplePlanes(2,1)=PrinciplePlanes(1)+DR(90);

