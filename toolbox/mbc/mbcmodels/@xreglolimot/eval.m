function [y, weights] = eval( m, x )
%EVAL   Evaluation of an XREGLOLIMOT model.
%   EVAL(M,X) is the vector values of the XREGLOLIMOT model evaluated at the 
%   points specified by X.
%   [Y, W] = EVAL(M,X) also rteurns the values of the RBF weight functions.
%
%   See also XREGLOLIMOT/EVALWEIGHT, XREGLOLIMOT/EVALSINGLE.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:50:34 $



error( nargchk( 2, 2, nargin ) );

% evalaute RBF weight functions
weights = evalweight( m, x );

% 
npts  = size( x,       1 ); % number of eval pts
ncent = size( weights, 2 ); % number of rbf centers

% evaluate the beta models
%%% This assumes that the beta models are different
% % beta = zeros( npts, ncent );
% % for i = 1:ncent,
% %     beta(:,i) = eval( m.betamodels{i}, x );
% % end
%%% Assume all the beta models are the same (and linear-- which they should be)
betadim = size( m.betamodels{1}, 1 );
betax = x2fx( m.betamodels{1}, x );
beta = betax * reshape( double( m ), betadim, ncent );

% 
y = sum( weights .* beta, 2 );

return

%------------------------------------------------------------------------------|
function y = alternate_version( m, x );

y = x2fx( m, x ) * double( m );

return

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|
