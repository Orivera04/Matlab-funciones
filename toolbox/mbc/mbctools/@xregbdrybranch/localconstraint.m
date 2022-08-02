function con = localconstraint( bd, n )
%LOCALCONSTRAINT Local constraint model for a particular sweep.
%
%  CON = LOCALCONSTRAINT(BD,N) is the boundary constraint for the N-th
%  sweep.
%  
%  See also: XREGBDRYROOT/GETCONSTRAINT.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 08:12:53 $

best = getbest( bd );
nbest = size( best, 2 );

switch nbest,
    case 0,
        con = [];
        
    case 1,
        con = best.localconstraint( n );
        
    otherwise
        con = localconstraint( best(1).info, n );
        for i = 2:nbest,
            con2 = localconstraint( best(i).info, n );
            if isempty( con ),
                con = con2;
            elseif ~isempty( con2 ),
                con = con & con2;
            end
        end
end
