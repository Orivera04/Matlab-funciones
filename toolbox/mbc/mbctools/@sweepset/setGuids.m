function [ss] = setGuid(ss, guid)
%SETGUID set function for sweepset guid array
%
%  SS = SETGUID(SS, GUIDARRAY)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 08:11:31 $ 

% Is it a guidarray?
if ~isa(guid, 'guidarray')
    error('mbc:sweepset:InvalidArgument', 'Second argument must be a guidarray object');
end

% Check the size
if length(guid) ~= size(ss.data, 1)
    error('mbc:sweepset:InvalidArgument', 'guidarray object must be the same size as the number of records in the sweepset');
end
   
% Set it
ss.guid = guid;