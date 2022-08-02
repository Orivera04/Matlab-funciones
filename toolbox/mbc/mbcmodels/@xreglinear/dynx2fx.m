function fx = dynx2fx( m, x, delmat, y0 )
%XREGLINEAR/DYNX2FX   Parallel mode regression matrix for dynamic models.
%   DYNX2FX(M,X,DELMAT,Y0) is the regression matrix for the model M at the data 
%   points X with the evaluation performed in dynamic parallel mode. DELMAT is 
%   the 2 by (NF+1) delay and order matrix, where NF is the number of inputs to 
%   the overall dynamic model. Note that this maybe different to NFACTORS(M). 
%   The first row of DELMAT is the dynamic order vector, with feedback order 
%   last, and the second row is the delay vector. Note the delay on the 
%   feedback, i.e., DELMAT(2,end), must be greater than zero. Y0 is a vector 
%   optional vector of initial conditions. Default initial condition is all 
%   zeros.
%
%   See also: XREGLINEAR/X2FX, XREGLINEAR/FEEDBACKX2FX, XREGMODEL/DYNEVAL.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:49:26 $


if nargin < 3 | all( delmat(1,:) == 0 )
   % ordinary static evaluation
   fx = x2fx( m, x );
   return
end

% maximum delay indicates first output that can be calculated
md = max( sum( delmat, 1 ) )  + 1;
if delmat( 2, end ) < 1
   error( 'Output delay must be positive' );
end

% indicies into expanded input 
ci = [ 1, 1 + cumsum( delmat(1,:) ) ];

% number of inputs
nf= size( delmat, 2 ) - 1;
xd= cell( 1, nf );
for i = 1:nf
   % indicies for input delays
   xd{i} = delmat(2,i):sum( delmat(:,i) ) - 1;
end

% indicies for output delays
yd = delmat(2,end):sum( delmat(:,end) ) - 1; 
y = zeros( size(x,1), 1 );
if nargin > 3
   % initial outputs
   y(1:md-1) = y0;
end

% get model coefficients
beta = double( m );

xi = zeros( 1, ci(end) - 1 );
FX = zeros( size( x, 1 ), length( m ) );
% loop through each x
for i = md:size( x, 1 )
   % build input delays 
   for j = 1:nf
      xi(ci(j):ci(j+1)-1) = x(i-xd{j},j)';
   end
   % previous model estimates
   xi(ci(end-1):ci(end)-1) = y(i-yd)';

   % compute regression matrix with delays
   fx(i,:) = x2fx( m, xi );
   
   % evaluate model for feedback
   y(i) = fx(i,:) * beta;
end

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|
