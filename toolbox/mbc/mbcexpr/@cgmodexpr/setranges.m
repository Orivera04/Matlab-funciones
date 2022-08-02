function M = setranges(M , R)
%SETRANGES Set the model input ranges
%
%  M = SETRANGES(M,rangeMatrix) where RangeMatrix is a double array [2 x
%  nfactors]

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:13:27 $

if ~isempty(M.model)
	M.model = setranges(M.model, R);
end