function [con] = newconstraint( bdev )
%NEWCONSTRAINT A new constraint model for a boundary development node
%
%  C = NEWCONSTRAINT(BDEV) is a new constraint model for the boundary
%  development node BDEV. 
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.2 $    $Date: 2004/02/09 08:20:35 $ 

p = Parent( bdev );
if isempty( p ),
    lsz = 1;
    gsz = 1;
else
    d = p.getdata( 'Local' );
    lsz = size( d, 2 );
    d = p.getdata( 'Global' );
    gsz = size( d, 2 );
end

local  = conellipsoid( lsz );
gmodel = xreginterprbf( 'nfactors', gsz );

con = contwostage( local, gmodel );
