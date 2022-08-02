function E = set(E,prop,val)
%SET

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:47:44 $

% Set command for exportmodels
%       name - String
%       info - Information structure
%       constraints - Constraints structure

switch prop
case 'name'
	E = setname(E,val);
case 'info'
	E = setinfo(E,val);
case 'constraints'
	E = setconstraints(E,val);
case 'range'
	E = setranges(E,val);
case 'symbols'
	E = setsymbols(E,val);
end

   
   