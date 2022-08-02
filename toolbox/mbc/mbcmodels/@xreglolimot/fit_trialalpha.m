function [om,ok] = fit_trialalpha( m )
%FIT_TRIALALPHA  Training algorithm for XREGLOLIMOT models.
%   FIT_TRIALALPHA(M) is a OptimMgr (XREGOPTMGR object) set up to handle the 
%   fitting routines for XREGLOLIMOT objects. Note that this is the primary 
%   XREGOPTMGR for XREGLOLIMOT models.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.3.6.2 $  $Date: 2004/02/09 07:50:40 $

om = contextimplementation( xregoptmgr, m, @i_trialalpha, [], ...
    'Trial Alpha', @fit_trialalpha );

om = setAltMgrs( om, {@fit_trialalpha, @fit_specifyalpha} );
[omNest,ok] = fit_lolimot(m); 

% fit parameters
om = AddOption( om, 'AlphaLowerBound', ...
    0.1, {'numeric',[eps, 100]}, ...
    'Initial lower bound on alpha', 1 );

om = AddOption( om, 'AlphaUpperBound',...
    5.0, {'numeric',[eps, 100]}, ...
    'Initial upper bound on alpha', 1 );

om = AddOption( om, 'NZooms', ...
    3, {'int',[1, 100]}, ...
    'Number of zooms', 1 );

om = AddOption( om, 'NTrials',...
    5, { 'int', [2, 100] }, ...
    'Number of trial alphas in each zoom', 1 );

om = AddOption( om, 'Sampling', ...
    'Logarimthic', 'Linear|Logarimthic', ...
    'Spacing', 1 );

om = AddOption( om, 'NestedFitAlgorithm', ...
    omNest, 'xregoptmgr', ...
    'Center selection algorithm', 2 );

om = AddOption( om, 'LeastSquaresOnExit', ...
    0, 'boolean', ...
    'Perform least squares fit on exit', 1 );

om = AddOption( om, 'PlotProgress', ...
    1, 'boolean', ...
    'Display training progress', 1 );

om = AddOption( om, 'cost', ...
    0, {'numeric',[-Inf,Inf]}, ...
    [], 0 );

return

%------------------------------------------------------------------------------|
function [m, cost, ok] = i_trialalpha( m, om, x0, x, y, varargin )
%  Inputs:		m   xreinterprbf object
%               om  xregoptmgr
%               x0  starting values (not used)
%				x   matrix of data points 
%				y   target values
%
% Outputs:     m    new rbf object
%              cost log10GCV

%
% Get user options
% ----------------
AlphaLowerBound    = get( om, 'AlphaLowerBound' );
AlphaUpperBound    = get( om, 'AlphaUpperBound' );
NZooms             = get( om, 'NZooms' );
NTrials            = get( om, 'NTrials' );
Sampling           = get( om, 'Sampling' );
NestedFitAlgorithm = get( om, 'NestedFitAlgorithm' );
PlotProgress       = get( om, 'PlotProgress' );
LeastSquaresOnExit = get( om, 'LeastSquaresOnExit' );

%
% Setup progress plot
% -------------------
if PlotProgress,
    ProgressFigure = xregparameterprogress( 'setup', ...
        'LOLIMOT Training Progress', ...
        'Alpha', 100, ...
        'Cost', 100, ...
        'Num Centers', 80 );
else
    mv_busy( 'Fitting LOLIMOT model. Please wait.' );
end

%
% The trial alpha algorithm
% -------------------------
% This is based on the trialwidths algorithm for RBFs. The idea is we have a 
% vector of candidate values for the width scale parameter alpha and we look 
% through these for a best choice. We then 'zoom in' on this best choice to 
% generate a new vector of candidates.
% The are four possibilites for this best choice:
%   1. lowest candidate chosen as best
%   2. highest candidate chosen as best
%   3. an intermediate candidate chosen as best
%   4. no candiate is better than the current best
% Each of these has an associated technique for getting the new interval of 
% candidate values for alpha. 
%
% Set bestcost at the begining at then only reset the best model if we get an 
% improvemnt.
bestcost = Inf; 
% bestok is only set to true when the bestmodel is a valid model
bestok = 0; % i.e., false

