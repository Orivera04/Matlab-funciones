function fx = x2fx( m, x )
%X2FX   Regression matrix for XREGLOLIMOT
%   X2FX(M,X) is the regression matrix for XREGLOLIMOT model M at the data 
%   points X.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.6.1 $  $Date: 2004/02/09 07:50:56 $


% if no eval points given, then use the RBF centers
if nargin < 2,
    x = get( m, 'centers' );
end

% get the various basis functions
rbfx = evalweight( m, x );
N = size( rbfx, 2 ); % number of rbf centers

% Old code for which allows for different base betamodel
% betafx = cell( 1, N );
% for i = 1:N,
%     betafx{i} = x2fx( m.betamodels{i}, x );
% end
% M = cellfun( 'size', betafx, 2 ); % sizes of the betamodels

betafx = x2fx( m.betamodels{1} , x );
M = size(betafx,2);

% combine the rbf fx and the betamodel fx matrices into the overall fx matrix
fx = zeros( size( x, 1 ), M*N );
j = 1:M;
ExpandMatrix = ones( 1, M );
for i = 1:N,
    fx(:,j) = betafx .* rbfx(:,ExpandMatrix);
    j = j + M;
    ExpandMatrix = ExpandMatrix + 1;
end
return

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|
