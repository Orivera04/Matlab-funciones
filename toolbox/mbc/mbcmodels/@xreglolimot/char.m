function str = char( m, varargin )
%CHAR   Convert XREGLOLIMOT object to character array.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:50:31 $


% Title line
str1 = sprintf( 'LOLIMOT model:' );

% Kernel information
kernel = get( m, 'kernel' );
str2 = sprintf( '  %s kernel', kernel );

% Number of centers
ncent = size( get( m, 'centers' ), 1 );
str3 = sprintf( '  %d centers', ncent );

% Details about beta models
bm = get( m, 'betamodels' );
bmc = cell( 1, ncent );
for i=1:ncent,
    bmc{i} = name( bm{i} ); % char(bm{i} ); % 
end
bmc = unique( bmc );
str4 = cat( 2, 'Beta models: ', bmc{:} );
%%str4 = strvcat( 'Beta models: ', bmc{:} );

str = strvcat( str1, str2, str3, str4 );

return

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|
