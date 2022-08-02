function m = xreglolimot( varargin )
%XREGLOLIMOT   LOLIMOT object constructor. Child of XREGRBF.
%   XREGLOLIMOT('nfactors',N) is an xreglolimot object set up to have N input 
%   factors. The defualt is N=1.
%
%   See also XREGRBF.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.6.1 $  $Date: 2004/02/09 07:50:58 $


if nargin >= 1,
    if isa( varargin{1}, 'xreglolimot' ),
        % Passed an existing XREGLOLIMOT object
        m = varargin{1};
        return
        
    elseif isa( varargin{1}, 'struct' ),
        % passed a struct of XREGLOLIMOT details (from LOADOBJ)
        old = varargin{1};
        m.betamodels = old.betamodels;
        if ~isfield( old, 'trainingdata' ),
            m.trainingdata = [];
        else
            m.trainingdata = old.trainingdata;
        end
        m = class( m, 'xreglolimot', old.xregrbf );
        return
    end
end

% Start with an RBF
rbf = xregrbf( varargin{:} );
rbf = set( rbf, 'lambda', 1.0 );
rbf = set( rbf, 'kernel', 'gaussian' );
rbf = set( rbf, 'width', get( rbf, 'centers' ) ); % width/ center/ dimension

% Initially, all betamodels will be linear functions
order = ones( 1, nfactors( rbf ) );
bm = xregcubic( order );
m.betamodels = cell( size( rbf ) );
[m.betamodels{:}] = deal( bm );

% Create a field to store training data
m.trainingdata = [];

% Turn the struct into a class object
m = class( m, 'xreglolimot', rbf );
m = update( m );

% Setup the OptimMgr and fitting algorithm,
om = fit_trialalpha( m ); %% fit_widthstep(m);
m = set( m, 'fitalg', 'rbffit' );
m = setFitOpt( m, om );

return

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|
