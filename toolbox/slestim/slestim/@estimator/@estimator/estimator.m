function this = estimator(h)
% ESTIMATOR Constructor for @estimator class

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2003 The MathWorks, Inc.
% $Revision: 1.1.6.2 $ $Date: 2003/12/04 02:42:54 $

% Create object
this = estimator.estimator;

% Initialize properties
this.initialize(h);
