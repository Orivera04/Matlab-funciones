function lab=labels(m,TeX)
% RBF/LABELS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:54:54 $

if nargin<2
   TeX= 1;
end

start=1;
Beta = double(m);
lab= cell(size(Beta));

if TeX %% viewing labels in LaTeX
   for i=start:length(Beta);
      lab{i}= ['\beta_{',sprintf('%1d',i-start+1),'}'];
   end
else
   for i=start:length(Beta);
      lab{i}= ['B_',sprintf('%1d',i-start+1)];
   end
end