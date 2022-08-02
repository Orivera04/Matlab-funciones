function M=revertRanges(M)
%REVERTRANGES Internal function to revert the ranges to the defaults stored in the model

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:57:58 $

[Low,Upp]=range(M.mvModel);
M = setranges(M,[Low(:)';Upp(:)']);
