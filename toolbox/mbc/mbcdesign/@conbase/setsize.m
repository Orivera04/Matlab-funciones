function c = setsize( c, sz )
%SETSIZE Reset the size of a constraint
%
%  C = SETSIZE(C,SZ) sets the number of inpits factors of C to SZ.
%  If SZ is less than the current size of C, then all data in C is
%  discarded and an all new object is formed. If SZ is greater than the
%  current size of C, then new variables are added to the begining of the
%  list. This means that a constraint on the global factors can be promoted
%  to a constraint on all input factors.
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:57:18 $ 

sznow = getsize( c );
if sz < sznow,
    warning( 'New size is less than old size. All data discarded' );
    c = feval( class( c ), sz );
elseif sz > sznow,
    c.Variables = [ false( 1, sz - sznow ), c.Variables ];
end
