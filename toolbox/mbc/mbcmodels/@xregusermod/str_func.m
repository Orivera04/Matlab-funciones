function ch= str_func(U,TeX);
% xregusermod/STR_FUNC one line summary (possibly TeX) of userdefined model

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:01:44 $

ch= feval(U.funcName,U,'str_func');
if isempty(ch)
   c= labels(U);
   s= get(U,'symbol');
   syms= sprintf('%s,',s{:});
   p = sprintf('%s,',c{:});
   ch= sprintf('%s([%s] , \\beta=[%s] )', name(U),syms(1:end-1),p(1:end-1));
end