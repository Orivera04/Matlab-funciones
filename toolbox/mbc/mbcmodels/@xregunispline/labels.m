function lab = labels(bs,TeX)
%LABELS  Return labels for model
%
%  LABELS(M) returns a cell array containing the input labels for the
%  model.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $  $Date: 2004/02/09 07:58:35 $

if nargin<2
   TeX= 1;
end
lab = labels(bs.mv3xspline,TeX);
