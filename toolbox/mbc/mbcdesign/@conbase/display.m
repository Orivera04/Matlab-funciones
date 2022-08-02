function  display( c )
%DISPLAY The display method for CONBASE objects.
%  DISPLAY(C) displays the constraint C.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 06:56:58 $ 

nf = getsize( c ); % number of factors

% generate factor names
fact = cell( 1, nf );
for i = 1:nf,
    fact{i} = sprintf( 'X%d', i );
end

% get the spacing right
if isequal( get( 0, 'FormatSpacing' ), 'compact' )
    blankline = '';
else
    blankline = ' ';
end

% generate string for constraint
str = tostring( c, fact );
b = blanks( size( str, 1 ) );

% display string
disp( blankline );
disp( [ inputname(1), ' =' ] );
disp( blankline );
disp( [ b', b', b', str ] )

% EOF


