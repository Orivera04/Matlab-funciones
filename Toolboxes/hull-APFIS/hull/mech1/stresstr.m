function [sn,tnt]=stresstr(StressState,theta)
%STRESSTR Stress rotation.
%   [SN, TNT]=STRESSTR([SIGMAX,SIGMAY,TAUXY],THETA) will take the given stress 
%   state and rotate it through the given radian angle THETA.
%
%   SIGMAX:  Normal stress in the X direction.
%   SIGMAY:  Normal stress in the Y direction.
%   TAUXY:   Shear on the X-Y plane.
%   Together these three are gathered as the STRESSSTATE.
%   THETA:   The radian angle of rotation.  Positive C.C.W. from right.
%
%   SN:      Normal stress on the given plane.
%   TNT:     Shear stress on the given plane.
%
%   See also MOHRS, PPSTRESS, PRISTRESS, STRESS2STRAIN.

%   Details are to be found in Mastering Mechanics I, Douglas W. Hull,
%   Prentice Hall, 1998

%   Douglas W. Hull, 1998
%   Copyright (c) 1998-99 by Prentice Hall
%   Version 1.00

sx=StressState(1);
sy=StressState(2);
txy=StressState(3);
theta=theta-DR(270);
sn=sx*cos(theta).^2+sy*sin(theta).^2+2*txy*sin(theta).*cos(theta);
tnt=-(sx-sy)*sin(theta).*cos(theta)+txy*(cos(theta).^2-sin(theta).^2);
