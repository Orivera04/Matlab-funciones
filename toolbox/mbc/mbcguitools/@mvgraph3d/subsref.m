function out=subsref(gr,s)
%SUBSREF
%   Provides dot referencing interface for graph3d object.  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:20:02 $


% Bail if we've not been given a graph3d object
if ~isa(gr,'mvgraph3d')
   error('Cannot get properties: not a mvgraph3d object')
end

if length(s)>1 || ~strcmp(s(1).type,'.')
   error('Invalid indexing type');
end


out=get(gr,s.subs);