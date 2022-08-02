function obj=cgoptim(varargin)
%CGOPTIM Multi-objective optimization with constraints bookkeeper class
%
%  obj = CGOPTIM
%  obj = CGOPTIM(name)
%  obj = CGOPTIM(name)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.10.6.1 $    $Date: 2004/02/09 06:53:00 $

if nargin == 0
    s = i_createstruct;
    s.name = 'New_Optimization';
elseif nargin == 1
    if isstruct(varargin{1})
        % Structure passed in for loading.
        s = varargin{1};
    else
        s = i_createstruct;
        s.name = varargin{1};
    end
end

obj = class(s, 'cgoptim');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function s=i_createstruct

% null struct
s = struct(...
    'name'               , '',...  % name string used to identify optimization data
    'description'        , '',...  % description of optimization
    'om'                 , [],...  % used to store utility parmeters eg. number of iterations
    'canaddvalues'       , 0,...   % can number of free variables grow?
    'values'             , [],...  % vector of cgvalues (used to denote free variables)
    'valueLabels'        , {{}},...  % cell array of user-defd values strings for labeling
    'oppoints'           , [],...  % vector of cgoppoint objects (ie. datasets)
    'canaddoppoints'     , 0,...   % boolean to signify whether oppoints can grow
    'oppointLabels'      , {{}},...  % cell array of user-defd dataset strings for labeling
    'oppointValues'      , {{}},...  % vector of cgvalues that must appear in datasets
    'oppointValueLabels' , {{}},...  % cell array of user-defd value strings which must appear in each dataset
    'canaddobjectiveFuncs', 0,...   % boolean to signify whether 
    'objectiveFuncs'     , [],...  % cell array of pointers to cgobjectivefuncs
    'objectiveFuncLabels', {{}},...  % cell array of user-defd objectives strings for labeling
    'canaddconstraints'  , 0,...
    'constraints'        , [],...  % cell array of pointers to constraint objects
    'constraintLabels'   , {{}},...  % cell array of user-defd constraint strings for labeling 
    'version'            , 9,...   % Utility variables ...
    'fname'              , [],...  % filename of the optimization script, version 2
    'isenabled', false, ...
    'outputData', [], ...   % 3D cube of optimization output (Npts*Nitems*Nsol)
    'outputColumns', null(xregpointer, 0), ...   % pointers to items that output corresponds to
    'outputWeights', [], ...   %   matrix of pareto weights (Npts*Nobj)
    'outputWeightsColumns', null(xregpointer, 0), ...   % pointers to obejctives that weights corresponds to
    'outputSelection', cgoptcsol, ...   % cgoptcsol object defining the user customised solution
    'lastOK', [], ... % Status of last optimization run
    'lastErr', '', ...% Error message from last optimization run    
    'diagStat', [], ... % Diagnostic statistics from last optimization run
    'x0', [], ...% Initial Value matrix (Npts*Nfreevar)
    'running', struct('flag', 0, 'pref',null(xregpointer,0))); % "Bailed through debug " structure