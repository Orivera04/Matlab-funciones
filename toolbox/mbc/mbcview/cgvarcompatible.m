function OK = cgvarcompatible(v,w)
%CGVARCOMPATIBLE Determines whether two variables depend on each other.
%  OK = cgvarcompatible(v,w)
% Returns non-zero if:
%  v & w are pointers to the same cgvalue
%  One of v & w is a symvalue, and is a function of the other
% Returns zero otherwise.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.4.2.3 $  $Date: 2004/02/09 08:39:45 $
OK = 0;
if v.isddvariable & w.isddvariable
    if v == w
        OK = 1;
    else
        if v.issymvalue
            v = v.getrhsptrs;
            if any(v == w)
                OK = 1;
            end
        else
            if w.issymvalue
                w = w.getrhsptrs;
                if any(w == v)
                    OK = 1;
                end
            end
        end
    end
end
