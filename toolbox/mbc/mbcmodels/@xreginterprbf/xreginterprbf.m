function m = xreginterprbf( varargin )
%XREGINTERPRBF Interpolating RBF constructor. Child of xreghybridrbf
%   XREGINTERPRBF

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.8.1 $    $Date: 2004/02/09 07:48:57 $ 

if nargin == 1 & isa( varargin{1}, 'xreginterprbf' ),
    m = varargin{1};
else,
    % create deafult object
    hybridrbf = xreghybridrbf( varargin{:} );
    rbf = get( hybridrbf, 'RbfPart' );
    poly = get( hybridrbf, 'linearmodpart' );
    rbf = set( rbf, 'kernel', 'thinplate' );
    rbf = set( rbf, 'Width', 1 );
    rbf = set( rbf, 'Lambda', 0 );
    rbf = setFitOpt( rbf, [] );
    poly = set( poly, 'order', ones(nfactors(hybridrbf),1) );
    poly = set( poly, 'maxinteract', 1 );
    hybridrbf = set( hybridrbf, 'RbfPart', rbf );
    hybridrbf = set( hybridrbf, 'linearmodpart', poly );
    
    m.version = 1;
    m = class( m, 'xreginterprbf', hybridrbf );
    
    [om,OK] = interpolate(m);
    m = set( m, 'fitalg', om ); % default fit algorithm

end

% EOF
