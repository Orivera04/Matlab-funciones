function out=subsasgn(gr,s,in)
%SUBSASGN Dot-referencing for mvgraph2d
%   Provides dot referencing interface for mvgraph2d object.  
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:19:51 $


% Bail if we've not been given a graph2d object
if ~isa(gr,'mvgraph2d')
   error('Cannot get properties: not a mvgraph2d object')
end

if length(s)>1 | ~strcmp(s(1).type,'.')
   error('Invalid indexing type');
end


out=set(gr,s.subs,in);