i_disp( sprintf( '     alpha    |   cost    | num centers    ' ) );
i_disp( sprintf( ' -------------+-----------+----------------' ) );

for j = 1:NZooms
    % generate list of candidate values for alpha
    alpha = i_sample( Sampling, AlphaLowerBound, AlphaUpperBound, NTrials );
    % search through candidates for best alpha
    bestindex = -1;
    for i = 1:NTrials
        [m, cost, ok] = run( NestedFitAlgorithm, m, [], x, y, alpha(i) ); 
        if PlotProgress,
            xregparameterprogress( 'Add', ProgressFigure, ...
                sprintf( '%9.6f', alpha(i) ), ...
                sprintf( '%9.6f', cost ), ...
                sprintf( '%9d', get( m, 'NumberOfCenters' ) ) );
        end
        if  ok & cost < bestcost,
            % this alpha is new best
            bestcost = cost;
            bestindex = i;
            bestmodel = m;
            bestok = 1; % i.e., true
            bestalpha = alpha(i);
            star = '*';
            if PlotProgress,
                xregparameterprogress( 'SetBest', ProgressFigure );
            end
        else
            star = ' ';
        end    
        
        i_disp( sprintf( '  %1.1s %9.6f | %9.6f | %9d', star, alpha(i), ...
            cost, get( m, 'NumberOfCenters' ) ) );
        
    end
    i_disp( sprintf( ' -------------+-----------+----------------' ) );

    if ~bestok, 
        % no best model ==> nothing to zoom in on ==> exit loop
        break, 
    end
    % 'zoom in' on bestalpha
    switch bestindex,
    case -1,
        % no new best alpha found. alpha from previous iteration is best alpha
        AlphaLowerBound = max( alpha(find( alpha < bestalpha )) );
        AlphaUpperBound = min( alpha(find( alpha > bestalpha )) );
        t = 1/NTrials;
        AlphaLowerBound = (1-t)*AlphaLowerBound + t*bestalpha ;
        AlphaUpperBound = t*bestalpha + (1-t)*AlphaUpperBound;
    case 1,
        % lowest alpha chosen as bestalpha
        halflength = ( alpha(2) - alpha(1) )/2;
        AlphaLowerBound = max( AlphaLowerBound/2, bestalpha - halflength );
        AlphaUpperBound = bestalpha + halflength;
    case NTrials,
        % highest alpha chosen as bestalpha
        halflength = ( alpha(NTrials) - alpha(NTrials-1) )/2;
        AlphaLowerBound = max( AlphaLowerBound/2, bestalpha - halflength );
        AlphaUpperBound = bestalpha + halflength;
    otherwise,
        % an intermediate alpha was chosen as bestalpha
        t = 1/NTrials;
        AlphaLowerBound = (1-t)*alpha(bestindex-1) + t*alpha(bestindex);
        AlphaUpperBound = t*alpha(bestindex) + (1-t)*alpha(bestindex+1);
    end
    
    if PlotProgress,
        xregparameterprogress( 'Disp', ProgressFigure, 'zoom in' );
    end

end   
ok = bestok;
if ok,
    m = bestmodel;
    cost = bestcost;
else
    cost = Inf;
end

if LeastSquaresOnExit,
    [newm, ok] = leastsq( m, x, y );
    if ok,
        m = newm;
    end
end

%
% Close the progress plot
% -----------------------
if PlotProgress,
    xregparameterprogress( 'Close', ProgressFigure, 2 );
else
    mv_busy('delete'); % delete the wait
end

return

%------------------------------------------------------------------------------|
function y = i_sample( how, a, b, n  )

switch how,
case 'Linear',
    y = linspace( a, b, n );
case 'Logarimthic'
    y = logspace( log10(a), log10(b), n );
otherwise
    % Unknown sampling, use linear
    y = linspace( a, b, n );
end

return

%------------------------------------------------------------------------------|
function i_disp( s )
% Local disp'lay function that can easily be turned off.
%%disp( s )
return

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|
