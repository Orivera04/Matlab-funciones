function str = charlist(LT);
% cglookupOne\charlist
% out=charlist(LT);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:12:17 $

str = getname(LT);
if isempty(get(LT, 'x'));
   str = [str '(.)' ];
else
   varn = get(LT,'x');
   str = [str,'(',varn.charlist,')'];
end


