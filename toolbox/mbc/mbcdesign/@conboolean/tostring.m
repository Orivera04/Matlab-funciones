function ch = tostring(obj,fact)
%TOSTRING  Create string representation of constraint
%
%  STR = TOSTRING(CON,FACTORS)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:57:38 $ 

nc = length( obj.Constraints ); % number of constraints

if nc > 1,
    ch = cell( 1, 2*nc-1 );
    for i = 1:nc,
        ch{2*i-1} = tostring( obj.Constraints{i}, fact );
    end
    [ch{2:2:(end-1)}] = deal( sprintf( ' %s ', upper( obj.Op ) ) );
    ch = [ ch{:} ];
elseif nc == 1 & strcmpi( obj.Op, 'none' ),
    ch = tostring( obj.Constraints{1}, fact );
else
    ch = 'Empty boolean constraint';
end


if nc > 0 && obj.Not,
    ch = [ 'NOT( ', ch, ' )' ];
else,
    ch = [ '( ', ch, ' )' ];
end
