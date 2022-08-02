function T= loadobj(T)
% testplan/LOADOBJ

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:07:56 $

if isa(T,'struct')
   T= mdevtestplan(T);
end

if isempty( T.ConstraintData ),
    T.ConstraintData = xregpointer;
end
