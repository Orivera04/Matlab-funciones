function c= labels(U, TeX);
% xregusermod/LABELS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:01:20 $

if nargin<2
   TeX= 1;
end

c= feval(U.funcName,U,'labels');

if isempty(c)
   c= cell(size(U.parameters));
   if TeX
      for i=1:length(c)
         c{i}= sprintf('\\beta_{%d}',i);
      end
   else
      for i=1:length(c)
         c{i}= sprintf('B_%d',i);
      end
   end
end