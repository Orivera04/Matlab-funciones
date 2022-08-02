function y= CalcYinv(m,y);
% MODEL/YINV

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:51:00 $

if ~isempty(m.yinv)
   y= m.yinv(y);   
elseif m.TransBS & ~isempty(m.ytrans)
   ws= warning;
   warning off
   % Calculate inverse transformation using symbolic toolbox
   invs   = finverse(sym(m.ytrans));
   warning(ws)
   % make sure inline functions are vectorized (i.e. use .*,./,.^)
   invs = inline(invs);
   y= invs(y);
end