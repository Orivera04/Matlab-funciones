function varargout = fit_treeselection( m, varargin )
%FIT_TREESELECTION
%
%  [OM,OK] = FIT_TREESELECTION(M)
%
%  [M,COST,OK] = FIT_TREESELECTION(M,X,Y,TREE)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.6.3 $  $Date: 2004/04/04 03:30:14 $

om = contextimplementation( xregoptmgr, m, @i_treeselection, [], ...
    'Tree-based Center Selection', @fit_treeselection );

om = setAltMgrs( om, {@fit_treeselection, @fit_treegeneric} );

% fit parameters
om = AddOption( om, 'ModelSelectionCriteria', ...
    'BIC', 'BIC|GCV', ...
    'Model selection criteria', 1 );

om = AddOption( om, 'MaxNumberCenters', ...
    'min(nObs/4,25)', 'evalstr', ...
    'Maximum number of centers', 2 );

om = AddOption( om, 'cost', ...
    0, {'numeric', [-Inf, Inf]}, ...
    [], 0 );

if nargin > 1,
    [varargout{1:nargout}] = i_treeselection( m, om, [], varargin{:} );
    return
end
if nargout >= 1,
    varargout{1} = om;
end
if nargout >= 2,
    varargout{2} = 1;
end
return

%------------------------------------------------------------------------------|
function [m, cost, ok] = i_treeselection( m, om, x0, x, y, Tree, alpha, varargin )
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
ModelSelectionCriteria = get( om, 'ModelSelectionCriteria' );
MaxNumberCenters       = get( om, 'MaxNumberCenters' );


% Interpret max number of centers string
% -- If MaxNumCenters is numeric, it's because an old option manager object
% is being used and an integer instead.
if ~isnumeric( MaxNumberCenters ),
    MaxNumberCenters = calcMaxNCenters( m, MaxNumberCenters, size( x, 1 ) );
end

%
% Assign cost function
% --------------------
switch ModelSelectionCriteria,
    case 'BIC',
        CostFn = @i_CostBIC;
    case 'GCV',
        CostFn = @i_CostGCV;
    otherwise,
        error( sprintf( 'Unknown model selection criteria ''%s''', ...
            ModelSelectionCriteria ) );
end

%
% Set up initial model
% --------------------
kernel = getkernelstring( m );
activeList = [1]; % list of currently active panels/centers
modelList  = [1]; % list of panels/centers in current model

currentFX = i_x2fx( kernel, Tree, alpha, 1, x );
[Q, R, ok] = xregqr( currentFX );
if ~ok, return, end

best.cost   = feval( CostFn, Q, y );
best.FX     = currentFX;
best.active = 0;
best.add    = [];
best.remove = [];

