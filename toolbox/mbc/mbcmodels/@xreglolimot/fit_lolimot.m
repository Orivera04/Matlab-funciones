function [om,ok] = fit_lolimot( m )
%FIT_LOLIMOT   Initilize OptimMgr for fitting XREGLOLIMOT models.
%
%  FIT_LOLIMOT(M) is a OptimMgr (XREGOPTMGR object) set up to handle the
%  fitting routines for XREGLOLIMOT objects.
%
%  This file also contains the standard lolimot fitting algorithm of Nelles,
%  et al. (1996).

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.3 $  $Date: 2004/04/04 03:30:09 $

om= contextimplementation( xregoptmgr, m, @i_fit_lolimot, [], ...
    'LOLIMOT Fit', @fit_lolimot );

% fit parameters
om = AddOption( om, 'ErrorTolerance', ...
    1e-6, {'numeric', [eps, Inf]}, ...
    'Error tolerance', 1 );

om = AddOption( om, 'Greedy', ...
    1, 'boolean', ...
    'Stop if error increases', 1 );

om = AddOption( om, 'MaxNumCenters', ...
    'min(nObs/4,25)', 'evalstr', ...
    'Maximum number of centers', 2 );
% Note MaxNumCenters has been changed from 'int' to 'evalstr'
% -- 18 Oct 2002

om = AddOption( om, 'MinPerRectangle', ...
    10, {'int', [1, Inf]}, ...
    'Minimum  nodes per rectangle', 1 );

om = AddOption( om, 'RectangleSize', ...
    1, 'boolean', ...
    'Shrink panel to data', 1 );
% Note MaxNumCenters has been changed from 'Shrink|Cover' to 'boolean'
% -- 18 Oct 2002

om = AddOption( om, 'BetaModels', ...
    'Linear', 'Constant|Linear|Quadratic', ...
    'Beta model type ', 1 );

om = AddOption( om, 'LeastSquaresOnExit', ...
    0, 'boolean', ...
    'Perform least squares fit on exit', 1 );

om = AddOption( om, 'RefitLocalEachIter', ...
    1, 'boolean', ...
    'Refit all local models each iteration', 1 );

om = AddOption( om, 'cost', ...
    0, {'numeric', [-Inf, Inf]}, ...
    [], 0 );

ok = 1;

return

%------------------------------------------------------------------------------|
function [m, cost, ok] = i_fit_lolimot( m, om, x0, x, y, alpha, varargin )
%  Inputs:		m   xreinterprbf object
%               om  xregoptmgr
%               x0  starting values (not used)
%				x   matrix of data points
%				y   target values
%
% Outputs:     m    new rbf object
%              cost log10GCV

% LOLIMOT Algorithm (from Nelles, et al., 1996)
%
% 1. Set the first hyper-rectangle in such way that it contains all data points.
%    Estimate a global linear model y = w0 + w1 x1 + ... + wn xn.
% 2. For all input dimensions j=1...n,
%   a. Cut the hyper-rectangle into two halves along dimension j.
%   b. Estimate the parameters of the local linear models for each half.
%   c. Calculate the global approximation error for the parallel model with
%      this cut.
% 3. Determine which cut has led to the smallest approximation error.
% 4. Perform this cut.
%    Place a weighting function within each center of both hyper-rectangles.
%    Set standard deviations [widths] of both weighting functions
%    proportional to the extension of the hyper-rectangle in each dimension.
%    Apply the corresponding estimated local linear models (from 2b).
% 5. Calculate the local error measures J on basis of a parallel running
%    model for each hyper-rectangle.
% 6. Choose the hyper-rectangle with the largest local error measure J.
% 7. If the global approximation error on a parallel model (output error) is
%    too large go to step 2.
% 8. Convergence. Stop.

% At each iteration, there will be the current model, a champion and a
%    challenger. The current model is the champion from the previous iteration.
%    During the iteration, the current champion is the bect modification of the
%    the current model so far and the the challenger is next the modification
%    on the list. If the challenger is better than the champion, the champion
%    is replaced.

i_disp( 'Fitting LOLIMOT model....' );

% [m, OK] = InitModel( m, x, y ); % this should only be a temporary measure?
nf = get( m, 'nfactors' );

