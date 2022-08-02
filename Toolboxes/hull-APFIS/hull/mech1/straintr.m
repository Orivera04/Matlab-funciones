function [NewState]=straintr(StrainState,theta)
%STRAINTR Stress rotation.
%   [STRAINSTATE]=STRAINTR([EPSX,EPSY,GAMXY],THETA) will take the given strain
%   state and rotate it through the given radian angle THETA.
%
%   EPSX:    Normal stress in the X direction.
%   EPSY:    Normal stress in the Y direction.
%   GAMXY:   Shear on the X-Y plane.
%   Together these three are gathered as the STRAINSTATE.
%   THETA:   The radian angle of rotation.  Positive C.C.W. from right.
%
%   EXP:     Normal stress in the X prime direction.
%   EYP:     Normal stress in the Y prime direction.
%   GXPYP:   Shear stress in the X prime - Y prime plane.
%   Together these three are gathered as a STRAINSTATE.
%
%   See also MOHRS2, PPSTRAIN, PRISTRAIN, ROSETTE, STRAIN2STRESS.

%   Details are to be found in Mastering Mechanics I, Douglas W. Hull,
%   Prentice Hall, 1998

%   Douglas W. Hull, 1998
%   Copyright (c) 1998-99 by Prentice Hall
%   Version 1.00

ex=StrainState(1);
ey=StrainState(2);
gxy=StrainState(3);
exp=(ex+ey)/2 + (ex-ey)/2*cos(2*theta) + gxy/2*sin(2*theta);
eyp=(ex+ey)/2 + (ex-ey)/2*cos(2*(theta+DR(90))) + gxy/2*sin(2*(theta+DR(90)));
gxpyp=-(ex-ey)*sin(2*theta)+gxy*cos(2*theta);
NewState=[exp,eyp,gxpyp];
