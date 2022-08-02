function out = isempty(obj)
%ISEMPTY Check whether selection is empty
%
%  OUT = ISEMPTY(OBJ)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:52:29 $ 

out = numel(obj.solutionNo)==0;