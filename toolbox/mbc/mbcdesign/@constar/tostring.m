function ch=tostring(c,fact)
%TOSTRING  Create string representation of constraint
%  STR = TOSTRING(CON,FACTORS)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.6.1 $    $Date: 2004/02/09 06:59:13 $ 
fact = fact(variables( c ));

ch = sprintf( 'R(%s%+.2g', fact{1}, -c.Center(1) );
for i = 2:length( fact ),
    ch = strcat( ch, sprintf( ',%s%+.2g', fact{i}, -c.Center(i) ) );
end
ch = strcat( ch, ') < 0' );
