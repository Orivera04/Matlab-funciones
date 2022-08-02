function root = addtbest( root, best )
%ADDBEST Set the best model for a boundary tree
%
%  ROOT = ADDBEST(ROOT,BEST), where BEST is an XREGBDRYDEV, a pointer to an
%  XREGBDRYDEV or an index into the children of root.
%
%  See also: XREGBDRYDEV/SETBEST, XREGBDRYDEV/REMOVEBEST.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 08:13:23 $ 

if isa( best, 'xregpointer' ),
    root.Best = [ root.Best, best ];
    
elseif isa( best, 'xregbdrydev' ),
    root.Best = [ root.Best, xregpointer( best ) ];
    
elseif isa( best, 'numeric' ),
    c = children( root );
    root.Best = [ root.Best, c(best) ];
    
else
    error( 'mbc:xregbdryroot:InvalidArgument', 'Invalid argument BEST' );
end

root.Best = unique( root.Best );
xregpointer( root );
