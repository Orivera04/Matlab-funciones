function c = getconstraint( bd, nf )
%GETCONSTRAINT Constraint object for the boundary development object
%
%  C = GETCONSTRAINT(BDEV) is the constraint object that is stored in the
%  boundary development object BDEV.
%  
%  C = GETCONSTRAINT(BDEV,NF) ensures that C has NF input factors.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 08:13:03 $ 

c = bd.Model;

if nargin >= 2 && ~isempty( c ) && getsize( c ) < nf,
    c = setsize( c, nf );
end
