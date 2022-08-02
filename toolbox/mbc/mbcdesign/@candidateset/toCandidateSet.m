function newobj=toCandidateSet(obj)
% TOCANDIDATESET  Cast a candidateset class
%
%  CS=TOCANDIDATESET(OBJ) returns the parent candidate set
%  object from OBJ.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:56:52 $

% Created 1/11/2000


newobj=candidateset;

fnms=fieldnames(newobj);

s.type='.';
for i=1:length(fnms)
   s.subs=fnms(i);
   newobj=subsasgn(newobj,s,subsref(obj,s));
end
return

