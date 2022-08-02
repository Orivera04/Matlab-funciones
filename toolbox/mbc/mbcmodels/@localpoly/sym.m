function s=sym(p,var);
% SYM convert polynom object to character array for display

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 07:40:52 $



if nargin==1
   var='x';
end
var=sym(var);
s=poly2sym(p.c,var);
