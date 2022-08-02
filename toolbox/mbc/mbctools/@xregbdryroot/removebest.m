function root = removebest( root, best )
%REMOVEBEST Removes a model from the list of best models for a boundary tree
%
%  ROOT = REMOVEBEST(ROOT,BEST), where BEST is an XREGBDRYDEV, a pointer to an
%  XREGBDRYDEV or an index into the children of root.
%
%  See also: XREGBDRYDEV/ADDBEST, XREGBDRYDEV/SETBEST.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 08:13:38 $ 

if isa( best, 'xregbdrydev' ),
    best = xregpointer( best );
    
elseif isa( best, 'numeric' ),
    c = children( root );
    best = c(best);
    
elseif ~isa( best, 'xregpointer' ),
    error( 'mbc:xregbdryroot:InvalidArgument', 'Invalid argument BEST' );
end

ind = findptrs( best, root.Best );
if all( ind > 0 ),
    root.Best(ind) = [];
end

xregpointer( root );
