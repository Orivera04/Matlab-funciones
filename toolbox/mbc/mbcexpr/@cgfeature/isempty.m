function out = isempty(obj)
%ISEMPTY Check if feature is empty
%
%  OUT = ISEMPTY(OBJ)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:10:47 $

out = isempty(obj.modelexpr) || isempty(obj.eqexpr);