% Error nornlization constant.
%    Converts sum of squares error into RMS error realtive to absolute
%    variation in the responce.
errornormalization = size( x, 1 ) * ( max( y ) - min(y) );

%
% Get user options
% ----------------
ErrorTolerance     = get( om, 'ErrorTolerance' );
Greedy             = get( om, 'Greedy' );
MaxNumCenters      = get( om, 'MaxNumCenters' );
BetaModels         = get( om, 'BetaModels' );
RefitLocalEachIter = get( om, 'RefitLocalEachIter' );
LeastSquaresOnExit = get( om, 'LeastSquaresOnExit' );
MinPerRectangle    = get( om, 'MinPerRectangle' );
RectangleSize      = get( om, 'RectangleSize' );

% Interpret max number of centers string
% -- If MaxNumCenters is numeric, it's because an old option manager object
% is being used and an integer instead.
if ~isnumeric( MaxNumCenters ),
    MaxNumCenters = calcMaxNCenters( m, MaxNumCenters, size( x, 1 ) );
end

% Convert RectangleSize to a string
% -- RectangleSize could already be a string if an old option manager is
% being used
if ~ischar( RectangleSize ),
    if RectangleSize,
        RectangleSize = 'Shrink';
    else
        RectangleSize = 'Cover';
    end
end

% Setup a betamodel template
template = i_getBetaModelTemplate( nf, BetaModels );
xi = xinfo( m );
template = xinfo( template, xi );

%
% Find the initial rectangle
% --------------------------
Xd = double( x );
Yd = double( y );
Tree = xregfittree( Xd, Yd );
setuserdata( Tree, 1, 1 ); % index in the current model of the center that this
%                            rectangle corresponnds to

% Set the initial (current) model
current = m;
current = set( current, 'centers', getcenter( Tree ) );
current = set( current, 'width', alpha * getwidth( Tree ) );
betamodel = runfit( template, Xd, y );
current = set( current, 'BetaModels', { betamodel } );
current = update( current );

