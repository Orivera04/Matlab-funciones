function out = char(LT);
%CHAR

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:11:29 $

% LookupTwo\char
%	out=char(LT)

F = getname(LT);
varx = LT.Xexpr;
vary = LT.Yexpr;

if isempty(varx) %2
   strx =  '.';
else
   strx = varx.char;
end

if isempty(vary);
   stry = '.';
else
   stry = vary.char;
end

out = [F,'(',strx,',',stry,')'];