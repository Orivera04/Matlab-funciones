function ret = isSwitchPoint(m)
%ISSWITCHPOINT Check whether a point is a valid evaluation site
%
%  RET = ISSWITCHPOINT(OBJ) returns a logical vector the same length as the
%  inport variables containing true where the corresponding evaluation
%  point is a valid evaluation site for the switched expression.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 07:13:16 $ 

ret = isSwitchPoint(m.cgexpr);

if isSwitchModel(m.model) && any(ret)
    pInp = getinputs(m);
    inputs = pveceval(pInp,@i_eval);
    Xlen = max(cellfun('prodofsize', inputs));
    X = zeros(Xlen, length(pInp));
    for n = 1:size(X,2)
        X(:,n) = inputs{n};
    end
    ret = ret & isSwitchPoint(m.model, X);
end
