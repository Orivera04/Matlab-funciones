function out=subsasgn(gr,s,in)
%SUBSASGN
%   Provides dot referencing interface for graph2d object.  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:20:01 $


% Bail if we've not been given a graph3d object
if ~isa(gr,'mvgraph3d')
   error('Cannot get properties: not a mvgraph3d object')
end

if length(s)>1 || ~strcmp(s(1).type,'.')
   error('Invalid indexing type');
end


out=set(gr,s.subs,in);