function [obj, ss] = pTestplanSweepsetfilterChanged(obj, ss)
%PTESTPLANSWEEPSETFILTERCHANGED A short description of the function
%
%  [OBJ, SS] = PTESTPLANSWEEPSETFILTERCHANGED(OBJ, SS)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 08:11:26 $ 

% When the tssf has changed we need to let the ssf know that the cache
% needs updating
[obj, ss] = pUpdateSweepsetCache(obj, ss);