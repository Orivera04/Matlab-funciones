function lab= labels(m,TeX)
% labels parameter labels
%
% lab= labels(m,TeX)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
% $Revision: 1.1.6.2 $  $Date: 2004/02/09 07:52:26 $

if nargin<2
   TeX= 1;
end

p= size(m,1);

lab= cell(p,1);
if TeX
   for i=1:p
      lab{i}= ['\beta_{',sprintf('%1d',i),'}'];
   end
else
   for i=1:p
      lab{i}= ['B_',sprintf('%1d',i)];
   end
end   