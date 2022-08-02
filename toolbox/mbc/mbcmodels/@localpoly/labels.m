function lab=labels(m, TeX)
% POLYNOM/LABELS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:40:30 $

if nargin<2
   TeX= 1;
end

lab= labels(m.xreglinear,TeX);

lab= lab(end:-1:1);