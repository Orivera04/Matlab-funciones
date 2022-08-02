function in = constrainlocal( con, beta, L, in )
%CONSTRAINLOCAL Constrain a list of local points
%
%  IN = CONSTRAINLOCAL(C,B,L,IN) is a logical vector indicating which local
%  points L are within the constrained region. IN is a logical vector
%  indicating which points to constrain and which to ignore, i.e., which
%  points are currently considered to be "in" the constrained region.  B is
%  a vector of parameters to use for the local constraint.
%  
%  See also CONTWOSTAGE/CONSTRAIN.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:59:33 $ 

lc = setparams( c.Local, beta );
in = constrain( lc, L, in );
