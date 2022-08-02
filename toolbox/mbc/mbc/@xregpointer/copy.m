function [NewRefs,RefMap] = copy(refs,inf)
%COPY Copy a list of pointers to a new location on the heap
%
%  [NewP, RefMap] = COPY(p) makes deep copies of the information pointed to
%  by P and returns the new locations of the copies on the heap.
%
%  [NewP, RefMap] = COPY(p, INFO) where INFO is a cell array of data that
%  resides at location p, copies the provided information instead of
%  accessing the heap for it.
%
%  NewP is an array of pointers to new locations and RefMap is a map of
%  pointers to be used for other mapptr calls
%
%  Note that a mapptr method must be defined if any object contains
%  pointers.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.4.3 $  $Date: 2004/02/09 06:47:00 $

if nargin==1
	inf = infoarray(refs);
end

% Get size of input so it can be used later to reshape the output
sz = size(refs.ptr);

% make sure this is unique 
[refs.ptr,I,J] = unique(refs.ptr);
inf = inf(I);

% allocate new dynamic memory
NewRefs = refs;
NewRefs.ptr = HeapManager(4, numel(refs.ptr));

% RefMap must be a cell array to avoid calling pointer/mapptr in 
% the following loop
RefMap= {refs,NewRefs};

% put info on heap
for i=1:numel(refs.ptr)
    HeapManager(2,NewRefs.ptr(i) , mapptr(inf{i},RefMap) );
end

% put in original order and shape
NewRefs.ptr= NewRefs.ptr(J);
NewRefs.ptr= reshape(NewRefs.ptr, sz);
