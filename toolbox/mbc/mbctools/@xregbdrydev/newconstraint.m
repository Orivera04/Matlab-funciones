function [con] = newconstraint( bdev )
%NEWCONSTRAINT A new constraint model for a boundary development node
%
%  C = NEWCONSTRAINT(BDEV) is a new constraint model for the boundary
%  development node BDEV. 
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.2 $    $Date: 2004/02/09 08:13:10 $ 

p = Parent( bdev );
if isempty( p ),
    sz = 1;
else
    switch p.getstages,
        case 0, % response constraint
            sz = size( p.getdata, 2 );
            con = constar( sz );
        case 1, % local constaint
            error( 'Local constraints not allowed for XREGBDRYDEV' )
        case 2, % 
            nlf = size( p.getdata( 'Local' ),  2 );
            ngf = size( p.getdata( 'Global' ), 2 );
            con = constar( nlf + ngf );
            con = setparams( con, 'Variables', [false( 1, nlf ), true( 1, ngf )] );
    end
end

