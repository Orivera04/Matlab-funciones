function [y, weights] = evalsingle( m, x )
%XREGLOLIMOT/EVALSINGLE   Evaluation of an XREGLOLIMOT model at a signle point
%   EVALSINGLE(M,X) is the value of the XREGLOLIMOT model M evaluated at the 
%   point specified by X.
%   [Y, W] = EVAL(M,X) also rteurns the values of the RBF weight functions at X.
%
%   See also XREGLOLIMOT/EVAL, XREGLOLIMOT/EVALWEIGHT.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:50:36 $


% get the required infomation from lolimot model
centers = get( m, 'centers' );
width   = get( m, 'width' );
kernel  = get( m, 'kernel' );

% number of centers
ncent = size( centers, 1 ); 

% compute the distance from x to each center
dis = ( repmat( x, ncent, 1 ) - centers ) ./ width;
dis = sum( dis.^2, 2 );

% compute the values of the rbf kernel
phi = feval( kernel, dis, set( m, 'width', 1.0 ) ); % CHECK ME!

% compute weight function values
sum_phi = sum( phi );
if abs( sum_phi ) < eps,
    if sum_phi == 0,
        sum_phi = eps;
    else
        sum_phi = sign( sum_phi ) * eps;
    end
end
weights = phi /sum_phi;

% Form the x2fx matrix for the betamodels
% Assume beta models are the same type so this x2fx matrix will apply to all 
% beta models
bm = get( m, 'BetaModels' );
degree = max( get( bm{1}, 'order' ) );
if degree == 1,
    bx = [1, x]; % for linear betamodels
elseif degree == 0,
    bx = 1;
else
    bx = x2fx( bm{1}, x ); 
end

beta = reshape( double( m ), size( bx, 2 ), ncent );
if ncent > size( bx, 2 ),
    y = bx * ( beta * weights ); % if the ncenters is bigger than the dimension 
    %                          of the betamodels, this braketing is fastest.
else
    y = ( bx *  beta ) * weights; % if the ncenters is smaller than the dimension 
    %                          of the betamodels, this braketing is fastest.
end
weights = weights';

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|
