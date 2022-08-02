function schema
% Defines properties for @paramdata class

%  Author(s): Bora Eryilmaz
%  Copyright 1986-2004 The MathWorks, Inc.
%  $Revision: 1.1.6.2 $ $Date: 2004/04/11 00:41:14 $

% Find parent class (superclass)
supclass = findclass(findpackage('wrfc'), 'data');

% Register class (subclass)
c = schema.class(findpackage('speviews'), 'paramdata', supclass);

% Public attributes
schema.prop(c, 'Focus', 'MATLAB array');       % Focus (preferred X range)
schema.prop(c, 'Iterations', 'MATLAB array');  % Iteration count
% Parameter trajectories 
% Npx1 cell array of Niter-by-Nentry arrays where Np = # parameters
schema.prop(c, 'Values', 'MATLAB array');