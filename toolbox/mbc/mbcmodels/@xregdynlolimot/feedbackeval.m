function [y, weights] = feedbackeval( m, x, order, delay )
%XREGDYNLOLIMOT/FEEDBACKEVAL   Model evaluation with feedback
%   FEEDBACKEVAL(M,X,ORDER,DELAY) evaluates the model M at the points X and 
%   with the given dynamic ORDER and DELAY. This differs from DYNEVAL in that 
%   the genuine inputs should all have been expanded and the initial conditions 
%   are correctly placed in X and it is only the output that needs to be fixed 
%   up. 
%   [Y,W] = FEEDBACKEVAL(...) also returns the values of the LOLIMOT weight 
%   functions in W.
%
%   See also XREGMODEL/FEEDBACKEVAL, XREGDYNLOLIMOT/DYNEVAL.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.3.6.1 $  $Date: 2004/02/09 07:45:55 $

if isa(x,'sweepset')
   Ns= size(x,3);
   y= cell(Ns,1);
   weights= y;
   for i=1:Ns
      [y{i}, weights{i}] = i_feedbackeval( m, x{i}, order, delay );
   end
   y= cat(1,y{:});
   weights= cat(1,weights{:});
else
   [y, weights] = i_feedbackeval( m, x, order, delay );
end


function [y, weights] = i_feedbackeval( m, x, order, delay )

md = max( order + delay ); % max delay 
order = order(end);        % output order
delay = delay(end);        % output delay

if nargin <= 2 | order < 1,
    % no feedback, ordinary evaluation will work
    [y, weights] = eval( m.xreglolimot, x );
    return
end


% check to see if can use dyneval_loimot_linear
lolimot = m.xreglolimot;
betamodels = get( lolimot, 'BetaModels' );
degree = max( get( betamodels{1}, 'order' ) );
kernel = get( lolimot, 'kernel' );
if degree == 1,
    [y, weights] = feedbackeval_lolimot_linear( m, x, order, delay );
    return
end

if nargin < 4,
    delay = 1;
elseif delay < 1,
    error( 'DELAY must be greater than 1' );
end

%
% The bits of EVALSINGLE that only need be done once
%
% lolimot = m.xreglolimot;
% get the required infomation from lolimot model
centers = get( lolimot, 'centers' );
width   = get( lolimot, 'width' );
% kernel  = get( lolimot, 'kernel' );
% need to fiddle the width to get the kernel functions to evaluate properly
lolimot = set( lolimot, 'width', 1.0 );
% number of centers
ncent = size( centers, 1 ); 
ones_ncent_1 = ones( ncent, 1 );
% betamodel info
% betamodels = get( lolimot, 'BetaModels' );
% degree = max( get( betamodels{1}, 'order' ) );
bm_dim = size( betamodels{1}, 1 ); % beta-model dimension
beta = reshape( double( lolimot ), bm_dim, ncent );
% end EVALSIGNLE setup
%

order = floor( order );
delay = floor( delay );
opdm1 = order + delay - 1; % order plus delay minus one
neval = size( x, 1 ); % number of evaluation points
%%ncent = get( m.xreglolimot, 'NumberOfCenters' ); % number of centers

if order + delay > neval,
    error( 'Insufficient points for dynamic evaluation' )
end

% allocate space for outputs
y = zeros( neval, 1 );
weights = zeros( neval, ncent );

% initial conditions
y(1:opdm1) = x(1,end-order+1); 
weights(1:opdm1,:) = evalweight( m.xreglolimot, x(1:opdm1,:) );

ind = size( x, 2 ) - order + 1:size( x, 2 );
for i = order + delay:neval,
    x(i,ind) = y(i-delay:-1:i-opdm1)';
    
    % call EVALSINGLE
    %
    % [y(i), weights(i,:)] = evalsingle( m.xreglolimot, x(i,:) );
    %
    xx = x(i,:);
    
    % compute the distance from x to each center
    %dis = ( repmat( xx, ncent, 1 ) - centers ) ./ width;
    dis = ( xx(ones_ncent_1,:) - centers ) ./ width;
    dis = sum( dis .* dis, 2 );
    
    % compute the values of the rbf kernel
    phi = feval( kernel, dis, lolimot );
    
    % compute weight function values
    sum_phi = sum( phi );
    if abs( sum_phi ) < eps,
        if sum_phi == 0,
            sum_phi = eps;
        else
            sum_phi = sign( sum_phi ) * eps;
        end
    end
    ww = phi /sum_phi;
    
    % Form the x2fx matrix for the betamodels
    % Assume beta models are the same type so this x2fx matrix will apply to 
    % all beta models
    if degree == 1,
        bx = [1, xx]; % for linear betamodels
    elseif degree == 0,
        bx = 1;
    else
        bx = x2fx( betamodels{1}, xx ); 
    end
    
    if ncent > bm_dim,
        yy = bx * ( beta * ww ); % if the ncenters is bigger than the dimension 
        %                          of the betamodels, this braketing is fastest.
    else
        yy = ( bx *  beta ) * ww; % if the ncenters is smaller than the dimension 
        %                          of the betamodels, this braketing is fastest.
    end
    
    % end of EVALSINGLE, assign outputs
    weights(i,:) = ww';
    y(i) = yy;
end

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|
