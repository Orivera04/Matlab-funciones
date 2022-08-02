function [om, ok] = fit_treeregression( m );
%XREGRBF/TREEREGRESSION 
%  [OM,OK] = TREEREGRESSION(M) 
%
%  See also XREGRBF/TRIALWIDTHS, XREGRBF/WIDPERDIM.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.5.6.2 $ 


om = contextimplementation( xregoptmgr, m, @i_treeregression, [], ...
    'Tree Regression', @fit_treeregression );

% fit parameters
om= AddOption( om, 'MaxNumRectangles', ...
    Inf, {'int',[1, Inf]}, ...
    'Maximum number of panels', 1 );

om = AddOption( om, 'MinPerRectangle', ...
    2, {'int', [2, Inf]}, ...
    'Minimum data points per panel', 1 );

om = AddOption( om, 'RectangleSize', ...
    1, 'boolean', ...
    'Shrink panel to data', 1 );

om = AddOption( om, 'cost', ...
    0, {'numeric', [-Inf, Inf]}, ...
    [], 0 );

[omAlphaSelect, ok] = fit_trialalpha( m ); 
if ok,
    om = AddOption( om, 'AlphaSelectAlg', ...
        omAlphaSelect, 'xregoptmgr', ...
        'Alpha selection algorithm', 2 ); 
end

return

%------------------------------------------------------------------------------|
function [m, cost, ok] = i_treeregression( m, om, x0, x, y, varargin )
%  Inputs:		m   xreinterprbf object
%               om  xregoptmgr
%               x0  starting values (not used)
%				x   matrix of data points 
%				y   target values
%
% Outputs:     m    new rbf object
%              cost log10GCV

cost = Inf;
ok = 0;

%
% Get user options
% ----------------
MaxNumRectangles = get( om, 'MaxNumRectangles' );
MinPerRectangle  = get( om, 'MinPerRectangle' );
AlphaSelectAlg   = get( om, 'AlphaSelectAlg' );

if get( om, 'RectangleSize' ),
    RectangleSize = 'Shrink';
else
    RectangleSize = 'Cover';
end

%
% Build regression tree
% ---------------------
Tree = xregfittree( x, y );
Tree = build( Tree, ...
    'MinPerPanel', MinPerRectangle, ...
    'MaxNPanels',  MaxNumRectangles, ...
    'PanelSize',   RectangleSize );

%
% Find RBF using some of these centers
% ------------------------------------
[m, cost, ok] = run( AlphaSelectAlg, m, x0, x, y, Tree );

return

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|
