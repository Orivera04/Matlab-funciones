function varargout = fit_treegeneric( m, varargin );
%XREGRBF/FIT_TREEGENERIC
%  [OM,OK] = FIT_TREEGENERIC(M) 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.4.6.2 $ 

om = contextimplementation( xregoptmgr, m, @i_treegeneric, [], ...
    'Generic Center Selection', @fit_treegeneric );

[omNest, ok] = rols( m ); 
% ROLS allows a number of other algorithms at the same level. However,
% these aren't yet compatible with width/center/dimension RBFs and so we
% don't allow these. (9 Sept 2002)
omNest = setAltMgrs( omNest, {@rols} );

% fit parameters
om = AddOption( om, 'CenterSelectAlg', ...
    omNest, 'xregoptmgr', ...
    'Center selection algorithm', 2 );

om = AddOption( om, 'cost', ...
    0, {'numeric', [-Inf, Inf]}, ...
    [], 0 );

if nargout >= 1,
    varargout{1} = om;
end
if nargout >= 2,
    varargout{2} = 1;
end
return

%------------------------------------------------------------------------------|
function [m, cost, ok] = i_treegeneric( m, om, x0, x, y, Tree, alpha, varargin )
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

CenterSelectAlg  = get( om, 'CenterSelectAlg' );

centers = getcenter( Tree, ':' );
widths  = getwidth(  Tree, ':' );

m = set( m, 'lambda', 0.0 );

[newm, cost, ok] = run( CenterSelectAlg, m, x0, x, y, [], ...
    centers, alpha * widths );
if ok,
    m = newm;
else,
    cost = Inf;
end

return

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|

