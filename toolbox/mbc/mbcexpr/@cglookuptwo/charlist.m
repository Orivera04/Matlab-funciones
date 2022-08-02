function out = charlist(LT);
%CHARLIST

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:11:30 $

% LookupTwo\charlist
%	out=charlist(LT)

F = getname(LT);
varx = LT.Xexpr;
vary = LT.Yexpr;

if isempty(varx) %2
   strx =  '.';
else
   strx = varx.charlist;
end

if isempty(vary);
   stry = '.';
else
   stry = vary.charlist;
end

out = [F,'(',strx,',',stry,')'];