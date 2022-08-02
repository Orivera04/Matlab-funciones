function lab = labels( m, tex )
%LABELS List of names (labels) of the basis functions for a model
%
%  LABELS(M,TEX) is a list of names or labels for the basis functions that
%  the model M uses. TEX is an optinal flag to return LaTeX enabled labels.
%  By default, TEX is set to true.
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.2 $    $Date: 2004/02/09 07:50:47 $ 

if nargin < 2,
   tex = true;
end

nBetaModels   = numel( m.betamodels );
nCoefficients = numel( double( m ) );
nPerBeta      = nCoefficients/ nBetaModels;

% Format of the Labels.
% The labels for a lolitmot model are of the form 'p(x) Phi_i', where p(x)
% is a basis function (label) from a polynomial patch and Phi_i represents
% the i-th blending function.
if tex,
    format = '%s\\Phi_{%1d}';
else,
    format = '%sPhi_%1d';
end

% Labels of the Polynomial Patches.
% For speed, linear patches are done using an xreglinear rather than an
% xregcubic. However, the xreglinear labels are easily obtained directly
% from the factor names
if strcmpi( class( m.betamodels{1} ), 'xreglinear' ),
    BetaLabels = factorNames( m );
    BetaLabels = { '', BetaLabels{:} }';
else
    BetaLabels = labels( m.betamodels{1}, tex );
    ind = strmatch( '1', BetaLabels, 'exact' );
    [BetaLabels{ind}] = deal( '' );
end

% Build the Overall Labels.
lab = cell( nPerBeta, nBetaModels );
for j = 1:nPerBeta
    for i = 1:nBetaModels,
        lab{j,i} = sprintf( format, BetaLabels{j}, i );
    end
end
lab = { lab{:} }';
