function ret = isSwitchPoint(m)
%ISSWITCHPOINT Check whether a point is a valid evaluation site
%
%  RET = ISSWITCHPOINT(OBJ) returns a logical vector the same length as the
%  inport variables containing true where the corresponding evaluation
%  point is a valid evaluation site for the switched expression.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 07:08:56 $ 

pInp = getinputs(m);
if isempty(pInp)
    ret = true(size(i_eval(m), 1), 1);
elseif ~all(isvalid(pInp))
    error('mbc:cgexpr:InvalidState', 'Some of the input expression pointers are invalid.');
else
    objInp = info(pInp);
    if ~iscell(objInp)
        ret = isSwitchPoint(objInp);
    else
        ret = true;
        for n = 1:length(pInp)
            ret = ret & isSwitchPoint(objInp{n});
            if ~any(ret)
                break
            end
        end
    end
end