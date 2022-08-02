function out=isdsvariable(obj)
%ISDSVARIABLE  indicate if object may be a dataset factor
%
%  returns 0/1

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:16:46 $

out = ~isconstant(obj);