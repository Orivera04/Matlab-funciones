function [y, FX] = dyneval(m,x,delmat,y0)
%XREGDYNLOLIMOT/DYNEVAL   Parallel mode for dynamic model evaluation
%   DYNEVAL(M,X,DELMAT,Y0) performs parallel mode dynamic model evaluation for 
%   the XREGDYNLOLIMOT model M at the points X and with dynamic order and delay 
%   given by DELMAT. Optional initial conditions are specified by Y0.
%   [Y,FX] = DYNEVAL(M,X,DELMAT,Y0) also returns the X2FX FX matrix.
%
%   See also XREGMODEL/DYNEVAL.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.3.6.1 $  $Date: 2004/02/09 07:45:53 $

if isa(x,'sweepset') & size(x,1)~=size(x,3)
   Ns=size(x,3);
   y= cell(Ns,1);
   FX= y;
   y0i=y0;
   md = max( sum( delmat, 1 ) );
   for i=1:Ns
      if isa(y0,'sweepset')
         y0i=y0{i};
         y0i=repmat(y0i(1),md-1,1);
      end
      [y{i}, FX{i}] = i_dyneval(m,x{i},delmat,y0i);
   end
   y= cat(1,y{:});
   FX= cat(1,FX{:});
else
   [y, FX] = i_dyneval(m,double(x),delmat,y0);
end
   

function [y, FX] = i_dyneval(m,x,delmat,y0)

FX=[];
if nargin < 3 | all( delmat(1,:) == 0 )
    % ordinary static evaluation
    y = eval(m,x);
    return
end

% check to see if can use dyneval_loimot_linear
lolimot = m.xreglolimot;
betamodels = get( lolimot, 'BetaModels' );
degree = max( get( betamodels{1}, 'order' ) );
kernel = get( lolimot, 'kernel' );
if degree == 1,
    [y, weights] = dyneval_lolimot_linear( m, x, delmat, y0 );
    return
end

% maximum delay indicates first output that can be calculated
md = max( sum( delmat, 1 ) );
if delmat(2,end) < 1 & delmat(1,end) ~= 0,
    error( 'Output delay must be positive' );
end

% not enough inputs to do a dynamic eval run
if md-1 >= size(x,1),
    y = repmat( NaN, size(x,1), 1 );
    return;
end

% indicies into expanded input 
ci = [ 1, 1 + cumsum( delmat(1,:) ) ];

% number of inputs
nf = size( delmat, 2 ) - 1;
xd = cell( 1, nf );
for i = 1:nf
    % indicies for input delays
    xd{i} = delmat(2,i):sum( delmat(:,i) ) - 1;
end

% indicies for output delays
yd = delmat(2,end):sum( delmat(:,end) ) - 1; 
y = zeros( size( x, 1 ), 1 );
if nargin > 3, 
    if length( y0 ) == md - 1,
        % initial outputs
        y(1:md-1) = y0;
    else
        warning( 'Initial condtion (ouput) vector is the wrong length' )
    end
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

xi = zeros(1,ci(end)-1);
FX = zeros(size(x,1),length(xi));
% loop through each x
for i = md:size( x, 1 )
    % build input delays 
    for j = 1:nf
        xi(ci(j):ci(j+1)-1) = x(i-xd{j},j)';
    end
    % previous model estimates
    xi(ci(end-1):ci(end)-1) = y(i-yd)';
    
    FX(i,:) = xi;
    
    % evaluate model with delays
    
    % call EVALSINGLE 
    %
    % y(i) = evalsingle(m,xi);
    %
    
    % compute the distance from x to each center
    dis = ( xi(ones_ncent_1,:) - centers ) ./ width;
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
        bx = [1, xi]; % for linear betamodels
    elseif degree == 0,
        bx = 1;
    else
        bx = x2fx( betamodels{1}, xi ); 
    end
    
    if ncent > bm_dim,
        yy = bx * ( beta * ww ); % if the ncenters is bigger than the dimension 
        %                          of the betamodels, this braketing is fastest.
    else
        yy = ( bx * beta ) * ww; % if the ncenters is smaller than the dimension 
        %                          of the betamodels, this braketing is fastest.
    end
    
    % end of EVALSINGLE, assign outputs
    y(i) = yy;
    
end

if nargin <= 3,
    % initial outputs set to NaN
    y0(1:md-1) = NaN;
end


%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|
