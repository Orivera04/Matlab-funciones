function m = model( bd )
%MODEL Constraint model for the boundary development object
%
%  C = MODEL(BDEV) is the constraint model that is stored in the
%  boundary development object BDEV.
%
%  *** This method is now obselete. Use GETCONSTRAINT instead. ***

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 08:13:09 $ 

warning( 'Obselete function' );

m = getconstraint( bd );
