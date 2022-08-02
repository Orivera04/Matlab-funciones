function lab=labels(m,TeX)
% xreglinear/LABELS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:49:41 $

if nargin<2
   TeX= 1;
end

start=1;
if m.Constant
   start=2;
end

lab= cell(size(m.Beta));
if TeX
   lab{1}='\beta_0';
   for i=start:size(m.Beta);
      lab{i}= ['\beta_{',sprintf('%1d',i-start+1),'}'];
   end
else
   lab{1}='Beta_0';
   for i=start:size(m.Beta);
      lab{i}= ['Beta_',sprintf('%1d',i-start+1)];
   end
end   