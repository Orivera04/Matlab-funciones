function out=subsref(gr,s)
%GRAPH1D/SUBSREF
%   Provides dot referencing interface for graph1d object.
%   For more information on the properties available, see
%   GRAPH1D/GET.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:19:31 $

%  Date: 16/9/1999

% Bail if we've not been given a graph1d object
if ~isa(gr,'mvgraph1d')
   error('Cannot get properties: not a mvgraph1d object')
end

if length(s)>1 | ~strcmp(s(1).type,'.')
   error('Invalid indexing type');
end


out=get(gr,s.subs);