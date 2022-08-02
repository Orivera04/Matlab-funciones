function ch= char(L,TeX);
%LOCALAVFIT/CHAR

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:37:33 $

if nargin<2
   TeX=1;
end
ch= char(L.model,TeX);
