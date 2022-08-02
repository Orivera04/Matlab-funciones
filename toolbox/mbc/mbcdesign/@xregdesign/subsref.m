function val=subsref(des,s);
% DESIGN/SUBSREF  
%   Provides dot indexing for design object methods

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:07:52 $

% Created 29/10/99

if length(s)==1
   tp=s.type;
   fn=s.subs;
else
   tp=s(1).type;
   fn=s(1).subs;
end

if strcmp(tp,'.')
   val=feval(fn,des);
elseif strcmp(tp,'()')
   val=subsref(des.design,s(1));
end

if length(s)>1
   % carry on subsreffing
   val=subsref(val,s(2:end));   
end

return