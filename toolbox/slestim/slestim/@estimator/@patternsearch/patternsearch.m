function this = patternsearch(Estimation)
% PATTERNSEARCH Constructor

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.3 $ $Date: 2004/04/11 00:43:43 $

% Create object
this = estimator.patternsearch;

% Check GADS is on the path
if ~license('test', 'GADS_Toolbox')
  error('The Pattern Search option requires the Genetic Algorithm and Direct Search Toolbox.')
end

% Initialize properties
this.initialize(Estimation);

% Default options
EstOpts = getSettings(Estimation.OptimOptions);
Options = psoptimset('patternsearch');
Options = psoptimset( Options, EstOpts );
this.Options = psoptimset( Options, ...
                           'TolMesh',        Options.TolX, ...
                           'MaxIteration',   EstOpts.MaxIter, ...
                           'CompleteSearch', 'on' );
