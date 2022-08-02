function str = charlist(N);
%CHARLIST

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:13:48 $

% cgNormalisers\charlist.
%	out=charlist(N)

str = getname(N);
if isempty(N.Xexpr);
   str = ['Output = ',str '(.)' ];
else
   str = [str,'(',N.Xexpr.charlist,')'];
end