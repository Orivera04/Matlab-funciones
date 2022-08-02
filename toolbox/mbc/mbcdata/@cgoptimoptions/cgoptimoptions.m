function optobj = cgoptimoptions
%CGOPTIMOPTIONS Create a custom optimization options object
%
%  OPTOBJ = CGOPTIMOPTIONS creates an optimization options object
%  intialized to default values. These values set up a default single
%  objective, unconstrained optimization script. This default script will
%  have no parameters set up and be able to run over any number of free
%  variables. Furthermore, the user will be able to decide whether this
%  function is to run over an operating point set or not.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.3.6.2 $ 

s = i_createstruct;

optobj = class(s, 'cgoptimoptions');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function s=i_createstruct
% Create the default structure 
s = struct(...
    'name'               , 'NewOptimization',...  % name string used to identify optimization data
    'description'        , 'This is a description of NewOptimization',...  % description of optimization
    'enabled'                 , true,...  % logical flag determining whether this file can be used as a custom optimisation
    'freevariables'       , struct('mode', 'any', 'labels',[], 'firstcall', 0), ...   % Structure to define the free variables 
    'objectives'             , struct('mode', 'fixed', 'details', struct('label', 'Objective1', 'type', 'min/max'), 'firstcall', 1),...  % Structure to define the objectives
    'constraints'        , struct('mode', 'any', 'details',struct('label', '', 'typestr', '', 'pars', {})),...  % Structure to define the constraints
    'operatingpoints'           , struct('mode', 'default', 'details',struct('label', '', 'vars', {})),...  % Structure to define the operating point sets
    'parameters', []);   % A struct array with fields label AS string, typestr AS string and value AS variant

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