%
% Initialization for main loop
% ----------------------------
worst = 1; % index of worst performing rectangle
ncenters = 1;
lasterror = Inf;
ErrorTolerance = ErrorTolerance * errornormalization;
[yhat, currentweights] = eval( current, x );
error = sum( ( y - yhat ).^2 );
%
% Main loop
% ---------
while error > ErrorTolerance ...
        & error < lasterror ...
        & worst > 0 ...
        & ncenters < MaxNumCenters,

    i_disp('New iteration');

    if Greedy,
        lasterror = error;
    end

    championerror = Inf;
    champion = [];

    %
    % Compare champions with each challenger
    % --------------------------------------
    rbfindex = getuserdata( Tree, worst );
    [Xd, Yd] = getxydata( Tree, 1 );
    for i = 1:nf,
        % Split the rectangle along the i-th dimension
        %         [child1, child2, ind] = i_splitRectangle( RectangleSize, ...
        %             rectangles(worst), worst, i );
        splitData = presplit( Tree, worst, i, 'center', RectangleSize );

        % check number of data points in each new child
        if ~splitData.Ok | ...
                isempty( splitData.ChildPoints{1} ) | ...
                isempty( splitData.ChildPoints{2} ),
            i_disp('Failed to split rectangle');
            continue
        end

        % Remove the old weight function and set the new weight functions
        [challenger, challindex] = i_replaceRbf( current, ...
            rbfindex, splitData.Centers, ...
            alpha * splitData.HalfWidths, { template, template } );

        % Compute the weights
        weights1 = evalweight( challenger, Xd(splitData.ChildPoints{1},:), ...
            challindex(1) );
        weights2 = evalweight( challenger, Xd(splitData.ChildPoints{2},:), ...
            challindex(2) );

        % Check that the weights aren't zero
        if sum( weights1 ) < eps | sum( weights2 ) < eps,
            i_disp('Weight function values are too small');
            continue
        end

        % Fit betamodel on first child
        [betamodel1, ok] = runfit( template, ...
            Xd(splitData.ChildPoints{1},:), ...
            Yd(splitData.ChildPoints{1}), ...
            spdiags( weights1, 0, length( weights1 ), length( weights1 ) ) );
        if ok<=0, i_disp('BetaModel1 fit not OK'), continue, end

        % Fit betamodel on second child
        [betamodel2, ok] = runfit( template, ...
            Xd(splitData.ChildPoints{2},:), ...
            Yd(splitData.ChildPoints{2}), ...
            spdiags( weights2, 0, length( weights2 ), length( weights2 ) ) );
        if ok<=0, i_disp('BetaModel2 fit not OK'), continue, end

        i_disp( 'Both beta models fit OK' )

        % set the new betamodels for challenger
        betamodels = get( challenger, 'BetaModels' );
        [betamodels{challindex}] = deal( betamodel1, betamodel2 );
        challenger = set( challenger, 'BetaModels', betamodels );
        challenger = update( challenger );

        % measure and compare the error
        yhat = eval( challenger, x );
        challengererror = sum( currentweights(:,rbfindex) .* ( y - yhat ).^2 );

        if challengererror < championerror,
            champion = challenger;
            championerror = challengererror;
            %             championrectangles = [child1, child2];
            %             champsplitdim = i;
            champSplitData = splitData;
            champindex = challindex;
        end
    end

    %
    % Update the current model and rectangle list
    % -------------------------------------------
    setsplitable( Tree, worst, 0 ); % rectangles(worst).splittable = 0;
    if ~isempty( champion ),
        ncenters = ncenters + 1;
        current = champion;
        postsplit( Tree, champSplitData );
        [c1, c2] = getchildren( Tree, worst );
        setuserdata( Tree, c1, champindex(1) );
        setuserdata( Tree, c2, champindex(2) );
        %         championrectangles(1).index = champindex(1);
        %         championrectangles(2).index = champindex(2);
        %         rectangles = [rectangles, championrectangles ];
        %         covering = setdiff( covering, worst );
        %         n = size( rectangles, 2 );
        %         covering = [covering, n-1, n ];
        %         rectangles(worst).children = [n-1, n];
        %         rectangles(worst).splitdim = champsplitdim;
        %         rectangles(worst).index = [];
        if RefitLocalEachIter,
            % FIX ME! current = i_fitLocalModels( current, rectangles, covering );
        end
    else
        % No champion was found.
        i_disp('No champion found.');
    end

    %
    % Compute worst performing rectangle
    % ----------------------------------
    % Each centre makes a measurable contribution to the RMS error. To measure
    % this error, we first compute the square of difference between all
    % predictions and actual values and then perform a weighted sum of these
    % values for each center. The weights come from the value of the centers
    % weight function (normalized RBF) evaluated at the appropriate node.
    worst = 0; % this will remain 0 if no rectangle can be split
    worsterror = 0;
    [yhat, currentweights] = eval( current, x );
    diff2 = ( y - yhat ).^2;
    for i = getsplitable( Tree ),
        if getndata( Tree, i ) > MinPerRectangle,
            % ==> the rectangle can be split
            ind = getuserdata( Tree, i ); % index of corresponding rbf weight fun
            thiserror = sum( currentweights(:,ind) .* diff2 );
            if thiserror > worsterror
                worst = i;
                worsterror = thiserror;
            end
        end
    end
    error = sum( diff2 );
    i_disp( sprintf( 'Overall error at end of iteration is %g', ...
        error/errornormalization ) )
end
m = current;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% debug diagnostic
reason = {};
if ~( error > ErrorTolerance ),
    reason = { reason{:}, 'LOLIMOT fitting stopped because error target was achieved' };
end
if ~( error < lasterror ),
    reason = { reason{:}, 'LOLIMOT fitting stopped because error started increasing' };
end
if ~( worst > 0 ),
    reason = { reason{:}, 'LOLIMOT fitting stopped because no rectangle is worst' };
end
if isempty( getsplitable( Tree ) ),
    reason = { reason{:}, 'Covering is empty' };
end
if ~( ncenters < MaxNumCenters ),
    reason = { reason{:}, 'LOLIMOT fitting stopped because maximum number of centers was reached' };
