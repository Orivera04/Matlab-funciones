function p=assign(p,d)
% XREGPOINTER/ASSIGN assigns a pointer to point to given location in heap
%
% p=assign(p,d) returns a pointer to location d in heap. 
%               No checking as to whether this is a valid location is performd

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.5.4.2 $  $Date: 2004/02/09 06:46:57 $




if ~isa(d,'double') | d~=fix(d) | d<0  
   error('Invalid Pointer Location')
end

p.ptr= d;
