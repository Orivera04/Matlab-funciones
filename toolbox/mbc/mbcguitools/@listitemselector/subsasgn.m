function out=subsasgn(sl,s,in)
%SUBSASGN   Dot referencing interface.
%   Provides dot referencing interface to the set function for
%   clickedit objects.  For more information on proerties available
%   see LISTITEMSELECTOR/SET.  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:18:09 $

% Created 3/2/2000

% Bail if we've not been given a listitemselector object
if ~isa(sl,'listitemselector')
   error('Cannot get properties: not a listitemselector object')
end

if length(s)>1 | ~strcmp(s(1).type,'.')
   error('Invalid indexing type');
end


out=set(sl,s.subs,in);