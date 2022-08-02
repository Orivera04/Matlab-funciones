function str = char(N);
%CHAR

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:13:47 $

% cgnormalisers\char.
%	out=char(N)

str = getname(N);
if isempty(N.Xexpr);
   str = [str '(.)' ];
else
   varn = get(N,'xname');
   str = [str , '(' , varn , ')' ];
end