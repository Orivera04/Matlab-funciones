function c= update(c,Wp)
%UPDATE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:46:32 $


Wp=Wp(:)';
nw= length(c.wparam);
if ~isempty(c.wfunc)
   c.wparam= Wp(1:nw);
end

if ~isempty(c.cfunc)
   c.cparam= Wp(nw+1:end);
end  
