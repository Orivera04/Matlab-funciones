function lab=labels(m,TeX)
% HYBRIDRBF/LABELS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:48:14 $

if nargin<2
   TeX= 1;
end

lab1 = labels(m.linearmodpart,TeX);
lab2 = labels(m.rbfpart,TeX);

lab = [lab1; lab2];