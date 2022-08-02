function ch=tostring(c,fact)
%TOSTRING  Create string representation of constraint
%  STR = TOSTRING(CON,FACTORS)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 06:59:49 $ 

fact = fact(variables( c ));

lsz = getsize( c.Local );
ch = sprintf( 'TwoStage(%s(%s', typename( c.Local ), fact{1} );
for i = 2:lsz,
    ch = strcat( ch, sprintf( ',%s', fact{i} ) );
end
ch = strcat( ch, ')' );
for i = (lsz+1):length( fact ),
    ch = strcat( ch, sprintf( ',%s', fact{i} ) );
end
ch = strcat( ch, ')' );
