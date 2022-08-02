function str = char(LT);
% cglookupOne\char
% out=char(LT);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:12:16 $

str = getname(LT);
dummyNorm = get(LT.cgnormfunction, 'x');
if isempty(dummyNorm.info);
   str = [str '(.)' ];
else
   varn = dummyNorm.get('xname');
   str = [str,'(',varn,')'];
end


