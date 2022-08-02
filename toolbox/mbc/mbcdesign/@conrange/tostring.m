function ch = tostring( c, factors )
%TOSTRING  Create string representation of constraint
%  STR = TOSTRING(CON,FACTORS)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:58:53 $ 

factors = factors(variables( c ));

a = c.Center - c.HalfWidth;
b = c.Center + c.HalfWidth;

ch = sprintf( '%.2g<=%s<=%.2g', a(1), factors{1}, b(1) );
for i = 2:length( factors ),
    ch = strcat( ch, sprintf( ' & %.2g<=%s<=%.2g', a(i), factors{i}, b(i) ) );
end
