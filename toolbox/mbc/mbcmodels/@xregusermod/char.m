function ch= char(U,TeX)
% xregusermod/CHAR string (possibly TeX) for display

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:00:56 $

if nargin<2
   TeX=1;
end



ch= feval(U.funcName,U,'char');
if isempty(ch)
   s= get(U,'symbol');
   if TeX
      s= detex(s);
   end
   c= labels(U);
   syms= sprintf('%s,',s{:});
   p= sprintf('%.3g,',U.parameters);
   if TeX
      ch= sprintf('%s([%s],\\beta=[%s', name(U),syms(1:end-1),p(1:end-1));
   else
      ch= sprintf('%s([%s],b=[%s', name(U),syms(1:end-1),p(1:end-1));
   end
   ch= [ch,'])'];
end