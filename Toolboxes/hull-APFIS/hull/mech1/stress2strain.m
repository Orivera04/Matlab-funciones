function [StrainState] = stress2strain(StressState,E,poisonts)
%STRESS2STRAIN Converts stress to strain.
%   STRESS2STRAIN([SIGMAX,SIGMAY,TAUXY],E,POISSONS) Converts a stress state 
%   to the equivalent strain state.
%
%   SIGMAX:  Normal stress in the X direction.
%   SIGMAY:  Normal stress in the Y direction.
%   TAUXY:   Shear on the X-Y plane.
%   Together these three are gathered as the STRESSSTATE.
%
%   E:       Young's Modulus
%   POISSONS:Poisson's ratio.
%
%   See also MOHRS, PPSTRESS, PRISTRESS, STRAIN2STRESS, STRESSTR.

%   Details are to be found in Mastering Mechanics I, Douglas W. Hull,
%   Prentice Hall, 1998

%   Douglas W. Hull, 1998
%   Copyright (c) 1998-99 by Prentice Hall
%   Version 1.00


sx=StressState(1);
sy=StressState(2);
txy=StressState(3);

StrainState(1)=(sx-poisonts*sy)/E;
StrainState(2)=(sy-poisonts*sx)/E;
StrainState(3)=(txy/E)*2*(1+poisonts);
