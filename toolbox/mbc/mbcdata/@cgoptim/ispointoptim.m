function out = ispointoptim(obj)
%ISPOINTOPTIM Check whether optimization is a point optimization
%
%  OUT = ISPOINTOPTIM(OPTIM) returns true of OPTIM is a point optimization -
%  that is if OPTIM contains only sum objectives and sum constraints.  Note
%  that this is not the opposite of ISSUMOPTIM since an optimization
%  can be in a state between the two when it has mixtures of point and sum
%  objects.  In this state the object cannot be run or viewed.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:53:43 $ 

if isempty(obj.objectiveFuncs) && isempty(obj.constraints)
    out = false;
else
    out = true;
    for n = 1:length(obj.objectiveFuncs)
        if obj.objectiveFuncs(n).issum
            out = false;
            break
        end
    end
    
    if out
        for n = 1:length(obj.constraints)
            if obj.constraints(n).issum
                out = false;
                break
            end
        end
    end
end