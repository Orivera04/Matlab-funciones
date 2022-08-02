function [om,ok] = fit_specifyalpha( m )
%XREGRBF/FIT_SPECIFYALPHA  Training algorithm for RBF models.
%   FIT_SPECIFYALPHA(M) is a OptimMgr (XREGOPTMGR object) set up to handle the 
%   a fitting routine for RBF objects.  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.4.6.2 $ 

om = contextimplementation( xregoptmgr, m, @i_fit_specifyalpha, [], ...
    'Specify Alpha', @fit_specifyalpha );

[omNest, ok] = fit_treeselection( m ); 

    % fit parameters
om = AddOption( om, 'Alpha', ...
    1.0, {'numeric',[eps, Inf]}, ...
    'Width scale parameter, alpha', 2);

om = AddOption( om, 'NestedFitAlgorithm', ...
    omNest, 'xregoptmgr', ...
    'Center selection algorithm', 2 );

om = AddOption( om, 'cost', ...
    0, {'numeric',[-Inf,Inf]}, ...
    [], 0 );

ok = 1;

return

%------------------------------------------------------------------------------|
function [mout, cost, ok] = i_fit_specifyalpha( m0, om, x0, x, y, tree )
%  Inputs:		m   xreinterprbf object
%               om  xregoptmgr
%               x0  starting values (not used)
%				x   matrix of data points 
%				y   target values
%
% Outputs:     m    new rbf object
%              cost log10GCV

%%mv_busy( 'Fitting RBF model. Please wait..' );

% Get user options
% ----------------
Alpha              = get( om, 'Alpha' );
NestedFitAlgorithm = get( om, 'NestedFitAlgorithm' );

%
% Call the nested training algorithm
% ----------------------------------
[newm, cost, ok] = run( NestedFitAlgorithm, m0, x0, x, y, tree, Alpha );

if ok,
    mout = newm;
else
    mout = m0;
    cost = Inf;
end

% Finish
%%mv_busy( 'delete' ); % delete the wait

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|
