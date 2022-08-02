function out=subsasgn(gr,s,in)
%GRAPH1D/SUBSASGN   Dot referencing interface.
%   Provides dot referencing interface to the set function for
%   graph1d object.  For more information on proerties available
%   see GRAPH1D/SET.  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:19:30 $

%  Date: 16/9/1999

% Bail if we've not been given a graph1d object
if ~isa(gr,'mvgraph1d')
   error('Cannot get properties: not a mvgraph1d object')
end

if length(s)>1 | ~strcmp(s(1).type,'.')
   error('Invalid indexing type');
end


out=set(gr,s.subs,in);