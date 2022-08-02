function str = char( m, TeX, varargin )
%XREGARX/CHAR   Convert XREGARX object to character array.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:44:45 $

if nargin < 2,
    TeX = 0; % i.e., false
end

Title = 'Dynamic auto-regression with exogenous variables';
Frequency = sprintf( '   Sampling frequency: %2.2g', m.Frequency );
StaticModel = char( m.StaticModel );

nf = nfactors( m );
xi = xinfo( m );
yi = yinfo( m );
smxi = xinfo( m.StaticModel );

len = cellfun( 'length', xi.Symbols );
len = max( [ len(:); length( yi.Symbol ) ] );
if TeX,
    filter = sprintf( '   %%%d.%ds \\\\rightarrow %%s', len, len );
    xi.Symbols   = detex( xi.Symbols );
    yi.Symbol    = detex( yi.Symbol );
    smxi.Symbols = detex( smxi.Symbols );
else
    filter = sprintf( '   %%%d.%ds --> %%s', len, len );
end

Inputs = cell( 1, nf + 1 );
ci = [ 0, cumsum( m.DynamicOrder ) ];
for i = 1:nf,
    Inputs{i} = i_CommaSeperatedList( smxi.Symbols{ci(i)+1:ci(i+1)} );
    if isempty( Inputs{i} ),
        Inputs{i} = sprintf( filter, xi.Symbols{i}, 'ignored' );
    else
        Inputs{i} = sprintf( filter, xi.Symbols{i}, Inputs{i} );
    end
end
if m.DynamicOrder(end),
    Inputs{nf+1} = i_CommaSeperatedList( smxi.Symbols{ci(nf+1)+1:end} );
    if isempty( Inputs{nf+1} ),
        Inputs{nf+1} = sprintf( filter, yi.Symbol, 'ignored' );
    else
        Inputs{nf+1} = sprintf( filter, yi.Symbol, Inputs{nf+1} );
    end
end

str = strvcat( Title, Frequency, Inputs{:}, StaticModel );
return

%------------------------------------------------------------------------------|
function str = i_CommaSeperatedList( varargin )
if nargin,
    str = varargin{1};
    for i = 2:nargin,
        str = sprintf( '%s, %s', str, varargin{i} );
    end
else
    str = '';
end
return

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|
