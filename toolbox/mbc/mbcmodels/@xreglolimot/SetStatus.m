function [m] = setstatus( m, action, status )
%SETSTATUS Sets the (stepwise) status of the linear model parameters
%
%  M = SETSTATUS(M,I,S) sets the status of the lolimot model M as is done
%  in XREGLINEAR/SETSTATUS and then updates the status all of the beta
%  models.
%  M = SETSTATUS(M,'BetaModels') updates the status of the beta models
%  based on the status of the parent XREGLINEAR model.
%  M = SETSTATUS(M,'Parent') updates the status of the parent xreglinear
%  model by looking at the status of beta models.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 07:50:29 $


if ~ischar( action ) || ~strcmp( action, ':' ),
    % Call set status on the parent model object
    m.xregrbf = setstatus( m.xregrbf, action, status );

    % Update the beta models from the xreglinear object (below)
    action = 'BetaModels';
end

switch lower( action )
    case 'betamodels',
        status = getstatus( m );

        bm = m.betamodels(:);
        nb = length( status ) /size( bm{1}, 1 );
        if length( bm ) ~= nb,
            % make sure beta models is the right size
            bm = bm(ones( fix( nb ), 1 ));
        end
        z = 0;
        for i = 1:length( bm ),
            ell = size( bm{i}, 1  );
            bm{i} = setstatus( bm{i}, ':', status(z+(1:ell)) );
            z = z + ell;
        end
        m.xregrbf = setstatus( m.xregrbf, ':', status(1:z) );
        m.betamodels = bm;
    case 'parent',
        bm = m.betamodels(:);
        status = [];
        for i = 1:length( bm ),
            status = [ status; getstatus( bm{i} ) ];
        end
        m.xregrbf = setstatus( m.xregrbf, ':', status );
end
