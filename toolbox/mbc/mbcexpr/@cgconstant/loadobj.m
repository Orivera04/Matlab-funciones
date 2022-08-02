function C = loadobj(C)
%LOADOBJ  Load-time actions
%
% OBJ = LOADOBJ(OBJ)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:08:20 $


if isstruct(C)
    % Update from pre-precision objects
    if ~isfield(C , 'prec')
        C.prec = cgprecfloat('double');
    end
end



if isstruct(C)
    C = cgconstant(C);
end