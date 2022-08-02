function lab= labels(ts,TeX);
%% TRUNCPS\LABELS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:43:06 $

if nargin<2
   TeX= 1;
end

lab= cell(size(ts));
nk= length(ts.knots);
for i=1:nk
   lab{i}= sprintf('k_%d',i);
end

m= ts.order;
tsstat= Terms(ts);
j= 1;

if TeX
   for i=1:m
      if tsstat(i)
         lab{j+nk}= sprintf('\\beta_%d',m-i);
         j=j+1;
      end
   end
   
   for i=1:length(lab)-j-nk+1
      lab{i+nk+j-1}= sprintf('\\beta_{s%d}',i);
   end
else
   for i=1:m
      if tsstat(i)
         lab{j+nk}= sprintf('B_%d',m-i);
         j=j+1;
      end
   end
   
   for i=1:length(lab)-j-nk+1
      lab{i+nk+j-1}= sprintf('B_s%d',i);
   end
end
