function [StrainState]=rosette(epsilon, theta)
%ROSETTE Converts strain gauge readings to strain state.
%   ROSETTE([EPS1,EPS2,EPS3],[THETA1,THETA2,THETA3]) converts strain gauge 
%   readings to strain state.
%
%   See also MOHRS2, PPSTRAIN, PRISTRAIN, STRAIN2STRESS, STRAINTR.

%   Details are to be found in Mastering Mechanics I, Douglas W. Hull,
%   Prentice Hall, 1998

%   Douglas W. Hull, 1998
%   Copyright (c) 1998-99 by Prentice Hall
%   Version 1.00

coef=[cos(theta').^2 sin(theta').^2 sin(theta').*cos(theta')];
StrainState=(inv(coef)*epsilon')';