end
if error > ErrorTolerance ...
        & error < lasterror ...
        & worst > 0 ...
        & ncenters < MaxNumCenters,
    reason = { reason{:}, 'LOLIMOT fitting stopped with WHILE condition still TRUE' };
end
i_disp( reason );
i_disp(sprintf('The error tolerence was %g and the achieved error is %g', ...
    ErrorTolerance/errornormalization, error/errornormalization ) );
i_disp(sprintf('There are %i data points', size( x, 1 ) ) );
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% end debug diagnostic

if LeastSquaresOnExit,
    [newm, ok] = leastsq( m, Xd, y );
    if ok,
        m = newm;
    else,
        i_disp('Problem performing Least Squares fit.');
    end
end

% Assign outputs
cost = error / errornormalization;
ok = 1;

% set the training data info in the model object
TrainingData = get( m, 'TrainingData' );
TrainingData = setfield( TrainingData, 'Tree', Tree );
TrainingData = setfield( TrainingData, 'Alpha', alpha );
set( m, 'TrainingData', TrainingData );

return

%------------------------------------------------------------------------------|
function [m,index] = i_replaceRbf( m, index, newcenters, newwidths, ...
    newbetamodels );
% Replaces a parent RBF with two child RBFs
%
% newcenters and newwidths should contain two rows each
% newbetamodels should be a cell array with two elements
%
% Replaces the index-th RBF in the model m with the RBF given by the first
% newcenter, newwidth, and newbetamodel and appends the second to the end.

centers    = get( m, 'Centers' );
widths     = get( m, 'Width' );
betamodels = get( m, 'BetaModels' );

centers([index,end+1],:) = newcenters;
widths([index,end+1],:)  = newwidths;
betamodels{index} = newbetamodels{1};
betamodels = { betamodels{:}, newbetamodels{2} };

m = set( m, 'Centers', centers );
m = set( m, 'Width', widths );
m = set( m, 'BetaModels', betamodels );
m = update( m );

index = [ index; size( centers, 1 ) ];

return

%------------------------------------------------------------------------------|
function [m,index] = i_appendRbf( m, index, newcenters, newwidths, ...
    newbetamodels );
% appends two child RBFs to the end of the list
% same arguments as for i_replaceRbf
% index is ignored
i_disp( 'append' )

centers    = get( m, 'Centers' );
widths     = get( m, 'Width' );
betamodels = get( m, 'BetaModels' );

centers    = [centers;        newcenters];
widths     = [widths;         newwidths];
betamodels = { betamodels{:}, newbetamodels{:} };

m = set( m, 'Centers', centers );
m = set( m, 'Width', widths );
m = set( m, 'BetaModels', betamodels );
m = update( m );

index = size( centers, 1 );
index = [index-1; index];

return

%------------------------------------------------------------------------------|
function template = i_getBetaModelTemplate( nf, BetaModels );
switch BetaModels,
    case 'Constant',
        template = xregcubic( zeros( 1, nf ) );
    case 'Linear',
        template = xreglinear( ones(  nf+1, 1 ) , 1);
    case 'Quadratic',
        template = xregcubic( 2 * ones( 1, nf ) );
    otherwise
        warning( 'Unknown option for Beta model type' );
        template = xregcubic( ones( 1, nf ) );
end
template = set( template, 'fitalg', 'quicklsq' );
return

%------------------------------------------------------------------------------|
function m = i_fitLocalModels( m, rectangles, covering );
% This assumes that there is one rectangle for each RBF weighting function. If
% this is not the case becasuse of the RBF addition strategy or because
% unsplittable rectangles have been removed, then not all local models will be
% fitted.
betamodels = m.betamodels;
for i = covering,
    ind = rectangles(i).index;
    weights = evalweight( m, rectangles(i).nodes, ind );
    if sum( weights ) < eps, continue, end
    [bm, ok] = runfit( betamodels{ind}, ...
        rectangles(i).nodes, rectangles(i).data, spdiags( weights, 0, length(weights), length(weights) ) );
    if ok>0
        betamodels{ind} = bm;
    end
end
m.betamodels = betamodels;

return

%------------------------------------------------------------------------------|
function i_disp( s )
% Local disp'lay function that can easily be turned off.
%%disp( s )
return

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|
