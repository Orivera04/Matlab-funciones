function L= update(L,param,dat)
% USERLOCAL/UPDATE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:42:44 $

in= linterms(L);
p= zeros(length(in),1);
p(in)= param;
L.userdefined= update(L.userdefined,p);

if nargin>2 & ~isempty(dat)
   L= datum(L,dat);
end