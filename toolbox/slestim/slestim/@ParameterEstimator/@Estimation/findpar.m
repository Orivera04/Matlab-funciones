function p = findpar(this, name)
% FINDPAR Finds the parameter with a given name.
%
% Given an estimation EST, such as
%   est = ParameterEstimator.Estimation('f14')
%
% you can access an individual parameter and specify its initial guess, bounds,
% and scaling factor
%  p = findpar(proj, 'Ta')  % access settings for parameter TA
%  p.InitialGuess = 0.1
%
% Type get(p) to see all related settings.

%   $Revision: 1.1.6.2 $ $Date: 2004/04/11 00:42:13 $
%   Copyright 1986-2004 The MathWorks, Inc.

% RE: Returns a @Parameter object
if isempty(this.Parameters)
   p = [];
else
   p = find(this.Parameters, 'Name', name);
end
