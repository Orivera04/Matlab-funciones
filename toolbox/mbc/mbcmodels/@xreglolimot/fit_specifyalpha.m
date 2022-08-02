function [om,ok] = fit_specifyalpha( m )
%FIT_SPECIFYALPHA  Training algorithm for XREGLOLIMOT models.
%   FIT_SPECIFYALPHA(M) is a OptimMgr (XREGOPTMGR object) set up to handle the 
%   a fitting routine for XREGLOLIMOT objects. Note that this is subservient to 
%   FIT_TRIALALPHA.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.3.6.2 $  $Date: 2004/02/09 07:50:39 $

om = contextimplementation( xregoptmgr, m, @i_fit_specifyalpha, [], ...
    'Specify Alpha', @fit_specifyalpha );

[omNest,ok] = fit_lolimot( m ); 

% fit parameters
om = AddOption( om, 'Alpha', ...
    1.0, {'numeric',[eps, 100]}, ...
    'Width scale parameter, alpha', 2 );

om = AddOption( om, 'NestedFitAlgorithm', ...
    omNest, 'xregoptmgr', ...
    'Center selection algorithm', 2 );

om = AddOption( om, 'cost', ...
    0, {'numeric',[-Inf,Inf]}, ...
    [], 0 );

ok = 1;

return

%------------------------------------------------------------------------------|
function [m, cost, ok] = i_fit_specifyalpha( m, om, x0, x, y, varargin )
%  Inputs:		m   xreinterprbf object
%               om  xregoptmgr
%               x0  starting values (not used)
%				x   matrix of data points 
%				y   target values
%
% Outputs:     m    new rbf object
%              cost log10GCV

mv_busy( 'Fitting LOLIMOT model. Please wait..' );

% Get user options
% ----------------
Alpha              = get( om, 'Alpha' );
NestedFitAlgorithm = get( om, 'NestedFitAlgorithm' );

%
% Call the nested training algorithm
[m, cost, ok] = run( NestedFitAlgorithm, m, [], x, y, Alpha ); 

% Finish
mv_busy( 'delete' ); % delete the wait

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|
