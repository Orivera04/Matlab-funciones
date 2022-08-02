function ret = isSwitchModel(m)
%ISSWITCHMODEL Return true if model is a switching model
%
%  RET = ISSWITCHMODEL(M) returns true for switching models.  These model
%  types have valid evaluations only at certain input points.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 07:57:51 $ 

ret = isSwitchModel(m.mvModel);