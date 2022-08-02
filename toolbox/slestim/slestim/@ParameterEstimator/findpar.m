%FINDPAR  Find specifications for given estimated parameter
%
%   Given an estimation EST, such as
%      est = ParameterEstimator.Estimation('f14')
%   you can access an individual parameter and specify its initial guess, 
%   bounds, and scaling factor
%      p = findpar(proj, 'Ta')  % access settings for parameter TA
%      p.InitialGuess = 0.1
%
%   Type get(p) to see all related settings.

%  Author(s): Bora Eryilmaz
%  Revised:
%  Copyright 1986-2004 The MathWorks, Inc.
%  $Revision: 1.1.6.1 $ $Date: 2004/04/19 01:33:22 $