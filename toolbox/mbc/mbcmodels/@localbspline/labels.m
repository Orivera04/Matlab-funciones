function lab= labels(bs,TeX);
%% LOCALBSPLINE|LABELS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:38:16 $

if nargin<2
   TeX= 1;
end

lab= cell(size(bs));
nk= get(bs.xreg3xspline,'numknots');

if TeX
   for i=1:nk
      lab{i}= sprintf('k_%d',i);
   end
   
   PHI= double(bs.xreg3xspline);
   for j=1:length(PHI)
      lab{j+nk}= sprintf('\\beta_%d',j);
   end
   
else
   
   for i=1:nk
      lab{i}= sprintf('knot_%d',i);
   end
   
   PHI= double(bs.xreg3xspline);
   for j=1:length(PHI)
      lab{j+nk}= sprintf('B_%d',j);
   end
end