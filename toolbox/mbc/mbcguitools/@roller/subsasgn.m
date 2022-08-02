function out=subsasgn(rl,s,in)
%ROLLER/SUBSASGN
%   Provides dot referencing interface for roller object.  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:20:28 $


% Bail if we've not been given a roller object
if ~isa(rl,'roller')
   error('Cannot set properties: not a roller object')
end

if length(s)>1 | ~strcmp(s(1).type,'.')
   error('Invalid indexing type');
end


out=set(rl,s.subs,in);