%
% Main loop
% ---------
while ~isempty( activeList ) & length( modelList ) < MaxNumberCenters,
    for panel = activeList,

        [child1, child2] = getchildren( Tree, panel );

        % try adding panel to model
        if ~any( panel == modelList ),
            tmpFX = [ currentFX, i_x2fx( kernel, Tree, alpha, panel, x ) ];
            [Q, R, ok] = xregqr( tmpFX );
            cost = feval( CostFn, Q, y );
            if ok & cost < best.cost,
                best.cost   = cost;
                best.FX     = tmpFX;
                best.active = panel;
                best.add    = panel;
                best.remove = [];
            end
            addpanel = panel;
        else
            tmpFX = currentFX;
            addpanel = [];
        end

        % try adding first child to model
        tmpFX = [ tmpFX, i_x2fx( kernel, Tree, alpha, child1, x ) ];
        [Q, R, ok] = xregqr( tmpFX );
        cost = feval( CostFn, Q, y );
        if ok & cost < best.cost,
            best.cost   = cost;
            best.FX     = tmpFX;
            best.active = panel;
            best.add    = [addpanel, child1];
            best.remove = [];
        end

        % try adding both children to model
        tmpFX = [ tmpFX, i_x2fx( kernel, Tree, alpha, child2, x ) ];
        [Q, R, ok] = xregqr( tmpFX );
        cost = feval( CostFn, Q, y );
        if ok & cost < best.cost,
            best.cost   = cost;
            best.FX     = tmpFX;
            best.active = panel;
            best.add    = [addpanel, child1, child2];
            best.remove = [];
        end

        % try adding second child to model
        tmpFX(:,end-1) = []; % frist child is in the second to last postion
        [Q, R, ok] = xregqr( tmpFX );
        cost = feval( CostFn, Q, y );
        if ok & cost < best.cost,
            best.cost   = cost;
            best.FX     = tmpFX;
            best.active = panel;
            best.add    = [addpanel, child2];
            best.remove = [];
        end

        % try removing panel from model
        if any( panel == modelList ),
            tmpFX = currentFX(:,find( modelList ~= panel ));
            [Q, R, ok] = xregqr( tmpFX );
            cost = feval( CostFn, Q, y );
            if ok & cost < best.cost,
                best.cost   = cost;
                best.FX     = tmpFX;
                best.active = panel;
                best.add    = [];
                best.remove = panel;
            end
            removepanel = panel;
        else
            tmpFX = currentFX;
            removepanel = [];
        end

        % try adding first child to model
        tmpFX = [ tmpFX, i_x2fx( kernel, Tree, alpha, child1, x ) ];
        [Q, R, ok] = xregqr( tmpFX );
        cost = feval( CostFn, Q, y );
        if ok & cost < best.cost,
            best.cost   = cost;
            best.FX     = tmpFX;
            best.active = panel;
            best.add    = child1;
            best.remove = removepanel;
        end

        % try adding both children to model
        tmpFX = [ tmpFX, i_x2fx( kernel, Tree, alpha, child2, x ) ];
        [Q, R, ok] = xregqr( tmpFX );
        cost = feval( CostFn, Q, y );
        if ok & cost < best.cost,
            best.cost   = cost;
            best.FX     = tmpFX;
            best.active = panel;
            best.add    = [child1, child2];
            best.remove = removepanel;
        end

        % try adding second child to model
        tmpFX(:,end-1) = []; % frist child is in the second to last postion
        [Q, R, ok] = xregqr( tmpFX );
        cost = feval( CostFn, Q, y );
        if ok & cost < best.cost,
            best.cost   = cost;
            best.FX     = tmpFX;
            best.active = panel;
            best.add    = child2;
            best.remove = removepanel;
        end

    end

    if best.active == 0,
        % no better model found- remove a random memeber from the active list
        n = ceil( rand( 1 ) * length( activeList ) );
        best.FX     = currentFX;
        best.active = activeList(n);
        best.add    = [];
        best.remove = [];
    else
        % a better model was found, update current model
        currentFX = best.FX;
        if ~isempty( best.remove ),
            modelList(find( modelList == best.remove )) = [];
        end
        modelList =  [ modelList, best.add ];
    end

    % remove best.active from active list
    activeList(find( activeList == best.active )) = [];

    % add children of best.active to activeList
    [child1, child2] = getchildren( Tree, best.active );
    if ~any( getchildren( Tree, child1 ) == 0 ),
        activeList = [activeList, child1];
    end
    if ~any( getchildren( Tree, child2 ) == 0 ),
        activeList = [activeList, child2];
    end

    best.active = 0;
    best.add    = [];
    best.remove = [];
end

% setup new model
set( m, 'centers',         getcenter( Tree, modelList ) );
set( m, 'width',   alpha * getwidth(  Tree, modelList ) );
set( m, 'lambda', 0.0 );

[Q, R, ok] = xregqr( currentFX );
if ok,
    beta = R\(Q'*y);
    cost = best.cost;
else
    beta = zeros( size( modelList ) );
    cost = Inf;
end
m = update( m, beta );

return

%------------------------------------------------------------------------------|
function cost = i_CostGCV( Q, y )
% GCV cost = p/(p-m)^2 * (y - Q*Q'*y)'*(y - Q*Q'*y)

p = length( y );
m = size( Q, 2 );

res = y - Q*(Q'*y);
res = res' * res;

cost = p/(p-m)^2 * res;

return

%------------------------------------------------------------------------------|
function cost = i_CostBIC( Q, y )
% BIC cost = (p+(ln(p)-1)*m)/(p*(p-m)) * (y - Q*Q'*y)'*(y - Q*Q'*y)

p = length( y );
m = size( Q, 2 );

res = y - Q*(Q'*y);
res = res' * res;

cost = (p+(log(p)-1)*m)/(p*(p-m)) * res;

return

%------------------------------------------------------------------------------|
function FX = i_x2fx( kernel, tree, alpha, panel, x )
center = getcenter( tree, panel );
width  = getwidth(  tree, panel );
FX = xregrbfeval( kernel, x, center, (alpha * width), [] );
